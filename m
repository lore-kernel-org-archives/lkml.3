Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaHELfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:35:43 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57997 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaHELfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:35:41 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: tps65910: Fix potential NULL-pointer dereference
Date: Tue,  5 Aug 2014 13:35:38 +0200
Message-Id: <1407238538-13997-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The interrupt handler gets the driver data associated with the RTC
device and doesn't check it for validity. This can cause a NULL pointer
being dereferenced when and interrupt fires before the driver data was
properly set up.

Fix this by setting the driver data earlier (before the interrupt is
requested).

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 7af00208d637..2583349fbde5 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -258,6 +258,8 @@ static int tps65910_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	platform_set_drvdata(pdev, tps_rtc);
+
 	irq  = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
@@ -283,8 +285,6 @@ static int tps65910_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, tps_rtc);
-
 	return 0;
 }
 
-- 
2.0.4

