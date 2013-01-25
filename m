Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3AYQGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:06:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3AYQFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:05:39 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] firmware: Refactoring for splitting user-mode helper code
Date: Fri, 25 Jan 2013 17:05:26 +0100
Message-Id: <1359129929-29291-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359129929-29291-1-git-send-email-tiwai@suse.de>
References: <1359129929-29291-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.7 kernel, the firmware loader can read the firmware files
directly, and the traditional user-mode helper is invoked only as a
fallback.  This seems working pretty well, and the next step would be
to reduce the redundant user-mode helper stuff in future.

This patch is a preparation for that: refactor the code for splitting
user-mode helper stuff more easily.  No functional change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 286 +++++++++++++++++++++++-------------------
 1 file changed, 159 insertions(+), 127 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b392b35..7da18e3 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -319,7 +319,8 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
 	return true;
 }
 
-static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
+static bool fw_get_filesystem_firmware(struct device *device,
+				       struct firmware_buf *buf)
 {
 	int i;
 	bool success = false;
@@ -343,6 +344,16 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
 			break;
 	}
 	__putname(path);
+
+	if (success) {
+		dev_dbg(device, "firmware: direct-loading firmware %s\n",
+			buf->fw_id);
+		mutex_lock(&fw_lock);
+		set_bit(FW_STATUS_DONE, &buf->status);
+		complete_all(&buf->completion);
+		mutex_unlock(&fw_lock);
+	}
+
 	return success;
 }
 
@@ -796,99 +807,122 @@ static int fw_add_devm_name(struct device *dev, const char *name)
 }
 #endif
 
-static void _request_firmware_cleanup(const struct firmware **firmware_p)
+static void _request_firmware_cleanup(struct firmware **firmware_p)
 {
 	release_firmware(*firmware_p);
 	*firmware_p = NULL;
 }
 
-static struct firmware_priv *
-_request_firmware_prepare(const struct firmware **firmware_p, const char *name,
-			  struct device *device, bool uevent, bool nowait)
+/* wait until the shared firmware_buf becomes ready (or error) */
+static int sync_cached_firmware_buf(struct firmware_buf *buf)
+{
+	int ret = 0;
+
+	mutex_lock(&fw_lock);
+	while (!test_bit(FW_STATUS_DONE, &buf->status)) {
+		if (test_bit(FW_STATUS_ABORT, &buf->status)) {
+			ret = -ENOENT;
+			break;
+		}
+		mutex_unlock(&fw_lock);
+		wait_for_completion(&buf->completion);
+		mutex_lock(&fw_lock);
+	}
+	mutex_unlock(&fw_lock);
+	return ret;
+}
+
+/* prepare firmware and firmware_buf structs;
+ * return 1 if a firmware is already assigned, 0 if need to load one,
+ * or a negative error code
+ */
+static int
+_request_firmware_prepare(struct firmware **firmware_p, const char *name,
+			  struct device *device)
 {
 	struct firmware *firmware;
-	struct firmware_priv *fw_priv = NULL;
 	struct firmware_buf *buf;
 	int ret;
 
 	if (!firmware_p)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
 			__func__);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	if (fw_get_builtin_firmware(firmware, name)) {
 		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
-		return NULL;
+		return 1; /* assigned */
 	}
 
 	ret = fw_lookup_and_allocate_buf(name, &fw_cache, &buf);
-	if (!ret)
-		fw_priv = fw_create_instance(firmware, name, device,
-				uevent, nowait);
 
