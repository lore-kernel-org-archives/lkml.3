Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3GAIlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:41:15 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47622 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3GAIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:21 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 12/13] sound: wm8731: rework power management
Date: Mon,  1 Jul 2013 10:39:37 +0200
Message-Id: <1372667978-4718-13-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

- preserve crystal oscillator across suspend/resume sequence:
  enabled by default,it should be kept enabled on resume.
- if codec is in active state: set the active bit at resume time.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 sound/soc/codecs/wm8731.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 5276062..3cf6b20 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -465,7 +465,9 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
 		snd_soc_write(codec, WM8731_PWR, reg | 0x0040);
 		break;
 	case SND_SOC_BIAS_OFF:
-		snd_soc_write(codec, WM8731_PWR, 0xffff);
+		snd_soc_write(codec, WM8731_ACTIVE, 0x0);
+		/* standby: keep crystal oscillator enabled */
+		snd_soc_write(codec, WM8731_PWR, 0x00df);
 		regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies),
 				       wm8731->supplies);
 		regcache_mark_dirty(wm8731->regmap);
@@ -516,6 +518,8 @@ static int wm8731_suspend(struct snd_soc_codec *codec)
 static int wm8731_resume(struct snd_soc_codec *codec)
 {
 	wm8731_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+	if (codec->active)
+		snd_soc_write(codec, WM8731_ACTIVE, 0x0001);
 
 	return 0;
 }
-- 
1.7.10.4

