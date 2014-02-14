Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBNEDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:03:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41737 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBNEDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:03:05 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / platform: drop redundant ACPI_HANDLE check
Date: Thu, 13 Feb 2014 22:00:43 -0600
Message-Id: <1392350443-20074-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_dev_pm_attach/_detach functions perform their own checks to
ensure the device has an ACPI companion.  It is not necessary for the
caller to do so.

This mirrors what other busses with ACPI dev PM support do (i2c, spi,
sdio).

Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/base/platform.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index bc78848..e714709 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -481,11 +481,10 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
-	if (ACPI_HANDLE(_dev))
-		acpi_dev_pm_attach(_dev, true);
+	acpi_dev_pm_attach(_dev, true);
 
 	ret = drv->probe(dev);
-	if (ret && ACPI_HANDLE(_dev))
+	if (ret)
 		acpi_dev_pm_detach(_dev, true);
 
 	if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
@@ -508,8 +507,7 @@ static int platform_drv_remove(struct device *_dev)
 	int ret;
 
 	ret = drv->remove(dev);
-	if (ACPI_HANDLE(_dev))
-		acpi_dev_pm_detach(_dev, true);
+	acpi_dev_pm_detach(_dev, true);
 
 	return ret;
 }
@@ -520,8 +518,7 @@ static void platform_drv_shutdown(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 
 	drv->shutdown(dev);
-	if (ACPI_HANDLE(_dev))
-		acpi_dev_pm_detach(_dev, true);
+	acpi_dev_pm_detach(_dev, true);
 }
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

