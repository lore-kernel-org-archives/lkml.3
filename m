Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaJUEOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:14:17 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33753 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaJUEOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:14:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 25/47] power/reset: qnap-poweroff: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:41 -0700
Message-Id: <1413864783-3271-26-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD93.008C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 142
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
directly. Register with default priority to reflect that the original
code generates an error if another poweroff handler has already been
registered when the driver is loaded.

Drop remove function since it is no longer needed.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use devm_register_power_off_handler
- Drop remove function since it is no longer needed

 drivers/power/reset/qnap-poweroff.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/power/reset/qnap-poweroff.c b/drivers/power/reset/qnap-poweroff.c
index a75db7f..da3d58a 100644
--- a/drivers/power/reset/qnap-poweroff.c
+++ b/drivers/power/reset/qnap-poweroff.c
@@ -16,7 +16,9 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/serial_reg.h>
 #include <linux/kallsyms.h>
 #include <linux/of.h>
@@ -55,7 +57,8 @@ static void __iomem *base;
 static unsigned long tclk;
 static const struct power_off_cfg *cfg;
 
-static void qnap_power_off(void)
+static int qnap_power_off(struct notifier_block *this, unsigned long unused1,
+			  void *unused2)
 {
 	const unsigned divisor = ((tclk + (8 * cfg->baud)) / (16 * cfg->baud));
 
@@ -72,14 +75,20 @@ static void qnap_power_off(void)
 
 	/* send the power-off command to PIC */
 	writel(cfg->cmd, UART1_REG(TX));
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block qnap_poweroff_nb = {
+	.notifier_call = qnap_power_off,
+	.priority = POWEROFF_PRIORITY_DEFAULT,
+};
+
 static int qnap_power_off_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct resource *res;
 	struct clk *clk;
-	char symname[KSYM_NAME_LEN];
 
 	const struct of_device_id *match =
 		of_match_node(qnap_power_off_of_match_table, np);
@@ -106,28 +115,11 @@ static int qnap_power_off_probe(struct platform_device *pdev)
 
 	tclk = clk_get_rate(clk);
 
-	/* Check that nothing else has already setup a handler */
-	if (pm_power_off) {
-		lookup_symbol_name((ulong)pm_power_off, symname);
-		dev_err(&pdev->dev,
-			"pm_power_off already claimed %p %s",
-			pm_power_off, symname);
-		return -EBUSY;
-	}
-	pm_power_off = qnap_power_off;
-
-	return 0;
-}
-
-static int qnap_power_off_remove(struct platform_device *pdev)
-{
-	pm_power_off = NULL;
-	return 0;
+	return devm_register_power_off_handler(&pdev->dev, &qnap_poweroff_nb);
 }
 
 static struct platform_driver qnap_power_off_driver = {
 	.probe	= qnap_power_off_probe,
-	.remove	= qnap_power_off_remove,
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "qnap_power_off",
-- 
1.9.1

