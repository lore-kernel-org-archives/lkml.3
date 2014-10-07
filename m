Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaJGFs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:48:29 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:40239 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbaJGF3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:29:23 -0400
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
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 10/44] mfd: axp20x: Register with kernel poweroff handler
Date: Mon,  6 Oct 2014 22:28:12 -0700
Message-Id: <1412659726-29957-11-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=2.8
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.54337A32.0009,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 56
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

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/axp20x.c       | 30 +++++++++++++++++-------------
 include/linux/mfd/axp20x.h |  1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index dee6539..238db4c 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -17,7 +17,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/pm_runtime.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
@@ -161,11 +162,16 @@ static struct mfd_cell axp20x_cells[] = {
 	},
 };
 
-static struct axp20x_dev *axp20x_pm_power_off;
-static void axp20x_power_off(void)
+static int axp20x_power_off(struct notifier_block *this, unsigned long unused1,
+			    void *unused2)
+
 {
-	regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
-		     AXP20X_OFF);
+	struct axp20x_dev *axp20x = container_of(this, struct axp20x_dev,
+						 poweroff_nb);
+
+	regmap_write(axp20x->regmap, AXP20X_OFF_CTRL, AXP20X_OFF);
+
+	return NOTIFY_DONE;
 }
 
 static int axp20x_i2c_probe(struct i2c_client *i2c,
@@ -215,10 +221,11 @@ static int axp20x_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	if (!pm_power_off) {
-		axp20x_pm_power_off = axp20x;
-		pm_power_off = axp20x_power_off;
-	}
+	axp20x->poweroff_nb.notifier_call = axp20x_power_off;
+	axp20x->poweroff_nb.priority = 64;
+	ret = register_poweroff_handler(&axp20x->poweroff_nb);
+	if (ret)
+		dev_err(&i2c->dev, "failed to register poweroff handler\n");
 
 	dev_info(&i2c->dev, "AXP20X driver loaded\n");
 
@@ -229,10 +236,7 @@ static int axp20x_i2c_remove(struct i2c_client *i2c)
 {
 	struct axp20x_dev *axp20x = i2c_get_clientdata(i2c);
 
-	if (axp20x == axp20x_pm_power_off) {
-		axp20x_pm_power_off = NULL;
-		pm_power_off = NULL;
-	}
+	unregister_poweroff_handler(&axp20x->poweroff_nb);
 
 	mfd_remove_devices(axp20x->dev);
 	regmap_del_irq_chip(axp20x->i2c_client->irq, axp20x->regmap_irqc);
diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
index d0e31a2..8f23b39 100644
--- a/include/linux/mfd/axp20x.h
+++ b/include/linux/mfd/axp20x.h
@@ -175,6 +175,7 @@ struct axp20x_dev {
 	struct regmap			*regmap;
 	struct regmap_irq_chip_data	*regmap_irqc;
 	long				variant;
+	struct notifier_block		poweroff_nb;
 };
 
 #endif /* __LINUX_MFD_AXP20X_H */
-- 
1.9.1

