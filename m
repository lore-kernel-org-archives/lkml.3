Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaJUENw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:13:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33650 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaJUENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:48 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 15/47] mfd: dm355evm_msp: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:31 -0700
Message-Id: <1413864783-3271-16-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD7C.009A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 89
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
directly. Register with low priority to reflect that the original code
only sets pm_power_off if it was not already set.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 drivers/mfd/dm355evm_msp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 4c826f7..3ec49a7 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -14,6 +14,8 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
@@ -352,14 +354,22 @@ static void dm355evm_command(unsigned command)
 				command, status);
 }
 
-static void dm355evm_power_off(void)
+static int dm355evm_power_off(struct notifier_block *this,
+			      unsigned long unused1, void *unused2)
 {
 	dm355evm_command(MSP_COMMAND_POWEROFF);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block dm355evm_msp_poweroff_nb = {
+	.notifier_call = dm355evm_power_off,
+	.priority = POWEROFF_PRIORITY_LOW,
+};
+
 static int dm355evm_msp_remove(struct i2c_client *client)
 {
-	pm_power_off = NULL;
+	unregister_power_off_handler(&dm355evm_msp_poweroff_nb);
 	msp430 = NULL;
 	return 0;
 }
@@ -398,7 +408,9 @@ dm355evm_msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto fail;
 
 	/* PM hookup */
-	pm_power_off = dm355evm_power_off;
+	status = register_power_off_handler(&dm355evm_msp_poweroff_nb);
+	if (status)
+		dev_warn(&client->dev, "Failed to register poweroff handler\n");
 
 	return 0;
 
-- 
1.9.1

