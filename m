Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaDEVhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:37:33 -0400
Received: from ring0.de ([5.45.105.125]:47216 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbaDEVhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:37:14 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 5/5] ASoC: tlv320aic3x: fix shared reset pin for DT
Date: Sat,  5 Apr 2014 23:35:53 +0200
Message-Id: <1396733753-9820-6-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396733753-9820-1-git-send-email-sre@kernel.org>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the second tlv320aic3x instance fails to
be probed from DT if the reset pin is shared with
the first one.

This patch fixes it by moving the list add of the
reset pin into the i2c_probe method.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/codecs/tlv320aic3x.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index b183510..d7349bc 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1399,7 +1399,6 @@ static int aic3x_probe(struct snd_soc_codec *codec)
 	}
 
 	aic3x_add_widgets(codec);
-	list_add(&aic3x->list, &reset_list);
 
 	return 0;
 
@@ -1569,7 +1568,13 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_aic3x, &aic3x_dai, 1);
-	return ret;
+
+	if (ret != 0)
+		goto err_gpio;
+
+	list_add(&aic3x->list, &reset_list);
+
+	return 0;
 
 err_gpio:
 	if (gpio_is_valid(aic3x->gpio_reset) &&
-- 
1.9.1

