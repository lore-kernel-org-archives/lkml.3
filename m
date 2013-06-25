Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3FYS4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:56:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3FYSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Ming Lei <ming.lei@canonical.com>
Subject: [ 86/95] firmware loader: fix use-after-free by double abort
Date: Tue, 25 Jun 2013 11:33:13 -0700
Message-Id: <20130625182203.342081387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit 875979368eb4cfecff9f0e97625b90cc6009269d upstream.

fw_priv->buf is accessed in both request_firmware_load() and
writing to sysfs file of 'loading' context, but not protected
by 'fw_lock' entirely. The patch makes sure that access on
'fw_priv->buf' is protected by the lock.

So fixes the double abort problem reported by nirinA raseliarison:

	http://lkml.org/lkml/2013/6/14/188

Reported-and-tested-by: nirinA raseliarison <nirina.raseliarison@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_class.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -450,8 +450,18 @@ static void fw_load_abort(struct firmwar
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
@@ -528,7 +538,12 @@ static ssize_t firmware_loading_show(str
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
@@ -570,12 +585,12 @@ static ssize_t firmware_loading_store(st
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
 
@@ -777,10 +792,6 @@ static void firmware_class_timeout_work(
 			struct firmware_priv, timeout_work.work);
 
 	mutex_lock(&fw_lock);
-	if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
-		mutex_unlock(&fw_lock);
-		return;
-	}
 	fw_load_abort(fw_priv);
 	mutex_unlock(&fw_lock);
 }
@@ -861,8 +872,6 @@ static int _request_firmware_load(struct
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
 
-	fw_priv->buf = NULL;
-
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
 	device_remove_bin_file(f_dev, &firmware_attr_data);


