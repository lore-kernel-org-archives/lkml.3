Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbbATMgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:36:38 -0500
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:19456
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753086AbbATMgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:36:01 -0500
From: Zidan Wang <zidan.wang@freescale.com>
To: <timur@tabi.org>
CC: <nicoleotsuka@gmail.com>, <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Zidan Wang <zidan.wang@freescale.com>
Subject: [alsa-devel][PATCH 3/3] ASoC: fsl_sai: Add support for Right-J mode
Date: Tue, 20 Jan 2015 20:21:20 +0800
Message-ID: <1421756480-7055-4-git-send-email-zidan.wang@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=zidan.wang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(6806004)(105606002)(106466001)(97736003)(110136001)(2351001)(229853001)(19580405001)(19580395003)(85426001)(86362001)(575784001)(50466002)(87936001)(48376002)(77096005)(68736005)(50986999)(76176999)(62966003)(77156002)(50226001)(2950100001)(46102003)(47776003)(92566002)(64706001)(36756003)(33646002)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1263;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR0301MB1263;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB1263;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1263;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 12:20:49.3931
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB1263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Right-J mode and set TCR5 FBT bit to let data right justify.

Signed-off-by: Zidan Wang <zidan.wang@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 14 +++++++++++---
 sound/soc/fsl/fsl_sai.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 4c5040d..19cd6f3 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -228,7 +228,11 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		sai->is_dsp_mode = true;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
-		/* To be done */
+		/* Frame high, one word length for frame sync */
+		val_cr2 |= FSL_SAI_CR2_BCP;
+		sai->is_right_j_mode = true;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -418,9 +422,13 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	val_cr5 |= FSL_SAI_CR5_WNW(sai->slot_width);
 	val_cr5 |= FSL_SAI_CR5_W0W(sai->slot_width);
 
-	if (sai->is_lsb_first)
+	if (sai->is_lsb_first && sai->is_right_j_mode)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
-	else
+	else if (sai->is_lsb_first && !sai->is_right_j_mode)
+		val_cr5 |= FSL_SAI_CR5_FBT(sai->slot_width - word_width);
+	else if (!sai->is_lsb_first && sai->is_right_j_mode)
+		val_cr5 |= FSL_SAI_CR5_FBT(sai->slot_width - 1);
+	else if (!sai->is_lsb_first && !sai->is_right_j_mode)
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
 
 	val_cr4 |= FSL_SAI_CR4_FRSZ(sai->slots * channels);
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 111dfce..e220940 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -137,6 +137,7 @@ struct fsl_sai {
 	bool is_lsb_first;
 	bool is_slave_mode;
 	bool is_dsp_mode;
+	bool is_right_j_mode;
 	bool sai_on_imx;
 	bool synchronous[2];
 
-- 
1.9.1

