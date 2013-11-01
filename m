Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3KAHth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:49:37 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:7470
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab3KAHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:49:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>
CC: <r64188@freescale.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b42378@freescale.com>,
        <b18965@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCHv2 5/8] ASoC: SGTL5000: Enhance the SGTL5000 codec driver about regulator.
Date: Fri, 1 Nov 2013 15:04:52 +0800
Message-ID: <1383289495-24523-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On VF610 series there are no regulators used, and now whether the
CONFIG_REGULATOR mirco is enabled or not, for the VF610 audio
patch series, the board cannot be probe successfully.
And this patch will solve this issue.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/codecs/sgtl5000.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 1f4093f..c2f6d86 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -61,6 +61,7 @@ static const struct reg_default sgtl5000_reg_defaults[] = {
 	{ SGTL5000_DAP_AVC_DECAY,		0x0050 },
 };
 
+#ifdef CONFIG_REGULATOR
 /* regulator supplies for sgtl5000, VDDD is an optional external supply */
 enum sgtl5000_regulator_supplies {
 	VDDA,
@@ -93,6 +94,9 @@ static struct regulator_init_data ldo_init_data = {
 	.num_consumer_supplies = 1,
 	.consumer_supplies = &ldo_consumer[0],
 };
+#else
+#define SGTL5000_SUPPLY_NUM 0
+#endif
 
 /*
  * sgtl5000 internal ldo regulator,
@@ -112,7 +116,9 @@ struct sgtl5000_priv {
 	int master;	/* i2s master or not */
 	int fmt;	/* i2s data format */
 	struct regulator_bulk_data supplies[SGTL5000_SUPPLY_NUM];
+#ifdef CONFIG_REGULATOR
 	struct ldo_regulator *ldo;
+#endif
 	struct regmap *regmap;
 	struct clk *mclk;
 };
@@ -879,6 +885,7 @@ static int ldo_regulator_remove(struct snd_soc_codec *codec)
 	return 0;
 }
 #else
+#ifndef CONFIG_SND_SOC_FSL_SGTL5000_VF610
 static int ldo_regulator_register(struct snd_soc_codec *codec,
 				struct regulator_init_data *init_data,
 				int voltage)
@@ -886,6 +893,7 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 	dev_err(codec->dev, "this setup needs regulator support in the kernel\n");
 	return -EINVAL;
 }
+#endif
 
 static int ldo_regulator_remove(struct snd_soc_codec *codec)
 {
@@ -1137,6 +1145,7 @@ static int sgtl5000_resume(struct snd_soc_codec *codec)
 #define sgtl5000_resume  NULL
 #endif	/* CONFIG_SUSPEND */
 
+#ifdef CONFIG_REGULATOR
 /*
  * sgtl5000 has 3 internal power supplies:
  * 1. VAG, normally set to vdda/2
@@ -1373,6 +1382,7 @@ err_regulator_free:
 	return ret;
 
 }
+#endif
 
 static int sgtl5000_probe(struct snd_soc_codec *codec)
 {
@@ -1387,6 +1397,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
+#ifdef CONFIG_REGULATOR
 	ret = sgtl5000_enable_regulators(codec);
 	if (ret)
 		return ret;
@@ -1395,6 +1406,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 	ret = sgtl5000_set_power_regs(codec);
 	if (ret)
 		goto err;
+#endif
 
 	/* enable small pop, introduce 400ms delay in turning off */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
-- 
1.8.4


