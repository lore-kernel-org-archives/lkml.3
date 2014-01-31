Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaAaXwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:52:46 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:58586 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaAaXwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:52:45 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 18:52:45 EST
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] firmware: use power efficient workqueue for unloading and aborting fw load
Date: Fri, 31 Jan 2014 15:44:58 -0800
Message-Id: <1391211898-18776-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

Allow the scheduler to select the most appropriate CPU for running the
firmware load timeout routine and delayed routine for firmware unload.
This extends idle residency times and conserves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel, added commit message.
Fixed code alignment.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/base/firmware_class.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8a97ddf..ae34219 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -900,7 +900,8 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		dev_set_uevent_suppress(f_dev, false);
 		dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
 		if (timeout != MAX_SCHEDULE_TIMEOUT)
-			schedule_delayed_work(&fw_priv->timeout_work, timeout);
+			queue_delayed_work(system_power_efficient_wq,
+					   &fw_priv->timeout_work, timeout);
 
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
@@ -1570,8 +1571,8 @@ static void device_uncache_fw_images_work(struct work_struct *work)
  */
 static void device_uncache_fw_images_delay(unsigned long delay)
 {
-	schedule_delayed_work(&fw_cache.work,
-			msecs_to_jiffies(delay));
+	queue_delayed_work(system_power_efficient_wq, &fw_cache.work,
+			   msecs_to_jiffies(delay));
 }
 
 static int fw_pm_notify(struct notifier_block *notify_block,
-- 
1.7.9.5

