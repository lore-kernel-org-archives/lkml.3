Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3IYDiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:38:10 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:30802
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754095Ab3IYDiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:38:08 -0400
From: Peter Guo <peter.guo@bayhubtech.com>
To: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Samuel Guan <samuel.guan@bayhubtech.com>
Subject: [PATCH 2/2] mmc: sdhci: Fix CMD12 and Tuning issues
Thread-Topic: [PATCH 2/2] mmc: sdhci: Fix CMD12 and Tuning issues
Thread-Index: Ac65nniJ81HD1MrbQ3CHrw0PbgpW6A==
Date: Wed, 25 Sep 2013 03:22:31 +0000
Message-ID: <c0d297a1143e4aab895d809b52838712@BN1PR04MB091.namprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [27.17.7.178]
x-forefront-prvs: 098076C36C
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(56776001)(47736001)(33646001)(76796001)(77096001)(56816003)(49866001)(47976001)(4396001)(50986001)(74876001)(74706001)(76786001)(76576001)(81816001)(76176001)(74316001)(46102001)(81542001)(63696002)(54356001)(81342001)(19580405001)(83322001)(19580395003)(80976001)(53806001)(51856001)(83072001)(66066001)(81686001)(74502001)(65816001)(47446002)(80022001)(74662001)(31966008)(69226001)(59766001)(76482001)(74366001)(77982001)(79102001)(54316002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR04MB233;H:BN1PR04MB091.namprd04.prod.outlook.com;CLIP:27.17.7.178;FPR:;RD:InfoNoRecords;A:0;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: bayhubtech.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "peter.guo" <peter.guo@bayhubtech.com>

- Change tuning_loop_counter check from not zero to less than zero
  in function sdhci_execute_tuning; Becasue some host may need 40 times tuning,
  but orginal code only think tuning times <= 39 is successfull.

- When Host Capability Reg (0x40) bit[43:40] is zero, retuning timer should be disabled.
  But Original code still start the timer.

Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
---
 drivers/mmc/host/sdhci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..69413e4 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1050,6 +1050,13 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 	if (cmd->data || cmd->opcode == MMC_SEND_TUNING_BLOCK ||
 	    cmd->opcode == MMC_SEND_TUNING_BLOCK_HS200)
 		flags |= SDHCI_CMD_DATA;
+	/*
+	 * According to SD Host Spec
+	 * Command Register offset 0xE bit[7:6] is command type
+	 * And Cmd12 should use Abort Type
+	 */
+	if (cmd->opcode == MMC_STOP_TRANSMISSION)
+		flags |= SDHCI_CMD_ABORTCMD;
 
 	sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMMAND);
 }
@@ -1978,7 +1985,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	 * The Host Driver has exhausted the maximum number of loops allowed,
 	 * so use fixed sampling frequency.
 	 */
-	if (!tuning_loop_counter || !timeout) {
+	if ((tuning_loop_counter < 0) || (!timeout)) {
 		ctrl &= ~SDHCI_CTRL_TUNED_CLK;
 		sdhci_writew(host, ctrl, SDHCI_HOST_CONTROL2);
 	} else {
@@ -2007,7 +2014,8 @@ out:
 	} else {
 		host->flags &= ~SDHCI_NEEDS_RETUNING;
 		/* Reload the new initial value for timer */
-		if (host->tuning_mode == SDHCI_TUNING_MODE_1)
+		if ((host->tuning_mode == SDHCI_TUNING_MODE_1) &&
+				(host->tuning_count))
 			mod_timer(&host->tuning_timer, jiffies +
 				host->tuning_count * HZ);
 	}
-- 
1.7.9.5

