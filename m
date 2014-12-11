Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbaLKTme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:42:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35533 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbaLKTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:42:33 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sanchayan Maity <maitysanchayan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rtc: snvs: Fix build with CONFIG_PM_SLEEP disabled
Date: Thu, 11 Dec 2014 11:42:18 -0800
Message-Id: <1418326938-7199-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5489F3A8.014D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

Commit 7654e9d4fd8f ("drivers/rtc/rtc-snvs: fix suspend/resume") replaces
SIMPLE_DEV_PM_OPS with direct declaration of snvs_rtc_pm_ops, but does so
outside #ifdef CONFIG_PM_SLEEP. This causes the driver build to fail if
CONFIG_PM_SLEEP is not configured.

Fixes: 7654e9d4fd8f ("drivers/rtc/rtc-snvs: fix suspend/resume")
Cc: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/rtc/rtc-snvs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index 2cd8ffe..942b267 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -344,13 +344,20 @@ static int snvs_rtc_resume(struct device *dev)
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops snvs_rtc_pm_ops = {
 	.suspend_noirq = snvs_rtc_suspend,
 	.resume_noirq = snvs_rtc_resume,
 };
 
+#define SNVS_RTC_PM_OPS	(&snvs_rtc_pm_ops)
+
+#else
+
+#define SNVS_RTC_PM_OPS	NULL
+
+#endif
+
 static const struct of_device_id snvs_dt_ids[] = {
 	{ .compatible = "fsl,sec-v4.0-mon-rtc-lp", },
 	{ /* sentinel */ }
@@ -361,7 +368,7 @@ static struct platform_driver snvs_rtc_driver = {
 	.driver = {
 		.name	= "snvs_rtc",
 		.owner	= THIS_MODULE,
-		.pm	= &snvs_rtc_pm_ops,
+		.pm	= SNVS_RTC_PM_OPS,
 		.of_match_table = snvs_dt_ids,
 	},
 	.probe		= snvs_rtc_probe,
-- 
1.9.1

