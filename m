Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbbAEL1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:27:12 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44152 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbAEL1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:27:11 -0500
From: Cheng-Yi Chiang <cychiang@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dylan Reid <dgreid@chromium.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: ts3a227e: Check and report jack status at probe
Date: Mon,  5 Jan 2015 19:26:59 +0800
Message-Id: <1420457219-23098-1-git-send-email-cychiang@chromium.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ts3a227e does not trigger interrupt to report jack status when system
boots from warm reset because ts3a227e's power remains on during warm reset.
Read jack status at probe to get current jack status.
Note that if system boots from EC reset, then this issue will not
happen.

Signed-off-by: Cheng-Yi Chiang <cychiang@chromium.org>
---
 sound/soc/codecs/ts3a227e.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/ts3a227e.c b/sound/soc/codecs/ts3a227e.c
index 1d12057..9f2dced 100644
--- a/sound/soc/codecs/ts3a227e.c
+++ b/sound/soc/codecs/ts3a227e.c
@@ -254,6 +254,7 @@ static int ts3a227e_i2c_probe(struct i2c_client *i2c,
 	struct ts3a227e *ts3a227e;
 	struct device *dev = &i2c->dev;
 	int ret;
+	unsigned int acc_reg;
 
 	ts3a227e = devm_kzalloc(&i2c->dev, sizeof(*ts3a227e), GFP_KERNEL);
 	if (ts3a227e == NULL)
@@ -283,6 +284,11 @@ static int ts3a227e_i2c_probe(struct i2c_client *i2c,
 			   INTB_DISABLE | ADC_COMPLETE_INT_DISABLE,
 			   ADC_COMPLETE_INT_DISABLE);
 
+	/* Read jack status because chip might not trigger interrupt at boot. */
+	regmap_read(ts3a227e->regmap, TS3A227E_REG_ACCESSORY_STATUS, &acc_reg);
+	ts3a227e_new_jack_state(ts3a227e, acc_reg);
+	ts3a227e_jack_report(ts3a227e);
+
 	return 0;
 }
 
-- 
2.1.2

