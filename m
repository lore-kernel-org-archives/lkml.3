Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaKJBui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:50:38 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39086 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaKJBoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:24 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH v6 27/48] power/reset: vexpress-poweroff: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:44 -0800
Message-Id: <1415583785-6980-28-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54601878.00CD,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 160
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
directly. Select default priority to reflect that the original code sets
pm_power_off unconditionally.

Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
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
- Use define to specify poweroff handler priority

 drivers/power/reset/vexpress-poweroff.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/vexpress-poweroff.c b/drivers/power/reset/vexpress-poweroff.c
index 4dc102e2..ee1bcb5 100644
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -36,11 +36,16 @@ static void vexpress_reset_do(struct device *dev, const char *what)
 
 static struct device *vexpress_power_off_device;
 
-static void vexpress_power_off(void)
+static void vexpress_power_off(struct power_off_handler_block *this)
 {
 	vexpress_reset_do(vexpress_power_off_device, "power off");
 }
 
+static struct power_off_handler_block vexpress_power_off_hb = {
+	.handler = vexpress_power_off,
+	.priority = POWER_OFF_PRIORITY_DEFAULT,
+};
+
 static struct device *vexpress_restart_device;
 
 static void vexpress_restart(enum reboot_mode reboot_mode, const char *cmd)
@@ -92,6 +97,7 @@ static int vexpress_reset_probe(struct platform_device *pdev)
 	const struct of_device_id *match =
 			of_match_device(vexpress_reset_of_match, &pdev->dev);
 	struct regmap *regmap;
+	int ret;
 
 	if (match)
 		func = (enum vexpress_reset_func)match->data;
@@ -106,7 +112,12 @@ static int vexpress_reset_probe(struct platform_device *pdev)
 	switch (func) {
 	case FUNC_SHUTDOWN:
 		vexpress_power_off_device = &pdev->dev;
-		pm_power_off = vexpress_power_off;
+		ret = register_power_off_handler(&vexpress_power_off_hb);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Failed to register power-off handler\n");
+			return ret;
+		}
 		break;
 	case FUNC_RESET:
 		if (!vexpress_restart_device)
-- 
1.9.1

