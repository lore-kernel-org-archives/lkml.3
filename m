Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaGDJPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:15:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59560 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaGDJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:15:50 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        trblinux@gmail.com
Subject: [PATCH 1/2] ASoC: max98090: Add check for CODEC type
Date: Fri,  4 Jul 2014 14:42:16 +0530
Message-Id: <1404465137-14295-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CODEC type (MAX98090/MAX98091) can be specified from device-tree file,
it can also be obtained from the CODEC during runtime.

Add an explicit check to figure out if both are matching, else print
a message warning about the same.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 sound/soc/codecs/max98090.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index ca74f502..1ed06d9 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2215,6 +2215,7 @@ static int max98090_probe(struct snd_soc_codec *codec)
 {
 	struct max98090_priv *max98090 = snd_soc_codec_get_drvdata(codec);
 	struct max98090_cdata *cdata;
+	enum max98090_type devtype;
 	int ret = 0;
 
 	dev_dbg(codec->dev, "max98090_probe\n");
@@ -2250,16 +2251,21 @@ static int max98090_probe(struct snd_soc_codec *codec)
 	}
 
 	if ((ret >= M98090_REVA) && (ret <= M98090_REVA + 0x0f)) {
-		max98090->devtype = MAX98090;
+		devtype = MAX98090;
 		dev_info(codec->dev, "MAX98090 REVID=0x%02x\n", ret);
 	} else if ((ret >= M98091_REVA) && (ret <= M98091_REVA + 0x0f)) {
-		max98090->devtype = MAX98091;
+		devtype = MAX98091;
 		dev_info(codec->dev, "MAX98091 REVID=0x%02x\n", ret);
 	} else {
-		max98090->devtype = MAX98090;
+		devtype = MAX98090;
 		dev_err(codec->dev, "Unrecognized revision 0x%02x\n", ret);
 	}
 
+	if (max98090->devtype != devtype) {
+		dev_warn(codec->dev, "Mismatch in DT specified CODEC type.\n");
+		max98090->devtype = devtype;
+	}
+
 	max98090->jack_state = M98090_JACK_STATE_NO_HEADSET;
 
 	INIT_DELAYED_WORK(&max98090->jack_work, max98090_jack_work);
-- 
1.7.9.5

