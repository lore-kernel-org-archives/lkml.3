Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3AaKOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:14:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab3AaKO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:14:26 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] firmware: Reduce ifdef CONFIG_FW_LOADER_USER_HELPER
Date: Thu, 31 Jan 2013 11:13:56 +0100
Message-Id: <1359627237-7069-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359627237-7069-1-git-send-email-tiwai@suse.de>
References: <1359627237-7069-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By shuffling the code, reduce a few ifdefs in firmware_class.c.
Also, firmware_buf fmt field is changed to is_pages_buf boolean for
simplification.

Acked-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 313 ++++++++++++++++++++----------------------
 1 file changed, 151 insertions(+), 162 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 84b1c8d..51e62ca 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -88,13 +88,6 @@ enum {
 	FW_STATUS_ABORT,
 };
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-enum fw_buf_fmt {
-	VMALLOC_BUF,	/* used in direct loading */
-	PAGE_BUF,	/* used in loading via userspace */
-};
-#endif /* CONFIG_FW_LOADER_USER_HELPER */
-
 static int loading_timeout = 60;	/* In seconds */
 
 static inline long firmware_loading_timeout(void)
@@ -133,7 +126,7 @@ struct firmware_buf {
 	void *data;
 	size_t size;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-	enum fw_buf_fmt fmt;
+	bool is_paged_buf;
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
@@ -146,16 +139,6 @@ struct fw_cache_entry {
 	char name[];
 };
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-struct firmware_priv {
-	struct delayed_work timeout_work;
-	bool nowait;
-	struct device dev;
-	struct firmware_buf *buf;
-	struct firmware *fw;
-};
-#endif
-
 struct fw_name_devm {
 	unsigned long magic;
 	char name[];
@@ -188,9 +171,6 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-	buf->fmt = VMALLOC_BUF;
-#endif
 
 	pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
 
@@ -256,9 +236,8 @@ static void __fw_free_buf(struct kref *ref)
 	list_del(&buf->list);
 	spin_unlock(&fwc->lock);
 
-
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-	if (buf->fmt == PAGE_BUF) {
+	if (buf->is_paged_buf) {
 		int i;
 		vunmap(buf->data);
 		for (i = 0; i < buf->nr_pages; i++)
@@ -378,7 +357,89 @@ static void firmware_free_data(const struct firmware *fw)
 	fw_free_buf(fw->priv);
 }
 
+/* store the pages buffer info firmware from buf */
+static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
+{
+	fw->priv = buf;
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+	fw->pages = buf->pages;
+#endif
+	fw->size = buf->size;
+	fw->data = buf->data;
+
+	pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
+		 __func__, buf->fw_id, buf, buf->data,
+		 (unsigned int)buf->size);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static void fw_name_devm_release(struct device *dev, void *res)
+{
+	struct fw_name_devm *fwn = res;
+
+	if (fwn->magic == (unsigned long)&fw_cache)
+		pr_debug("%s: fw_name-%s devm-%p released\n",
+				__func__, fwn->name, res);
+}
+
+static int fw_devm_match(struct device *dev, void *res,
+		void *match_data)
+{
+	struct fw_name_devm *fwn = res;
+
+	return (fwn->magic == (unsigned long)&fw_cache) &&
+		!strcmp(fwn->name, match_data);
+}
+
+static struct fw_name_devm *fw_find_devm_name(struct device *dev,
+		const char *name)
+{
+	struct fw_name_devm *fwn;
+
+	fwn = devres_find(dev, fw_name_devm_release,
+			  fw_devm_match, (void *)name);
+	return fwn;
+}
+
+/* add firmware name into devres list */
+static int fw_add_devm_name(struct device *dev, const char *name)
+{
+	struct fw_name_devm *fwn;
+
+	fwn = fw_find_devm_name(dev, name);
+	if (fwn)
+		return 1;
+
+	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm) +
+			   strlen(name) + 1, GFP_KERNEL);
+	if (!fwn)
+		return -ENOMEM;
+
+	fwn->magic = (unsigned long)&fw_cache;
+	strcpy(fwn->name, name);
+	devres_add(dev, fwn);
+
+	return 0;
+}
+#else
+static int fw_add_devm_name(struct device *dev, const char *name)
+{
+	return 0;
+}
+#endif
+
+
+/*
+ * user-mode helper code
+ */
 #ifdef CONFIG_FW_LOADER_USER_HELPER
+struct firmware_priv {
+	struct delayed_work timeout_work;
+	bool nowait;
+	struct device dev;
+	struct firmware_buf *buf;
+	struct firmware *fw;
+};
 
 static struct firmware_priv *to_firmware_priv(struct device *dev)
 {
@@ -477,7 +538,7 @@ static ssize_t firmware_loading_show(struct device *dev,
 /* one pages buffer should be mapped/unmapped only once */
 static int fw_map_pages_buf(struct firmware_buf *buf)
 {
-	if (buf->fmt != PAGE_BUF)
+	if (!buf->is_paged_buf)
 		return 0;
 
 	if (buf->data)
@@ -749,78 +810,89 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 exit:
 	return fw_priv;
 }
-#endif /* CONFIG_FW_LOADER_USER_HELPER */
 
-/* store the pages buffer info firmware from buf */
-static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
+/* load a firmware via user helper */
+static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
+				  long timeout)
 {
-	fw->priv = buf;
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-	fw->pages = buf->pages;
-#endif
-	fw->size = buf->size;
-	fw->data = buf->data;
+	int retval = 0;
+	struct device *f_dev = &fw_priv->dev;
+	struct firmware_buf *buf = fw_priv->buf;
 
-	pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
-		 __func__, buf->fw_id, buf, buf->data,
-		 (unsigned int)buf->size);
-}
+	/* fall back on userspace loading */
+	buf->is_paged_buf = true;
 
-#ifdef CONFIG_PM_SLEEP
-static void fw_name_devm_release(struct device *dev, void *res)
-{
-	struct fw_name_devm *fwn = res;
+	dev_set_uevent_suppress(f_dev, true);
 
-	if (fwn->magic == (unsigned long)&fw_cache)
-		pr_debug("%s: fw_name-%s devm-%p released\n",
-				__func__, fwn->name, res);
-}
+	/* Need to pin this module until class device is destroyed */
+	__module_get(THIS_MODULE);
 
-static int fw_devm_match(struct device *dev, void *res,
-		void *match_data)
-{
-	struct fw_name_devm *fwn = res;
+	retval = device_add(f_dev);
+	if (retval) {
+		dev_err(f_dev, "%s: device_register failed\n", __func__);
+		goto err_put_dev;
+	}
 
-	return (fwn->magic == (unsigned long)&fw_cache) &&
-		!strcmp(fwn->name, match_data);
-}
+	retval = device_create_bin_file(f_dev, &firmware_attr_data);
+	if (retval) {
+		dev_err(f_dev, "%s: sysfs_create_bin_file failed\n", __func__);
+		goto err_del_dev;
+	}
 
-static struct fw_name_devm *fw_find_devm_name(struct device *dev,
-		const char *name)
-{
-	struct fw_name_devm *fwn;
+	retval = device_create_file(f_dev, &dev_attr_loading);
+	if (retval) {
+		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
+		goto err_del_bin_attr;
+	}
 
-	fwn = devres_find(dev, fw_name_devm_release,
-			  fw_devm_match, (void *)name);
-	return fwn;
-}
+	if (uevent) {
+		dev_set_uevent_suppress(f_dev, false);
+		dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
+		if (timeout != MAX_SCHEDULE_TIMEOUT)
+			schedule_delayed_work(&fw_priv->timeout_work, timeout);
 
-/* add firmware name into devres list */
-static int fw_add_devm_name(struct device *dev, const char *name)
-{
-	struct fw_name_devm *fwn;
+		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
+	}
 
-	fwn = fw_find_devm_name(dev, name);
-	if (fwn)
-		return 1;
+	wait_for_completion(&buf->completion);
 
-	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm) +
-			   strlen(name) + 1, GFP_KERNEL);
-	if (!fwn)
-		return -ENOMEM;
+	cancel_delayed_work_sync(&fw_priv->timeout_work);
 
