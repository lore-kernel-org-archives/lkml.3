Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbaGNVix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:38:53 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47686 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbaGNVih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:38:37 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] firmware_class: add "fd" input file
Date: Mon, 14 Jul 2014 14:38:16 -0700
Message-Id: <1405373897-31671-7-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As an alternative to loading bytes from the "data" blob when reading
firmware, let kernel read from an fd, so that the LSM can reason about
the origin of firmware contents during userspace on-demand loading.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/firmware_class/README |   10 +++++
 drivers/base/firmware_class.c       |   77 ++++++++++++++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index 71f86859d7d8..d899bdacba1e 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -59,6 +59,16 @@
  8), kernel(driver): Driver code calls release_firmware(fw_entry) releasing
 		 the firmware image and any related resource.
 
+ Alternative loading (via file descriptor):
+ ==========================================
+ Instead of "loading", and "data" above, firmware can be loaded through
+ an open file descriptor as well, via the "fd" file:
+
+ Replacing steps 2 thorugh 6 above with the following userspace actions,
+ performs the same loading:
+	- open firmware image file (e.g. as fd 3).
+	- write fd (e.g. "3") to /sys/class/firmware/xxx/fd.
+
  High level behavior (driver code):
  ==================================
 
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b38cbcd6ebb1..eac996447d28 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -839,6 +839,70 @@ static struct bin_attribute firmware_attr_data = {
 	.write = firmware_data_write,
 };
 
+/**
+ * fd_store - set value in the 'fd' control file
+ * @dev: device pointer
+ * @attr: device attribute pointer
+ * @buf: buffer to scan for loading fd value
+ * @count: number of bytes in @buf
+ *
+ * Parses an fd number from buf, and then loads firmware bytes from
+ * the current process's matching open fd.
+ *
+ **/
+static ssize_t fd_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct firmware_priv *fw_priv = to_firmware_priv(dev);
+	struct firmware_buf *fw_buf = fw_priv->buf;
+	ssize_t retval;
+	int fd;
+	struct fd f;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	retval = kstrtoint(buf, 10, &fd);
+	if (retval)
+		return retval;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	mutex_lock(&fw_lock);
+	/* If we raced another loader, we must fail. */
+	if (test_bit(FW_STATUS_DONE, &fw_buf->status)) {
+		retval = -EINVAL;
+		goto unlock;
+	}
+
+	fw_load_start(fw_buf);
+	/* fw_read_file_contents uses vmalloc, not pages. */
+	fw_buf->is_paged_buf = false;
+	retval = fw_read_file_contents(f.file, fw_buf);
+	if (retval) {
+		/* If we called fw_load_start, we must abort on fail. */
+		fw_load_abort(fw_priv);
+		goto unlock;
+	}
+
+	/* Success. */
+	set_bit(FW_STATUS_DONE, &fw_buf->status);
+	list_del_init(&fw_buf->pending_list);
+	complete_all(&fw_buf->completion);
+
+unlock:
+	mutex_unlock(&fw_lock);
+	fdput(f);
+
+	if (retval)
+		return retval;
+	return count;
+}
+static DEVICE_ATTR_WO(fd);
+
 static void firmware_class_timeout_work(struct work_struct *work)
 {
 	struct firmware_priv *fw_priv = container_of(work,
@@ -912,10 +976,19 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		mutex_lock(&fw_lock);
 		list_del_init(&buf->pending_list);
 		mutex_unlock(&fw_lock);
-		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
+		dev_err(f_dev, "%s: dev_attr_loading failed\n", __func__);
 		goto err_del_bin_attr;
 	}
 
+	retval = device_create_file(f_dev, &dev_attr_fd);
+	if (retval) {
+		mutex_lock(&fw_lock);
+		list_del_init(&buf->pending_list);
+		mutex_unlock(&fw_lock);
+		dev_err(f_dev, "%s: &dev_attr_fd failed\n", __func__);
+		goto err_del_loading;
+	}
+
 	if (opt_flags & FW_OPT_UEVENT) {
 		buf->need_uevent = true;
 		dev_set_uevent_suppress(f_dev, false);
@@ -933,6 +1006,8 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 	if (!buf->data)
 		retval = -ENOMEM;
 
+	device_remove_file(f_dev, &dev_attr_fd);
+err_del_loading:
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
 	device_remove_bin_file(f_dev, &firmware_attr_data);
-- 
1.7.9.5

