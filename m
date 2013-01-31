Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3AaKO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:14:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab3AaKO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:14:26 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] firmware: Make user-mode helper optional
Date: Thu, 31 Jan 2013 11:13:55 +0100
Message-Id: <1359627237-7069-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359627237-7069-1-git-send-email-tiwai@suse.de>
References: <1359627237-7069-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new kconfig, CONFIG_FW_LOADER_USER_HELPER, and
guards the user-helper codes in firmware_class.c with ifdefs.

Yeah, yeah, there are lots of ifdefs in this patch.  The further
clean-up with code shuffling follows in the next.

Acked-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/Kconfig          | 11 +++++++++
 drivers/base/firmware_class.c | 57 +++++++++++++++++++++++++++++++++----------
 2 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index c8b4539..07abd9d 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -145,6 +145,17 @@ config EXTRA_FIRMWARE_DIR
 	  this option you can point it elsewhere, such as /lib/firmware/ or
 	  some other directory containing the firmware files.
 
+config FW_LOADER_USER_HELPER
+	bool "Fallback user-helper invocation for firmware loading"
+	depends on FW_LOADER
+	default y
+	help
+	  This option enables / disables the invocation of user-helper
+	  (e.g. udev) for loading firmware files as a fallback after the
+	  direct file loading in kernel fails.  The user-mode helper is
+	  no longer required unless you have a special firmware file that
+	  resides in a non-standard path.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 40ec60a..84b1c8d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -88,10 +88,12 @@ enum {
 	FW_STATUS_ABORT,
 };
 
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 enum fw_buf_fmt {
 	VMALLOC_BUF,	/* used in direct loading */
 	PAGE_BUF,	/* used in loading via userspace */
 };
+#endif /* CONFIG_FW_LOADER_USER_HELPER */
 
 static int loading_timeout = 60;	/* In seconds */
 
@@ -128,12 +130,14 @@ struct firmware_buf {
 	struct completion completion;
 	struct firmware_cache *fwc;
 	unsigned long status;
-	enum fw_buf_fmt fmt;
 	void *data;
 	size_t size;
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+	enum fw_buf_fmt fmt;
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
+#endif
 	char fw_id[];
 };
 
@@ -142,6 +146,7 @@ struct fw_cache_entry {
 	char name[];
 };
 
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 struct firmware_priv {
 	struct delayed_work timeout_work;
 	bool nowait;
@@ -149,6 +154,7 @@ struct firmware_priv {
 	struct firmware_buf *buf;
 	struct firmware *fw;
 };
+#endif
 
 struct fw_name_devm {
 	unsigned long magic;
@@ -182,7 +188,9 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	buf->fmt = VMALLOC_BUF;
+#endif
 
 	pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
 
@@ -240,7 +248,6 @@ static void __fw_free_buf(struct kref *ref)
 {
 	struct firmware_buf *buf = to_fwbuf(ref);
 	struct firmware_cache *fwc = buf->fwc;
-	int i;
 
 	pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
 		 __func__, buf->fw_id, buf, buf->data,
@@ -250,12 +257,15 @@ static void __fw_free_buf(struct kref *ref)
 	spin_unlock(&fwc->lock);
 
 
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	if (buf->fmt == PAGE_BUF) {
+		int i;
 		vunmap(buf->data);
 		for (i = 0; i < buf->nr_pages; i++)
 			__free_page(buf->pages[i]);
 		kfree(buf->pages);
 	} else
+#endif
 		vfree(buf->data);
 	kfree(buf);
 }
@@ -357,6 +367,19 @@ static bool fw_get_filesystem_firmware(struct device *device,
 	return success;
 }
 
+/* firmware holds the ownership of pages */
+static void firmware_free_data(const struct firmware *fw)
+{
+	/* Loaded directly? */
+	if (!fw->priv) {
+		vfree(fw->data);
+		return;
+	}
+	fw_free_buf(fw->priv);
+}
+
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+
 static struct firmware_priv *to_firmware_priv(struct device *dev)
 {
 	return container_of(dev, struct firmware_priv, dev);
@@ -446,17 +469,6 @@ static ssize_t firmware_loading_show(struct device *dev,
 	return sprintf(buf, "%d\n", loading);
 }
 
-/* firmware holds the ownership of pages */
-static void firmware_free_data(const struct firmware *fw)
-{
-	/* Loaded directly? */
-	if (!fw->priv) {
-		vfree(fw->data);
-		return;
-	}
-	fw_free_buf(fw->priv);
-}
-
 /* Some architectures don't have PAGE_KERNEL_RO */
 #ifndef PAGE_KERNEL_RO
 #define PAGE_KERNEL_RO PAGE_KERNEL
@@ -737,12 +749,15 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 exit:
 	return fw_priv;
 }
+#endif /* CONFIG_FW_LOADER_USER_HELPER */
 
 /* store the pages buffer info firmware from buf */
 static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 {
 	fw->priv = buf;
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	fw->pages = buf->pages;
+#endif
 	fw->size = buf->size;
 	fw->data = buf->data;
 
@@ -906,6 +921,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device)
 	return 0;
 }
 
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 /* load a firmware via user helper */
 static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 				  long timeout)
@@ -978,6 +994,15 @@ static int fw_load_from_user_helper(struct firmware *firmware,
 	fw_priv->buf = firmware->priv;
 	return _request_firmware_load(fw_priv, uevent, timeout);
 }
+#else /* CONFIG_FW_LOADER_USER_HELPER */
+static inline int
+fw_load_from_user_helper(struct firmware *firmware, const char *name,
+			 struct device *device, bool uevent, bool nowait,
+			 long timeout)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_FW_LOADER_USER_HELPER */
 
 /* called from request_firmware() and request_firmware_work_func() */
 static int
@@ -1495,7 +1520,11 @@ static void __init fw_cache_init(void)
 static int __init firmware_class_init(void)
 {
 	fw_cache_init();
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	return class_register(&firmware_class);
+#else
+	return 0;
+#endif
 }
 
 static void __exit firmware_class_exit(void)
@@ -1504,7 +1533,9 @@ static void __exit firmware_class_exit(void)
 	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	class_unregister(&firmware_class);
+#endif
 }
 
 fs_initcall(firmware_class_init);
-- 
1.8.1.1

