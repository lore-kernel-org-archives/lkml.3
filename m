Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaIIK3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:29:34 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61567 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbaIIK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:29:32 -0400
Message-ID: <1410258569.15354.3.camel@lp-lvrv.comap.cz>
Subject: Watchdog start during boot
From: Lisovy Rostislav <lisovy@gmail.com>
To: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Michal Vokac <michal.vokac@comap.cz>
Date: Tue, 09 Sep 2014 12:29:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
If my understanding is correct, the purpose of the "watchdog subsystem"
is to provide an unified interface from user-space to watchdog devices
(via /dev). The issue I am trying to solve is how to start the watchdog
during boot (it would be sufficient just not to disable it since the
bootloader enables it) to be controlled later on with the user-space
tool -- i.e. when the user-space will not boot properly, I would like
the device to be rebooted.

My "quick and dirty" device-specific solution is:

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3691b15..1e44b03f 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -53,6 +53,10 @@ static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
+static bool start_on_boot = false;
+module_param(start_on_boot, bool, 0);
+MODULE_PARM_DESC(start_on_boot, "Start the watchdog during boot");
+
 struct omap_wdt_dev {
        void __iomem    *base;          /* physical */
        struct device   *dev;
@@ -269,6 +273,9 @@ static int omap_wdt_probe(struct platform_device *pdev)
 
        pm_runtime_put_sync(wdev->dev);
 
+       if (start_on_boot)
+               omap_wdt_start(omap_wdt);
+
        return 0;
 }

however I think it would be much beneficial to do this in a generic way.
Maybe to create a device tree property, that would store some flag to
start the watchdog during boot?

Your opinion is appreciated.
 
Best regards;
Rostislav Lisovy


