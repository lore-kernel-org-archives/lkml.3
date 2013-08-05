Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3HEIVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:21:33 -0400
Received: from skyrme.org ([193.175.80.135]:54526 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab3HEIVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:21:24 -0400
X-Greylist: delayed 2717 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 04:21:24 EDT
Date: 5 Aug 2013 07:36:02 +0000
Message-Id: <1375688163-1935-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Fabio Estevam" <fabio.estevam@freescale.com>
Cc: alsa-devel@alsa-project.org, "Mark Brown" <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        "Zeng Zhaoming" <zengzm.kernel@gmail.com>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] sound/sgtl5000: fix codec clock source transition to avoid clockless moment
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powering down PLL before switching to a mode that does not use it
is a bad idea. It would cause the SGTL5000 be without internal
clock supply, especially on the I2C interface, which would make
subsequent access to it fail.

Thus, in case of not using PLL any longer, first set the mode
control, then power down PLL.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 sound/soc/codecs/sgtl5000.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 6c8a9e7..8ecb201 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -644,16 +644,19 @@ static int sgtl5000_set_clock(struct snd_soc_codec *codec, int frame_rate)
 		snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
 			SGTL5000_PLL_POWERUP | SGTL5000_VCOAMP_POWERUP,
 			SGTL5000_PLL_POWERUP | SGTL5000_VCOAMP_POWERUP);
+
+		/* if using pll, clk_ctrl must be set after pll power up */
+		snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL, clk_ctl);
 	} else {
+		/* otherwise, clk_ctrl must be set before pll power down */
+		snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL, clk_ctl);
+
 		/* power down pll */
 		snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
 			SGTL5000_PLL_POWERUP | SGTL5000_VCOAMP_POWERUP,
 			0);
 	}
 
-	/* if using pll, clk_ctrl must be set after pll power up */
-	snd_soc_write(codec, SGTL5000_CHIP_CLK_CTRL, clk_ctl);
-
 	return 0;
 }
 
-- 
1.7.9.5

