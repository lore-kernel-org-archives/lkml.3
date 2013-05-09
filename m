Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3EIGgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 02:36:41 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:45934 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173Ab3EIGgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 02:36:40 -0400
Date: Thu, 9 May 2013 08:36:33 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [GIT PULL REQUEST] watchdog - v3.10-rc1 patches
Message-ID: <20130509063633.GV14155@spo001.leaseweb.com>
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

It will fix a kdump issue in hpwdt and a possible NULL dereference.

This will update the following files:

 ath79_wdt.c    |    8 +++-----
 davinci_wdt.c  |    9 ++++-----
 s3c2410_wdt.c  |    7 +++----
 shwdt.c        |    7 ++++---
 watchdog_dev.c |    3 ++-
 5 files changed, 16 insertions(+), 18 deletions(-)

with these Changes:

commit 60403f7a4d9368d187f79cba5e4672d01df37574
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Fri Apr 5 21:22:43 2013 -0700

    watchdog: Fix race condition in registration code
    
    A race condition exists when registering the first watchdog device.
    Sequence of events:
    
    - watchdog_register_device calls watchdog_dev_register
    - watchdog_dev_register creates the watchdog misc device by calling
      misc_register.
      At that time, the matching character device (/dev/watchdog0) does not yet
      exist, and old_wdd is not set either.
    - Userspace gets an event and opens /dev/watchdog
    - watchdog_open is called and sets wdd = old_wdd, which is still NULL,
      and tries to dereference it. This causes the kernel to panic.
    
    Seen with systemd trying to open /dev/watchdog immediately after
    it was created.
    
    Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6330c7070be6783b82025d2bc259db8413c00182
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Mon Mar 4 10:36:41 2013 +0530

    watchdog: Convert to devm_ioremap_resource()
    
    Use the newly introduced devm_ioremap_resource() instead of
    devm_request_and_ioremap() which provides more consistent error handling.
    
    devm_ioremap_resource() provides its own error messages; so all explicit
    error messages can be removed from the failure code paths.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
    Cc: Gabor Juhos <juhosg@openwrt.org>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 8987990..d184c48 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -253,11 +253,9 @@ static int ath79_wdt_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	wdt_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!wdt_base) {
-		dev_err(&pdev->dev, "unable to remap memory region\n");
-		return -ENOMEM;
-	}
+	wdt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(wdt_base))
+		return PTR_ERR(wdt_base);
 
 	wdt_clk = devm_clk_get(&pdev->dev, "wdt");
 	if (IS_ERR(wdt_clk))
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 7df1fdc..100d4fb 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -221,11 +222,9 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	wdt_base = devm_request_and_ioremap(dev, wdt_mem);
-	if (!wdt_base) {
-		dev_err(dev, "ioremap failed\n");
-		return -EADDRNOTAVAIL;
-	}
+	wdt_base = devm_ioremap_resource(dev, wdt_mem);
+	if (IS_ERR(wdt_base))
+		return PTR_ERR(wdt_base);
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index c1a221c..ee03135 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -330,10 +330,9 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	}
 
 	/* get the memory region for the watchdog timer */
-	wdt_base = devm_request_and_ioremap(dev, wdt_mem);
-	if (wdt_base == NULL) {
-		dev_err(dev, "failed to devm_request_and_ioremap() region\n");
-		ret = -ENOMEM;
+	wdt_base = devm_ioremap_resource(dev, wdt_mem);
+	if (IS_ERR(wdt_base)) {
+		ret = PTR_ERR(wdt_base);
 		goto err;
 	}
 
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 6a89e40..6185af2 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <asm/watchdog.h>
 
 #define DRV_NAME "sh-wdt"
@@ -249,9 +250,9 @@ static int sh_wdt_probe(struct platform_device *pdev)
 		wdt->clk = NULL;
 	}
 
-	wdt->base = devm_request_and_ioremap(wdt->dev, res);
-	if (unlikely(!wdt->base)) {
-		rc = -EADDRNOTAVAIL;
+	wdt->base = devm_ioremap_resource(wdt->dev, res);
+	if (IS_ERR(wdt->base)) {
+		rc = PTR_ERR(wdt->base);
 		goto err;
 	}
 
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 08b48bb..faf4e18 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -523,6 +523,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	int err, devno;
 
 	if (watchdog->id == 0) {
+		old_wdd = watchdog;
 		watchdog_miscdev.parent = watchdog->parent;
 		err = misc_register(&watchdog_miscdev);
 		if (err != 0) {
@@ -531,9 +532,9 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 			if (err == -EBUSY)
 				pr_err("%s: a legacy watchdog module is probably present.\n",
 					watchdog->info->identity);
+			old_wdd = NULL;
 			return err;
 		}
-		old_wdd = watchdog;
 	}
 
 	/* Fill in the data structures */
