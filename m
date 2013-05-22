Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3EVQ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:28:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3EVQ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:28:16 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] firmware: Avoid deadlock of usermodehelper lock at shutdown
Date: Wed, 22 May 2013 18:28:38 +0200
Message-Id: <1369240118-5459-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369240118-5459-1-git-send-email-tiwai@suse.de>
References: <1369240118-5459-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a system goes to reboot/shutdown, it tries to disable the
usermode helper via usermodehelper_disable().  This might be blocked
when a driver tries to load a firmware beforehand and it's stuck by
some reason.  For example, dell_rbu driver loads the firmware in
non-hotplug mode and waits for user-space clearing the loading sysfs
flag.  If user-space doesn't clear the flag, it waits forever, thus
blocks the reboot, too.

As a workaround, in this patch, the firmware class driver registers a
reboot notifier so that it can abort all pending f/w bufs before
issuing usermodehelper_disable().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2:
 - get rid of enable flag check
 - use an individual list for avoid link corruption

 drivers/base/firmware_class.c | 44 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4b1f926..e650c25 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -27,6 +27,7 @@
 #include <linux/pm.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/reboot.h>
 
 #include <generated/utsrelease.h>
 
@@ -130,6 +131,7 @@ struct firmware_buf {
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
+	struct list_head pending_list;
 #endif
 	char fw_id[];
 };
@@ -171,6 +173,9 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+	INIT_LIST_HEAD(&buf->pending_list);
+#endif
 
 	pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
 
@@ -446,10 +451,9 @@ static struct firmware_priv *to_firmware_priv(struct device *dev)
 	return container_of(dev, struct firmware_priv, dev);
 }
 
-static void fw_load_abort(struct firmware_priv *fw_priv)
+static void fw_load_abort(struct firmware_buf *buf)
 {
-	struct firmware_buf *buf = fw_priv->buf;
-
+	list_del_init(&buf->pending_list);
 	set_bit(FW_STATUS_ABORT, &buf->status);
 	complete_all(&buf->completion);
 }
@@ -457,6 +461,25 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
 #define is_fw_load_aborted(buf)	\
 	test_bit(FW_STATUS_ABORT, &(buf)->status)
 
+static LIST_HEAD(pending_fw_head);
+
+/* reboot notifier for avoid deadlock with usermode_lock */
+static int fw_shutdown_notify(struct notifier_block *unused1,
+			      unsigned long unused2, void *unused3)
+{
+	mutex_lock(&fw_lock);
+	while (!list_empty(&pending_fw_head))
+		fw_load_abort(list_first_entry(&pending_fw_head,
+					       struct firmware_buf,
+					       pending_list));
+	mutex_unlock(&fw_lock);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block fw_shutdown_nb = {
+	.notifier_call = fw_shutdown_notify,
+};
+
 static ssize_t firmware_timeout_show(struct class *class,
 				     struct class_attribute *attr,
 				     char *buf)
@@ -604,6 +627,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 			 * is completed.
 			 * */
 			fw_map_pages_buf(fw_buf);
+			list_del_init(&fw_buf->pending_list);
 			complete_all(&fw_buf->completion);
 			break;
 		}
@@ -612,7 +636,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
 		/* fallthrough */
 	case -1:
-		fw_load_abort(fw_priv);
+		fw_load_abort(fw_buf);
 		break;
 	}
 out:
@@ -680,7 +704,7 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 		new_pages = kmalloc(new_array_size * sizeof(void *),
 				    GFP_KERNEL);
 		if (!new_pages) {
-			fw_load_abort(fw_priv);
+			fw_load_abort(buf);
 			return -ENOMEM;
 		}
 		memcpy(new_pages, buf->pages,
@@ -697,7 +721,7 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 			alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
 
 		if (!buf->pages[buf->nr_pages]) {
-			fw_load_abort(fw_priv);
+			fw_load_abort(buf);
 			return -ENOMEM;
 		}
 		buf->nr_pages++;
@@ -781,7 +805,7 @@ static void firmware_class_timeout_work(struct work_struct *work)
 		mutex_unlock(&fw_lock);
 		return;
 	}
-	fw_load_abort(fw_priv);
+	fw_load_abort(fw_priv->buf);
 	mutex_unlock(&fw_lock);
 }
 
@@ -857,6 +881,10 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
 
+	mutex_lock(&fw_lock);
+	list_add(&buf->pending_list, &pending_fw_head);
+	mutex_unlock(&fw_lock);
+
 	wait_for_completion(&buf->completion);
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
@@ -1517,6 +1545,7 @@ static int __init firmware_class_init(void)
 {
 	fw_cache_init();
 #ifdef CONFIG_FW_LOADER_USER_HELPER
+	register_reboot_notifier(&fw_shutdown_nb);
 	return class_register(&firmware_class);
 #else
 	return 0;
@@ -1530,6 +1559,7 @@ static void __exit firmware_class_exit(void)
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
 #ifdef CONFIG_FW_LOADER_USER_HELPER
+	unregister_reboot_notifier(&fw_shutdown_nb);
 	class_unregister(&firmware_class);
 #endif
 }
-- 
1.8.2.3

