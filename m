Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbbALQCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:02:33 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:50104 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbALQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:02:32 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/2] firmware_loader: handle timeout via wait_for_completion_interruptible_timeout()
Date: Tue, 13 Jan 2015 00:02:01 +0800
Message-Id: <1421078521-12322-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is simpler to handle timeout by wait_for_completion_interruptible_timeout(),
so remove previous delay work for timeout.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6bed4ae..90d28e6 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -94,7 +94,7 @@ static int loading_timeout = 60;	/* In seconds */
 
 static inline long firmware_loading_timeout(void)
 {
-	return loading_timeout > 0 ? loading_timeout * HZ : MAX_SCHEDULE_TIMEOUT;
+	return loading_timeout > 0 ? loading_timeout * HZ : MAX_JIFFY_OFFSET;
 }
 
 /* firmware behavior options */
@@ -446,7 +446,6 @@ static int fw_add_devm_name(struct device *dev, const char *name)
  */
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 struct firmware_priv {
-	struct delayed_work timeout_work;
 	bool nowait;
 	struct device dev;
 	struct firmware_buf *buf;
@@ -836,16 +835,6 @@ static struct bin_attribute firmware_attr_data = {
 	.write = firmware_data_write,
 };
 
-static void firmware_class_timeout_work(struct work_struct *work)
-{
-	struct firmware_priv *fw_priv = container_of(work,
-			struct firmware_priv, timeout_work.work);
-
-	mutex_lock(&fw_lock);
-	fw_load_abort(fw_priv);
-	mutex_unlock(&fw_lock);
-}
-
 static struct firmware_priv *
 fw_create_instance(struct firmware *firmware, const char *fw_name,
 		   struct device *device, unsigned int opt_flags)
@@ -862,9 +851,6 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 
 	fw_priv->nowait = !!(opt_flags & FW_OPT_NOWAIT);
 	fw_priv->fw = firmware;
-	INIT_DELAYED_WORK(&fw_priv->timeout_work,
-		firmware_class_timeout_work);
-
 	f_dev = &fw_priv->dev;
 
 	device_initialize(f_dev);
@@ -917,18 +903,14 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		buf->need_uevent = true;
 		dev_set_uevent_suppress(f_dev, false);
 		dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
-		if (timeout != MAX_SCHEDULE_TIMEOUT)
-			queue_delayed_work(system_power_efficient_wq,
-					   &fw_priv->timeout_work, timeout);
-
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
+	} else {
+		timeout = MAX_JIFFY_OFFSET;
 	}
 
-	retval = wait_for_completion_interruptible(&buf->completion);
-
-	cancel_delayed_work_sync(&fw_priv->timeout_work);
-
-	if (retval == -ERESTARTSYS) {
+	retval = wait_for_completion_interruptible_timeout(&buf->completion,
+			timeout);
+	if (retval == -ERESTARTSYS || !retval) {
 		mutex_lock(&fw_lock);
 		fw_load_abort(fw_priv);
 		mutex_unlock(&fw_lock);
-- 
1.7.9.5

