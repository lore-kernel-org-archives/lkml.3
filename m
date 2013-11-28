Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3K1He5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:34:57 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:44517
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab3K1He4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:34:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <fabio.estevam@freescale.com>,
        <LW@KARO-electronics.de>, <oskar@scara.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ASoC: SGTL5000: Fix kernel failed while trying to get optional VDDD supply.
Date: Thu, 28 Nov 2013 14:46:59 +0800
Message-ID: <1385621219-20652-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SGTL5000 requires 2 external power supplies: VDDA and VDDIO. An optional
third external power supply VDDD may be provided externally to achieve lower
power.If an external supply is not used for VDDD, the SGTL5000 driver will
register it's own regulator device, and then provides the VDDD supply consumer,
and now there will be two regulator devices exist, local regulator for VDDD
and platform regulator for VDDIO, VDDA.

*******************
*                 *---------|3.3V VDDIO
*                 *
*  SGTL5000 codec *---x   VDDD
*                 *
*                 *---------|3.3V VDDA
*******************

If an external supply is not used for VDDD, in the DT or architecture-specific
file, only "VDDA-supply" and "VDDIO-supply" properties will be presented.
This caused the following kernel failed while trying to get the external VDDD
supply before trying to register it's own regulator device.

sgtl5000 0-000a: Failed to get supply 'VDDD': -19

Here use regulator_get_optional() trying to look at the fact that whether the
external VDDD supply is used or not.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/codecs/sgtl5000.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 1f4093f..90d6d1e 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1298,6 +1298,21 @@ static int sgtl5000_replace_vddd_with_ldo(struct snd_soc_codec *codec)
 	return 0;
 }
 
+static int sgtl5000_external_vddd_used(struct snd_soc_codec *codec)
+{
+	struct regulator *consumer;
+	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
+
+	consumer = regulator_get_optional(codec->dev,
+			sgtl5000->supplies[VDDD].supply);
+	if (IS_ERR(consumer))
+		return 0;
+
+	regulator_put(consumer);
+
+	return 1;
+}
+
 static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
 {
 	int reg;
@@ -1310,11 +1325,15 @@ static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
 	for (i = 0; i < ARRAY_SIZE(sgtl5000->supplies); i++)
 		sgtl5000->supplies[i].supply = supply_names[i];
 
-	ret = regulator_bulk_get(codec->dev, ARRAY_SIZE(sgtl5000->supplies),
+	if (sgtl5000_external_vddd_used(codec)) {
+		ret = regulator_bulk_get(codec->dev,
+				ARRAY_SIZE(sgtl5000->supplies),
 				sgtl5000->supplies);
-	if (!ret)
+		if (ret)
+			return ret;
+
 		external_vddd = 1;
-	else {
+	} else {
 		ret = sgtl5000_replace_vddd_with_ldo(codec);
 		if (ret)
 			return ret;
-- 
1.8.4


