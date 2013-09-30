Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3I3KOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:14:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3I3KNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 101/104] ASoC: mc13783: add spi errata fix
Date: Mon, 30 Sep 2013 11:11:18 +0100
Message-Id: <1380535881-9239-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

commit 9f6f0afbb9fdabf6dcac642dfec457f28981e3f8 upstream.

The MC13783 Chip Errata, Rev. 4 says, that depending on SPI clock
and main audio clock speed, the Audio Codec or Stereo DAC do sometimes
not start when programmed to do so. This is due to an internal clock
timing issue related to the loading of the SPI bits into the audio block.

On an i.MX27 based system, this issue lead to switched audio channels under
certain circumstances: RTC + Touch + Audio are used and loaded at startup.

The mentioned workaround of writing registers 40 and 41 two times is implemented
here.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/mc13783.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index 6276e35..3086194 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -126,6 +126,10 @@ static int mc13783_write(struct snd_soc_codec *codec,
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
 
+	/* include errata fix for spi audio problems */
+	if (reg == MC13783_AUDIO_CODEC || reg == MC13783_AUDIO_DAC)
+		ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
+
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
-- 
1.8.3.2

