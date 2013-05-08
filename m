Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3EHG5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:57:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3EHG4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:56:49 -0400
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/3] firmware: Avoid deadlock of usermodehelper lock at shutdown
Date: Wed,  8 May 2013 08:56:36 +0200
Message-Id: <1367996197-32748-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367996197-32748-1-git-send-email-tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a system goes to reboot/shutdown, it tries to disable the
usermode helper via usermodehelper_disable().  This might be blocked
when a driver tries to load a firmware beforehand and it's stuck by
some reason.

In this patch, the firmware class driver registers a reboot notifier
so that it can abort all pending f/w bufs.  Also enable a flag for
avoiding the call of usermodehelper after the reboot/shutdown starts.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 47 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 9e1d39e..0cad0b4 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -27,6 +27,7 @@
 #include <linux/pm.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/reboot.h>
 
 #include <generated/utsrelease.h>
 
@@ -171,6 +172,7 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
+	INIT_LIST_HEAD(&buf->list);
 
 	pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
 
@@ -446,10 +448,9 @@ static struct firmware_priv *to_firmware_priv(struct device *dev)
 	return container_of(dev, struct firmware_priv, dev);
 }
 
-static void fw_load_abort(struct firmware_priv *fw_priv)
+static void fw_load_abort(struct firmware_buf *buf)
 {
-	struct firmware_buf *buf = fw_priv->buf;
-
+	list_del_init(&buf->list);
 	set_bit(FW_STATUS_ABORT, &buf->status);
 	complete_all(&buf->completion);
 }
@@ -457,6 +458,26 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
 #define is_fw_load_aborted(buf)	\
 	test_bit(FW_STATUS_ABORT, &(buf)->status)
 
+static LIST_HEAD(pending_fw_head);
+static bool in_shutdown;
+
+/* reboot notifier for avoid deadlock with usermode_lock */
+static int fw_shutdown_notify(struct notifier_block *unused1,
+			      unsigned long unused2, void *unused3)
+{
+	mutex_lock(&fw_lock);
+	in_shutdown = true;
+	while (!list_empty(&pending_fw_head))
+		fw_load_abort(list_first_entry(&pending_fw_head,
+					       struct firmware_buf, list));
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
@@ -604,6 +625,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 			 * is completed.
 			 * */
 			fw_map_pages_buf(fw_buf);
+			list_del_init(&fw_buf->list);
 			complete_all(&fw_buf->completion);
 			break;
 		}
@@ -612,7 +634,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
 		/* fallthrough */
 	case -1:
-		fw_load_abort(fw_priv);
+		fw_load_abort(fw_buf);
 		break;
 	}
 out:
@@ -680,7 +702,7 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 		new_pages = kmalloc(new_array_size * sizeof(void *),
 				    GFP_KERNEL);
 		if (!new_pages) {
-			fw_load_abort(fw_priv);
+			fw_load_abort(buf);
 			return -ENOMEM;
 		}
 		memcpy(new_pages, buf->pages,
@@ -697,7 +719,7 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 			alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
 
 		if (!buf->pages[buf->nr_pages]) {
-			fw_load_abort(fw_priv);
+			fw_load_abort(buf);
 			return -ENOMEM;
 		}
 		buf->nr_pages++;
@@ -781,7 +803,7 @@ static void firmware_class_timeout_work(struct work_struct *work)
 		mutex_unlock(&fw_lock);
 		return;
 	}
-	fw_load_abort(fw_priv);
+	fw_load_abort(fw_priv->buf);
 	mutex_unlock(&fw_lock);
 }
 
@@ -857,6 +879,10 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
 
+	mutex_lock(&fw_lock);
+	list_add(&buf->list, &pending_fw_head);
+	mutex_unlock(&fw_lock);
+
 	wait_for_completion(&buf->completion);
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
@@ -897,6 +923,7 @@ fw_load_from_user_helper(struct firmware *firmware, const char *name,
 
 /* No abort during direct loading */
 #define is_fw_load_aborted(buf) false
+#define in_shutdown		false
 
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
@@ -1019,6 +1046,10 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	ret = 0;
 	if (!fw_get_filesystem_firmware(device, fw->priv)) {
 		long timeout = firmware_loading_timeout();
+		if (WARN_ON(in_shutdown)) {
+			ret = -EBUSY;
+			goto out;
+		}
 		if (nowait) {
 			timeout = usermodehelper_read_lock_wait(timeout);
 			if (!timeout) {
@@ -1521,6 +1552,7 @@ static int __init firmware_class_init(void)
 {
 	fw_cache_init();
 #ifdef CONFIG_FW_LOADER_USER_HELPER
+	register_reboot_notifier(&fw_shutdown_nb);
 	return class_register(&firmware_class);
 #else
 	return 0;
@@ -1534,6 +1566,7 @@ static void __exit firmware_class_exit(void)
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
 #ifdef CONFIG_FW_LOADER_USER_HELPER
+	unregister_reboot_notifier(&fw_shutdown_nb);
 	class_unregister(&firmware_class);
 #endif
 }
-- 
1.8.2.1

