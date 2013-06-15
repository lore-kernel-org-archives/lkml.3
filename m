Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3FOIhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 04:37:06 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39557 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3FOIhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 04:37:00 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: nirinA raseliarison <nirina.raseliarison@gmail.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>, stable <stable@vger.kernel.org>
Subject: [PATCH] firmware loader: fix use-after-free by double abort
Date: Sat, 15 Jun 2013 16:36:38 +0800
Message-Id: <1371285398-18566-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_priv->buf is accessed in both request_firmware_load() and
writing to sysfs file of 'loading' context, but not protected
by 'fw_lock' entirely. The patch makes sure that access on
'fw_priv->buf' is protected by the lock.

So fixes the double abort problem reported by nirinA raseliarison:

	http://lkml.org/lkml/2013/6/14/188

Reported-and-tested-by: nirinA raseliarison <nirina.raseliarison@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4b1f926..01e2103 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -450,8 +450,18 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
 {
 	struct firmware_buf *buf = fw_priv->buf;
 
+	/*
+	 * There is a small window in which user can write to 'loading'
+	 * between loading done and disappearance of 'loading'
+	 */
+	if (test_bit(FW_STATUS_DONE, &buf->status))
+		return;
+
 	set_bit(FW_STATUS_ABORT, &buf->status);
 	complete_all(&buf->completion);
+
+	/* avoid user action after loading abort */
+	fw_priv->buf = NULL;
 }
 
 #define is_fw_load_aborted(buf)	\
@@ -528,7 +538,12 @@ static ssize_t firmware_loading_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
-	int loading = test_bit(FW_STATUS_LOADING, &fw_priv->buf->status);
+	int loading = 0;
+
+	mutex_lock(&fw_lock);
+	if (fw_priv->buf)
+		loading = test_bit(FW_STATUS_LOADING, &fw_priv->buf->status);
+	mutex_unlock(&fw_lock);
 
 	return sprintf(buf, "%d\n", loading);
 }
@@ -570,12 +585,12 @@ static ssize_t firmware_loading_store(struct device *dev,
 				      const char *buf, size_t count)
 {
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
-	struct firmware_buf *fw_buf = fw_priv->buf;
+	struct firmware_buf *fw_buf;
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;
 
 	mutex_lock(&fw_lock);
-
+	fw_buf = fw_priv->buf;
 	if (!fw_buf)
 		goto out;
 
@@ -777,10 +792,6 @@ static void firmware_class_timeout_work(struct work_struct *work)
 			struct firmware_priv, timeout_work.work);
 
 	mutex_lock(&fw_lock);
-	if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
-		mutex_unlock(&fw_lock);
-		return;
-	}
 	fw_load_abort(fw_priv);
 	mutex_unlock(&fw_lock);
 }
@@ -861,8 +872,6 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
 
-	fw_priv->buf = NULL;
-
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
 	device_remove_bin_file(f_dev, &firmware_attr_data);
-- 
1.7.9.5

