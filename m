Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaCCQwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:52:33 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53813 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCCQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:52:30 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/2] spmi: pm: drop bus-level PM suspend/resume routines
Date: Mon,  3 Mar 2014 10:49:44 -0600
Message-Id: <1393865384-28145-2-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393865384-28145-1-git-send-email-joshc@codeaurora.org>
References: <1393865384-28145-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPMI defines the behavior of a device in the "SLEEP" state as being
"user-defined or specified by the device manufacturer".  Without
clearly-defined bus-level semantics for low-power states, push the
responsibility of transitioning a device into/out of "SLEEP" into SPMI
device drivers.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/spmi/spmi.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index 6122c8f..3b57807 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -46,40 +46,6 @@ static const struct device_type spmi_ctrl_type = {
 	.release	= spmi_ctrl_release,
 };
 
-#ifdef CONFIG_PM_RUNTIME
-static int spmi_runtime_suspend(struct device *dev)
-{
-	struct spmi_device *sdev = to_spmi_device(dev);
-	int err;
-
-	err = pm_generic_runtime_suspend(dev);
-	if (err)
-		return err;
-
-	return spmi_command_sleep(sdev);
-}
-
-static int spmi_runtime_resume(struct device *dev)
-{
-	struct spmi_device *sdev = to_spmi_device(dev);
-	int err;
-
-	err = spmi_command_wakeup(sdev);
-	if (err)
-		return err;
-
-	return pm_generic_runtime_resume(dev);
-}
-#endif
-
-static const struct dev_pm_ops spmi_pm_ops = {
-	SET_RUNTIME_PM_OPS(
-		spmi_runtime_suspend,
-		spmi_runtime_resume,
-		NULL
-	)
-};
-
 static int spmi_device_match(struct device *dev, struct device_driver *drv)
 {
 	if (of_driver_match_device(dev, drv))
@@ -391,7 +357,6 @@ static int spmi_drv_remove(struct device *dev)
 static struct bus_type spmi_bus_type = {
 	.name		= "spmi",
 	.match		= spmi_device_match,
-	.pm		= &spmi_pm_ops,
 	.probe		= spmi_drv_probe,
 	.remove		= spmi_drv_remove,
 };
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

