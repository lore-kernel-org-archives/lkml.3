Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3KZKoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:44:02 -0500
Received: from [216.32.180.186] ([216.32.180.186]:23864 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755189Ab3KZKn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:43:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <fabio.estevam@freescale.com>,
        <LW@KARO-electronics.de>, <oskar@scara.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting regulator consumers
Date: Tue, 26 Nov 2013 17:55:13 +0800
Message-ID: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SGTL5000 codec allows to use the internal LDO instead of VDDD, if the
internal LDO is used, this caused the following kernel failed while trying
to get the external VDDD regulator consumer.

Adding sgtl5000_external_vddd_used() to fix it. And this has been tested on
VF610-TWR board.

sgtl5000 0-000a: Failed to get supply 'VDDD': -19

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

 sound/soc/codecs/sgtl5000.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 1f4093f..1a2d35a 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1298,6 +1298,20 @@ static int sgtl5000_replace_vddd_with_ldo(struct snd_soc_codec *codec)
 	return 0;
 }
 
+static int sgtl5000_external_vddd_used(struct snd_soc_codec *codec)
+{
+	struct regulator *consumer;
+	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
+
+	consumer = regulator_get(codec->dev, sgtl5000->supplies[VDDD].supply);
+	if (IS_ERR(consumer)) {
+		return 0;
+	}
+	regulator_put(consumer);
+
+	return 1;
+}
+
 static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
 {
 	int reg;
@@ -1310,9 +1324,7 @@ static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
 	for (i = 0; i < ARRAY_SIZE(sgtl5000->supplies); i++)
 		sgtl5000->supplies[i].supply = supply_names[i];
 
-	ret = regulator_bulk_get(codec->dev, ARRAY_SIZE(sgtl5000->supplies),
-				sgtl5000->supplies);
-	if (!ret)
+	if (sgtl5000_external_vddd_used(codec))
 		external_vddd = 1;
 	else {
 		ret = sgtl5000_replace_vddd_with_ldo(codec);
-- 
1.8.4