-	if (IS_ERR(fw_priv) || ret < 0) {
-		kfree(firmware);
-		*firmware_p = NULL;
-		return ERR_PTR(-ENOMEM);
-	} else if (fw_priv) {
-		fw_priv->buf = buf;
+	/*
+	 * bind with 'buf' now to avoid warning in failure path
+	 * of requesting firmware.
+	 */
+	firmware->priv = buf;
 
-		/*
-		 * bind with 'buf' now to avoid warning in failure path
-		 * of requesting firmware.
-		 */
-		firmware->priv = buf;
-		return fw_priv;
+	if (ret > 0) {
+		ret = sync_cached_firmware_buf(buf);
+		if (!ret) {
+			fw_set_page_data(buf, firmware);
+			return 1; /* assigned */
+		}
 	}
 
-	/* share the cached buf, which is inprogessing or completed */
- check_status:
-	mutex_lock(&fw_lock);
-	if (test_bit(FW_STATUS_ABORT, &buf->status)) {
-		fw_priv = ERR_PTR(-ENOENT);
-		firmware->priv = buf;
+	if (ret < 0)
 		_request_firmware_cleanup(firmware_p);
-		goto exit;
-	} else if (test_bit(FW_STATUS_DONE, &buf->status)) {
-		fw_priv = NULL;
-		fw_set_page_data(buf, firmware);
-		goto exit;
+
+	return ret;
+}
+
+static int assign_firmware_buf(struct firmware *fw, struct device *device)
+{
+	struct firmware_buf *buf = fw->priv;
+
+	mutex_lock(&fw_lock);
+	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status)) {
+		mutex_unlock(&fw_lock);
+		return -ENOENT;
 	}
-	mutex_unlock(&fw_lock);
-	wait_for_completion(&buf->completion);
-	goto check_status;
 
-exit:
+	/*
+	 * add firmware name into devres list so that we can auto cache
+	 * and uncache firmware for device.
+	 *
+	 * device may has been deleted already, but the problem
+	 * should be fixed in devres or driver core.
+	 */
+	if (device)
+		fw_add_devm_name(device, buf->fw_id);
+
+	/*
+	 * After caching firmware image is started, let it piggyback
+	 * on request firmware.
+	 */
+	if (buf->fwc->state == FW_LOADER_START_CACHE) {
+		if (fw_cache_piggyback_on_request(buf->fw_id))
+			kref_get(&buf->ref);
+	}
+
+	/* pass the pages buffer to driver at the last minute */
+	fw_set_page_data(buf, fw);
 	mutex_unlock(&fw_lock);
-	return fw_priv;
+	return 0;
 }
 
+/* load a firmware via user helper */
 static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 				  long timeout)
 {
 	int retval = 0;
 	struct device *f_dev = &fw_priv->dev;
 	struct firmware_buf *buf = fw_priv->buf;
-	struct firmware_cache *fwc = &fw_cache;
-	int direct_load = 0;
-
-	/* try direct loading from fs first */
-	if (fw_get_filesystem_firmware(buf)) {
-		dev_dbg(f_dev->parent, "firmware: direct-loading"
-			" firmware %s\n", buf->fw_id);
-
-		mutex_lock(&fw_lock);
-		set_bit(FW_STATUS_DONE, &buf->status);
-		mutex_unlock(&fw_lock);
-		complete_all(&buf->completion);
-		direct_load = 1;
-		goto handle_fw;
-	}
 
 	/* fall back on userspace loading */
 	buf->fmt = PAGE_BUF;
@@ -929,38 +963,10 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
 
-handle_fw:
-	mutex_lock(&fw_lock);
-	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
-		retval = -ENOENT;
-
-	/*
-	 * add firmware name into devres list so that we can auto cache
-	 * and uncache firmware for device.
-	 *
-	 * f_dev->parent may has been deleted already, but the problem
-	 * should be fixed in devres or driver core.
-	 */
-	if (!retval && f_dev->parent)
-		fw_add_devm_name(f_dev->parent, buf->fw_id);
-
-	/*
-	 * After caching firmware image is started, let it piggyback
-	 * on request firmware.
-	 */
-	if (!retval && fwc->state == FW_LOADER_START_CACHE) {
-		if (fw_cache_piggyback_on_request(buf->fw_id))
-			kref_get(&buf->ref);
-	}
-
-	/* pass the pages buffer to driver at the last minute */
-	fw_set_page_data(buf, fw_priv->fw);
+	if (!retval)
+		retval = assign_firmware_buf(fw_priv->fw, f_dev->parent);
 
 	fw_priv->buf = NULL;
-	mutex_unlock(&fw_lock);
-
-	if (direct_load)
-		goto err_put_dev;
 
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
@@ -972,6 +978,71 @@ err_put_dev:
 	return retval;
 }
 
