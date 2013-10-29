Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3J2K4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:56:53 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:1146
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754290Ab3J2K4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:56:51 -0400
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>,
        Adam Lee <adam.lee@canonical.com>
Subject: [PATCH] mmc:sdhci fix 2 tuning issues in sdchi_exectuing_tuning
Thread-Topic: [PATCH] mmc:sdhci fix 2 tuning issues in sdchi_exectuing_tuning
Thread-Index: AQHO1JWQYqRnIjXknE24ypKivYzBKA==
Date: Tue, 29 Oct 2013 10:56:48 +0000
Message-ID: <d7e7d70b354e45179cbe182d7be18d93@BN1PR04MB091.namprd04.prod.outlook.com>
References: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
 <20131016081532.GB3416@adam-laptop> 
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 0014E2CF50
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(47976001)(47736001)(49866001)(81686001)(53806001)(50986001)(33646001)(46102001)(54356001)(74876001)(80022001)(66066001)(74316001)(74706001)(4396001)(83072001)(77096001)(79102001)(76786001)(80976001)(76576001)(56816003)(65816001)(19580395003)(76796001)(51856001)(87266001)(31966008)(47446002)(63696002)(83322001)(19580405001)(74662001)(74502001)(77982001)(59766001)(85306002)(76482001)(54316002)(69226001)(81342001)(81542001)(56776001)(74366001)(81816001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR04MB186;H:BN1PR04MB091.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;A:0;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. Tuning success at 40th time should be ok, but current code take this as
   failed.
2. tuning_count equals to 0 means disable retuning function, but current
   code still do retuning.

Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
---
 drivers/mmc/host/sdhci.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 68b3cac..9a35a5e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1900,7 +1900,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	 * Issue CMD19 repeatedly till Execute Tuning is set to 0 or the number
 	 * of loops reaches 40 times or a timeout of 150ms occurs.
 	 */
-	timeout = jiffies + msecs_to_jiffies(150);
+z	timeout = jiffies + msecs_to_jiffies(150);
 	do {
 		struct mmc_command cmd = {0};
 		struct mmc_request mrq = {NULL};
@@ -1983,7 +1983,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	 * The Host Driver has exhausted the maximum number of loops allowed,
 	 * so use fixed sampling frequency.
 	 */
-	if (!tuning_loop_counter || time_after(jiffies, timeout)) {
+	if ((tuning_loop_counter < 0) || time_after(jiffies, timeout)) {
 		ctrl &= ~SDHCI_CTRL_TUNED_CLK;
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 		err = -EIO;
@@ -2013,7 +2013,8 @@ out:
 	} else {
 		host->flags &= ~SDHCI_NEEDS_RETUNING;
 		/* Reload the new initial value for timeout workqueue */
-		if (host->tuning_mode == SDHCI_TUNING_MODE_1)
+		if ((host->tuning_mode == SDHCI_TUNING_MODE_1) &&
+				(host->tuning_count))
 			schedule_delayed_work(&host->tuning_timeout_work,
 				host->tuning_count * HZ);
 	}
-- 
1.7.9.5