-	fwn->magic = (unsigned long)&fw_cache;
-	strcpy(fwn->name, name);
-	devres_add(dev, fwn);
+	fw_priv->buf = NULL;
 
-	return 0;
+	device_remove_file(f_dev, &dev_attr_loading);
+err_del_bin_attr:
+	device_remove_bin_file(f_dev, &firmware_attr_data);
+err_del_dev:
+	device_del(f_dev);
+err_put_dev:
+	put_device(f_dev);
+	return retval;
 }
-#else
-static int fw_add_devm_name(struct device *dev, const char *name)
+
+static int fw_load_from_user_helper(struct firmware *firmware,
+				    const char *name, struct device *device,
+				    bool uevent, bool nowait, long timeout)
 {
-	return 0;
+	struct firmware_priv *fw_priv;
+
+	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
+	if (IS_ERR(fw_priv))
+		return PTR_ERR(fw_priv);
+
+	fw_priv->buf = firmware->priv;
+	return _request_firmware_load(fw_priv, uevent, timeout);
 }
-#endif
+#else /* CONFIG_FW_LOADER_USER_HELPER */
+static inline int
+fw_load_from_user_helper(struct firmware *firmware, const char *name,
+			 struct device *device, bool uevent, bool nowait,
+			 long timeout)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_FW_LOADER_USER_HELPER */
+
 
 /* wait until the shared firmware_buf becomes ready (or error) */
 static int sync_cached_firmware_buf(struct firmware_buf *buf)
