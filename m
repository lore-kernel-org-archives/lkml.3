Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3LSPzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:55:33 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:54762 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3LSPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 02/11] ASoC: ab8500: Revert back to find_next_bit()
Date: Thu, 19 Dec 2013 15:54:59 +0000
Message-Id: <1387468508-12286-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit '166a34d ASoC: ab8500: Fix invalid cast to long pointer'
rather carelessly converts find_next_bit() to fls() (find last
bit set), which are not the same.

Although this implementation may not be portable, the alternative
breaks audio on anything using the AB8500 CODEC, which is a much
greater evil. Besides, this driver will never run on anything
else.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 1ad92cb..51ae3e9 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2322,7 +2322,7 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 		slot = ffs(tx_mask);
 		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, slot);
 		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, slot);
-		slot = fls(tx_mask);
+		slot = find_next_bit((unsigned long *)&tx_mask, 32, slot + 1);
 		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, slot);
 		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, slot);
 		break;
@@ -2364,7 +2364,7 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 				AB8500_ADSLOTSEL(slot),
 				AB8500_MASK_SLOT(slot),
 				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT3, slot));
-		slot = fls(rx_mask);
+		slot = find_next_bit((unsigned long *)&rx_mask, 32, slot + 1);
 		snd_soc_update_bits(codec,
 				AB8500_ADSLOTSEL(slot),
 				AB8500_MASK_SLOT(slot),
-- 
1.8.3.2

