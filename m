Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaHHGrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:47:35 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:41672
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755865AbaHHGrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:47:31 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 2/2] Revert "ASoC: fsl-esai: Add .xlate_tdm_slot_mask() support."
Date: Fri, 8 Aug 2014 14:47:22 +0800
Message-ID: <8572e62c70f2f3427693eb40eb953ef236d5aef7.1407480333.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407480333.git.shengjiu.wang@freescale.com>
References: <cover.1407480333.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(64706001)(80022001)(4396001)(93916002)(86362001)(21056001)(77156001)(85852003)(83072002)(50226001)(44976005)(6806004)(19580395003)(19580405001)(83322001)(20776003)(99396002)(47776003)(48376002)(97736001)(68736004)(84676001)(50466002)(107046002)(229853001)(89996001)(74502001)(74662001)(31966008)(50986999)(76176999)(26826002)(46102001)(85306004)(87936001)(87286001)(95666004)(36756003)(76482001)(81342001)(104166001)(102836001)(92566001)(92726001)(62966002)(81542001)(2201001)(105606002)(104016003)(33646002)(106466001)(88136002)(77982001)(79102001)(142923001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB243;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a603c8ee526f5ea9ad9b40710308766299ad8a69.

fsl_asoc_xlate_tdm_slot_mask() is different with snd_soc_xlate_tdm_slot_mask().
fsl_asoc_xlate_tdm_slot_mask() will set the enabled bit to 0, disabled bit
to 1. snd_soc_xlate_tdm_slot_mask() will set the enabled bit to 1, disabled
bit to 0.
For esai when the bit value is 1, the slot is enabled, when the bit value is 0,
the slot is disabled. If using fsl_asoc_xlate_tdm_slot_mask(), the esai will
work abnormally. So revert this patch, make the esai use default function.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/Kconfig    |    1 -
 sound/soc/fsl/fsl_esai.c |    2 --
 2 files changed, 3 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index f54a8fc..f3012b6 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -49,7 +49,6 @@ config SND_SOC_FSL_ESAI
 	tristate "Enhanced Serial Audio Interface (ESAI) module support"
 	select REGMAP_MMIO
 	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
-	select SND_SOC_FSL_UTILS
 	help
 	  Say Y if you want to add Enhanced Synchronous Audio Interface
 	  (ESAI) support for the Freescale CPUs.
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index f252370..b2f6b3e 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -18,7 +18,6 @@
 
 #include "fsl_esai.h"
 #include "imx-pcm.h"
-#include "fsl_utils.h"
 
 #define FSL_ESAI_RATES		SNDRV_PCM_RATE_8000_192000
 #define FSL_ESAI_FORMATS	(SNDRV_PCM_FMTBIT_S8 | \
@@ -612,7 +611,6 @@ static struct snd_soc_dai_ops fsl_esai_dai_ops = {
 	.hw_params = fsl_esai_hw_params,
 	.set_sysclk = fsl_esai_set_dai_sysclk,
 	.set_fmt = fsl_esai_set_dai_fmt,
-	.xlate_tdm_slot_mask = fsl_asoc_xlate_tdm_slot_mask,
 	.set_tdm_slot = fsl_esai_set_dai_tdm_slot,
 };
 
-- 
1.7.9.5