@@ -921,89 +993,6 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device)
 	return 0;
 }
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-/* load a firmware via user helper */
-static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
-				  long timeout)
-{
-	int retval = 0;
-	struct device *f_dev = &fw_priv->dev;
-	struct firmware_buf *buf = fw_priv->buf;
-
-	/* fall back on userspace loading */
-	buf->fmt = PAGE_BUF;
-
-	dev_set_uevent_suppress(f_dev, true);
-
-	/* Need to pin this module until class device is destroyed */
-	__module_get(THIS_MODULE);
-
-	retval = device_add(f_dev);
-	if (retval) {
-		dev_err(f_dev, "%s: device_register failed\n", __func__);
-		goto err_put_dev;
-	}
-
-	retval = device_create_bin_file(f_dev, &firmware_attr_data);
-	if (retval) {
-		dev_err(f_dev, "%s: sysfs_create_bin_file failed\n", __func__);
-		goto err_del_dev;
-	}
-
-	retval = device_create_file(f_dev, &dev_attr_loading);
-	if (retval) {
-		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
-		goto err_del_bin_attr;
-	}
-
-	if (uevent) {
-		dev_set_uevent_suppress(f_dev, false);
-		dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
-		if (timeout != MAX_SCHEDULE_TIMEOUT)
-			schedule_delayed_work(&fw_priv->timeout_work, timeout);
-
-		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
-	}
-
-	wait_for_completion(&buf->completion);
-
-	cancel_delayed_work_sync(&fw_priv->timeout_work);
-
-	fw_priv->buf = NULL;
-
-	device_remove_file(f_dev, &dev_attr_loading);
-err_del_bin_attr:
-	device_remove_bin_file(f_dev, &firmware_attr_data);
-err_del_dev:
-	device_del(f_dev);
-err_put_dev:
-	put_device(f_dev);
-	return retval;
-}
-
-static int fw_load_from_user_helper(struct firmware *firmware,
-				    const char *name, struct device *device,
-				    bool uevent, bool nowait, long timeout)
-{
-	struct firmware_priv *fw_priv;
-
-	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
-	if (IS_ERR(fw_priv))
-		return PTR_ERR(fw_priv);
-
-	fw_priv->buf = firmware->priv;
-	return _request_firmware_load(fw_priv, uevent, timeout);
-}
-#else /* CONFIG_FW_LOADER_USER_HELPER */
-static inline int
-fw_load_from_user_helper(struct firmware *firmware, const char *name,
-			 struct device *device, bool uevent, bool nowait,
-			 long timeout)
-{
-	return -ENOENT;
-}
-#endif /* CONFIG_FW_LOADER_USER_HELPER */
-
 /* called from request_firmware() and request_firmware_work_func() */
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
-- 
1.8.1.1

