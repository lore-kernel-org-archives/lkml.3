Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaJGFmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:42:14 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:40645 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaJGFaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:30:03 -0400
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
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 28/44] x86: olpc: Register xo1 poweroff handler with kernel poweroff handler
Date: Mon,  6 Oct 2014 22:28:30 -0700
Message-Id: <1412659726-29957-29-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=0.3
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.54337A5A.0075,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 381
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
directly. Register with high priority value of 192 to reflect that
the driver explicitly wants to override default poweroff handlers.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/x86/platform/olpc/olpc-xo1-pm.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1-pm.c b/arch/x86/platform/olpc/olpc-xo1-pm.c
index a9acde7..96fba36 100644
--- a/arch/x86/platform/olpc/olpc-xo1-pm.c
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -15,6 +15,7 @@
 #include <linux/cs5535.h>
 #include <linux/platform_device.h>
 #include <linux/export.h>
+#include <linux/notifier.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
 #include <linux/suspend.h>
@@ -92,7 +93,8 @@ asmlinkage __visible int xo1_do_sleep(u8 sleep_state)
 	return 0;
 }
 
-static void xo1_power_off(void)
+static int xo1_power_off(struct notifier_block *this, unsigned long unused1,
+			 void *unused2)
 {
 	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
 
@@ -108,8 +110,15 @@ static void xo1_power_off(void)
 
 	/* Write SLP_EN bit to start the machinery */
 	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block xo1_poweroff_nb = {
+	.notifier_call = xo1_power_off,
+	.priority = 192,
+};
+
 static int xo1_power_state_valid(suspend_state_t pm_state)
 {
 	/* suspend-to-RAM only */
@@ -146,8 +155,12 @@ static int xo1_pm_probe(struct platform_device *pdev)
 
 	/* If we have both addresses, we can override the poweroff hook */
 	if (pms_base && acpi_base) {
+		err = register_poweroff_handler(&xo1_poweroff_nb);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to register poweroff handler\n");
+			return err;
+		}
 		suspend_set_ops(&xo1_suspend_ops);
-		pm_power_off = xo1_power_off;
 		printk(KERN_INFO "OLPC XO-1 support registered\n");
 	}
 
@@ -158,12 +171,13 @@ static int xo1_pm_remove(struct platform_device *pdev)
 {
 	mfd_cell_disable(pdev);
 
+	unregister_poweroff_handler(&xo1_poweroff_nb);
+
 	if (strcmp(pdev->name, "cs5535-pms") == 0)
 		pms_base = 0;
 	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
 		acpi_base = 0;
 
-	pm_power_off = NULL;
 	return 0;
 }
 
-- 
1.9.1

