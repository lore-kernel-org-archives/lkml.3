Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3ITULw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:11:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3ITULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:11:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 87/93] ASoC: mc13783: add spi errata fix
Date: Fri, 20 Sep 2013 13:09:22 -0700
Message-Id: <1379707768-1804-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/mc13783.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index 5402dfb..8a8d936 100644
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
1.8.1.2

