Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaKHAix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:38:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaKHAiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:38:50 -0500
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>
Date: Sat, 08 Nov 2014 11:38:03 +1100
Subject: [PATCH 1/3] ASoC: twl4030: don't report EBUSY if no change
 requested.
Cc: GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108003803.6561.42934.stgit@notabene.brown>
In-Reply-To: <20141108002637.6561.19002.stgit@notabene.brown>
References: <20141108002637.6561.19002.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"mode" must not be changed when active.
However if a request is received to set the mode to what it currently
is, that is also rejected when active, which causes confusing
error messages.

So check first and if no change is actually requested, don't report
an error.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 sound/soc/codecs/twl4030.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index b6b0cb399599..c873f5887486 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -957,6 +957,12 @@ static int snd_soc_put_twl4030_opmode_enum_double(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_codec *codec = snd_soc_kcontrol_codec(kcontrol);
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+	int val = ucontrol->value.integer.value[0];
+
+	if (!!(twl4030_read(codec, TWL4030_REG_CODEC_MODE)
+	       & TWL4030_OPTION_1) == !!val)
+		/* No change */
+		return 0;
 
 	if (twl4030->configured) {
 		dev_err(codec->dev,


