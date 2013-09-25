Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab3IYAkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:40:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab3IYAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mark Brown <broonie@linaro.org>
Subject: [ 050/117] ASoC: mc13783: add spi errata fix
Date: Tue, 24 Sep 2013 17:18:36 -0700
Message-Id: <20130925001746.307865676@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/mc13783.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -126,6 +126,10 @@ static int mc13783_write(struct snd_soc_
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
 
+	/* include errata fix for spi audio problems */
+	if (reg == MC13783_AUDIO_CODEC || reg == MC13783_AUDIO_DAC)
+		ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
+
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;


