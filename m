Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaKFQpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:45:00 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56376 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaKFQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:48 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH v5 29/48] power/reset: ltc2952-poweroff: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:13 -0800
Message-Id: <1415292213-28652-30-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.545BA580.0149,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 164
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

Register with kernel power-off handler instead of setting pm_power_off
directly. Register with low priority to reflect that the original code
sets pm_power_off only if it was not already set.

Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Added patch

 drivers/power/reset/ltc2952-poweroff.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 116a1ce..e622824 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -80,6 +80,8 @@ struct ltc2952_poweroff_data {
 	 * 2: kill
 	 */
 	struct gpio_desc *gpio[3];
+
+	struct power_off_handler_block power_off_hb;
 };
 
 static int ltc2952_poweroff_panic;
@@ -180,7 +182,8 @@ irq_ok:
 	return IRQ_HANDLED;
 }
 
-static void ltc2952_poweroff_kill(void)
+static void ltc2952_poweroff_kill(struct power_off_handler_block *this)
+
 {
 	gpiod_set_value(ltc2952_data->gpio[POWERPATH_IO_KILL], 1);
 }
@@ -285,12 +288,7 @@ err_io:
 
 static int ltc2952_poweroff_probe(struct platform_device *pdev)
 {
-	int ret;
-
-	if (pm_power_off) {
-		dev_err(&pdev->dev, "pm_power_off already registered");
-		return -EBUSY;
-	}
+	int i, ret;
 
 	ltc2952_data = kzalloc(sizeof(*ltc2952_data), GFP_KERNEL);
 	if (!ltc2952_data)
@@ -302,12 +300,20 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	pm_power_off = &ltc2952_poweroff_kill;
+	ltc2952_data->power_off_hb.handler = ltc2952_poweroff_kill;
+	ltc2952_data->power_off_hb.priority = POWER_OFF_PRIORITY_LOW;
+	ret = register_power_off_handler(&ltc2952_data->power_off_hb);
+	if (ret)
+		goto err_power;
 
 	dev_info(&pdev->dev, "probe successful\n");
 
 	return 0;
 
+err_power:
+	free_irq(ltc2952_data->virq, ltc2952_data);
+	for (i = 0; i < ARRAY_SIZE(ltc2952_data->gpio); i++)
+		gpiod_put(ltc2952_data->gpio[i]);
 err:
 	kfree(ltc2952_data);
 	return ret;
@@ -317,7 +323,7 @@ static int ltc2952_poweroff_remove(struct platform_device *pdev)
 {
 	unsigned int i;
 
-	pm_power_off = NULL;
+	unregister_power_off_handler(&ltc2952_data->power_off_hb);
 
 	if (ltc2952_data) {
 		free_irq(ltc2952_data->virq, ltc2952_data);
-- 
1.9.1

