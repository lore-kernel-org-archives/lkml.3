Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3JMSHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:07:32 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:37426 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754840Ab3JMSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:07:31 -0400
Date: Sun, 13 Oct 2013 20:07:27 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [GIT PULL REQUEST] watchdog - v3.12-rc4 Fixes
Message-ID: <20131013180727.GN401@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This will fix a deadlock on the ts72xx_wdt driver,
fix bitmasks in the kempld_wdt driver and
fix a section mismatch in the sunxi_wdt driver.

This will update the following files:

 kempld_wdt.c |    2 +-
 sunxi_wdt.c  |    4 ++--
 ts72xx_wdt.c |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

with these Changes:

commit 1d5898b4f8a0f6e231546d30dd54f6f9b89c232c
Author: Maxime Ripard <maxime.ripard@free-electrons.com>
Date:   Sat Oct 5 16:20:17 2013 +0200

    watchdog: sunxi: Fix section mismatch
    
    This driver has a section mismatch, for probe and remove functions,
    leading to the following warning during the compilation.
    
    WARNING: drivers/watchdog/built-in.o(.data+0x24): Section mismatch in
    reference from the variable sunxi_wdt_driver to the function
    .init.text:sunxi_wdt_probe()
    The variable sunxi_wdt_driver references
    the function __init sunxi_wdt_probe()
    
    Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4c4e45669de475573b15d968a6dca8d00124c9ad
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Mon Sep 23 19:16:57 2013 +0900

    watchdog: kempld_wdt: Fix bit mask definition
    
    STAGE_CFG bits are defined as [5:4] bits. However, '(((x) & 0x30) << 4)'
    handles [9:8] bits. Thus, it should be fixed in order to handle
    [5:4] bits.
    
    Signed-off-by: Jingoo Han <jg1.han@samsung.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8612ed0d97abcf1c016d34755b7cf2060de71963
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Aug 23 11:40:59 2013 +0300

    watchdog: ts72xx_wdt: locking bug in ioctl
    
    Calling the WDIOC_GETSTATUS & WDIOC_GETBOOTSTATUS and twice will cause a
    interruptible deadlock.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 1eff743..ae60406 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -814,6 +814,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	hpwdt_timer_reg = pci_mem_addr + 0x70;
 	hpwdt_timer_con = pci_mem_addr + 0x72;
 
+	/* Make sure that timer is disabled until /dev/watchdog is opened */
+	hpwdt_stop();
+
 	/* Make sure that we have a valid soft_margin */
 	if (hpwdt_change_timer(soft_margin))
 		hpwdt_change_timer(DEFAULT_MARGIN);
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 6aa46a9..3796434 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -128,11 +128,12 @@ EXPORT_SYMBOL_GPL(watchdog_register_device);
 void watchdog_unregister_device(struct watchdog_device *wdd)
 {
 	int ret;
-	int devno = wdd->cdev.dev;
+	int devno;
 
 	if (wdd == NULL)
 		return;
 
+	devno = wdd->cdev.dev;
 	ret = watchdog_dev_unregister(wdd);
 	if (ret)
 		pr_err("error unregistering /dev/watchdog (err=%d)\n", ret);