+static int fw_load_from_user_helper(struct firmware *firmware,
+				    const char *name, struct device *device,
+				    bool uevent, bool nowait)
+{
+	struct firmware_priv *fw_priv;
+	long timeout;
+	int ret;
+
+	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
+	if (IS_ERR(fw_priv))
+		return PTR_ERR(fw_priv);
+
+	fw_priv->buf = firmware->priv;
+
+	timeout = firmware_loading_timeout();
+	if (nowait) {
+		timeout = usermodehelper_read_lock_wait(timeout);
+		if (!timeout) {
+			dev_dbg(device, "firmware: %s loading timed out\n",
+				name);
+			kfree(fw_priv);
+			return -EAGAIN;
+		}
+	} else {
+		ret = usermodehelper_read_trylock();
+		if (WARN_ON(ret)) {
+			dev_err(device, "firmware: %s will not be loaded\n",
+				name);
+			kfree(fw_priv);
+			return ret;
+		}
+	}
+
+	ret = _request_firmware_load(fw_priv, uevent, timeout);
+	usermodehelper_read_unlock();
+	return ret;
+}
+
+/* called from request_firmware() and request_firmware_work_func() */
+static int
+_request_firmware(const struct firmware **firmware_p, const char *name,
+		  struct device *device, bool uevent, bool nowait)
+{
+	struct firmware *fw;
+	int ret;
+
+	ret = _request_firmware_prepare(&fw, name, device);
+	if (ret < 0)
+		return ret;
+	else if (ret) { /* assigned from either built-in or cache */
+		*firmware_p = fw;
+		return 0;
+	}
+
+	if (fw_get_filesystem_firmware(device, fw->priv))
+		ret = assign_firmware_buf(fw, device);
+	else
+		ret = fw_load_from_user_helper(fw, name, device,
+					       uevent, nowait);
+	if (ret)
+		_request_firmware_cleanup(&fw);
+	*firmware_p = fw;
+	return ret;
+}
+
 /**
  * request_firmware: - send firmware request and wait for it
  * @firmware_p: pointer to firmware image
@@ -996,26 +1067,7 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-	struct firmware_priv *fw_priv;
-	int ret;
-
-	fw_priv = _request_firmware_prepare(firmware_p, name, device, true,
-					    false);
-	if (IS_ERR_OR_NULL(fw_priv))
-		return PTR_RET(fw_priv);
-
-	ret = usermodehelper_read_trylock();
-	if (WARN_ON(ret)) {
-		dev_err(device, "firmware: %s will not be loaded\n", name);
-	} else {
-		ret = _request_firmware_load(fw_priv, true,
-					firmware_loading_timeout());
-		usermodehelper_read_unlock();
-	}
-	if (ret)
-		_request_firmware_cleanup(firmware_p);
-
-	return ret;
+	return _request_firmware(firmware_p, name, device, true, false);
 }
 
 /**
@@ -1046,31 +1098,11 @@ static void request_firmware_work_func(struct work_struct *work)
 {
 	struct firmware_work *fw_work;
 	const struct firmware *fw;
-	struct firmware_priv *fw_priv;
-	long timeout;
-	int ret;
 
 	fw_work = container_of(work, struct firmware_work, work);
-	fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
-			fw_work->uevent, true);
-	if (IS_ERR_OR_NULL(fw_priv)) {
-		ret = PTR_RET(fw_priv);
-		goto out;
-	}
-
-	timeout = usermodehelper_read_lock_wait(firmware_loading_timeout());
-	if (timeout) {
-		ret = _request_firmware_load(fw_priv, fw_work->uevent, timeout);
-		usermodehelper_read_unlock();
-	} else {
-		dev_dbg(fw_work->device, "firmware: %s loading timed out\n",
-			fw_work->name);
-		ret = -EAGAIN;
-	}
-	if (ret)
-		_request_firmware_cleanup(&fw);
 
- out:
+	_request_firmware(&fw, fw_work->name, fw_work->device,
+			  fw_work->uevent, true);
 	fw_work->cont(fw, fw_work->context);
 	put_device(fw_work->device);
 
-- 
1.8.1.1

