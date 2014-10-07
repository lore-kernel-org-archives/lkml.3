Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaJGFnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:43:51 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:40515 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaJGF3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:29:50 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: adi-buildroot-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, lguest@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-am33-list@redhat.com, linux-cris-kernel@axis.com,
        linux-efi@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-m32r-ja@ml.linux-m32r.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org,
        Guenter Roeck <linux@roeck-us.net>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 22/44] power/reset: as3722-poweroff: Register with kernel poweroff handler
Date: Mon,  6 Oct 2014 22:28:24 -0700
Message-Id: <1412659726-29957-23-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=0.3
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54337A4D.00C5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 273
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel poweroff handler instead of setting pm_power_off
directly. Register with a low priority value of 64 to reflect that
the original code only sets pm_power_off if it was not already set.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/as3722-poweroff.c | 36 ++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/power/reset/as3722-poweroff.c b/drivers/power/reset/as3722-poweroff.c
index 6849711..7ebaed9 100644
--- a/drivers/power/reset/as3722-poweroff.c
+++ b/drivers/power/reset/as3722-poweroff.c
@@ -17,32 +17,33 @@
 
 #include <linux/mfd/as3722.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 
 struct as3722_poweroff {
 	struct device *dev;
 	struct as3722 *as3722;
+	struct notifier_block poweroff_nb;
 };
 
-static struct as3722_poweroff *as3722_pm_poweroff;
-
-static void as3722_pm_power_off(void)
+static int as3722_power_off(struct notifier_block *this, unsigned long unused1,
+			    void *unused2)
 {
+	struct as3722_poweroff *as3722_poweroff =
+		container_of(this, struct as3722_poweroff, poweroff_nb);
 	int ret;
 
-	if (!as3722_pm_poweroff) {
-		pr_err("AS3722 poweroff is not initialised\n");
-		return;
-	}
-
-	ret = as3722_update_bits(as3722_pm_poweroff->as3722,
+	ret = as3722_update_bits(as3722_poweroff->as3722,
 		AS3722_RESET_CONTROL_REG, AS3722_POWER_OFF, AS3722_POWER_OFF);
 	if (ret < 0)
-		dev_err(as3722_pm_poweroff->dev,
+		dev_err(as3722_poweroff->dev,
 			"RESET_CONTROL_REG update failed, %d\n", ret);
+
+	return NOTIFY_DONE;
 }
 
 static int as3722_poweroff_probe(struct platform_device *pdev)
@@ -63,18 +64,19 @@ static int as3722_poweroff_probe(struct platform_device *pdev)
 
 	as3722_poweroff->as3722 = dev_get_drvdata(pdev->dev.parent);
 	as3722_poweroff->dev = &pdev->dev;
-	as3722_pm_poweroff = as3722_poweroff;
-	if (!pm_power_off)
-		pm_power_off = as3722_pm_power_off;
+	as3722_poweroff->poweroff_nb.notifier_call = as3722_power_off;
+	as3722_poweroff->poweroff_nb.priority = 64;
 
-	return 0;
+	platform_set_drvdata(pdev, as3722_poweroff);
+
+	return register_poweroff_handler(&as3722_poweroff->poweroff_nb);
 }
 
 static int as3722_poweroff_remove(struct platform_device *pdev)
 {
-	if (pm_power_off == as3722_pm_power_off)
-		pm_power_off = NULL;
-	as3722_pm_poweroff = NULL;
+	struct as3722_poweroff *as3722_poweroff = platform_get_drvdata(pdev);
+
+	unregister_poweroff_handler(&as3722_poweroff->poweroff_nb);
 
 	return 0;
 }
-- 
1.9.1

