Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaFXPzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:55:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaFXPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 49/68] ASoC: dapm: Make sure to always update the DAPM graph in _put_volsw()
Date: Tue, 24 Jun 2014 11:51:08 -0400
Message-Id: <20140624154726.150577939@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit c9e065c27fe9b81e5d6e7681d77a24f7b9616675 upstream.

When using auto-muted controls it may happen that the register value will not
change when changing a control from enabled to disabled (since the control might
be physically disabled due to the auto-muting). We have to make sure to still
update the DAPM graph and disconnect the mixer input.

Fixes: commit 5729507 ("ASoC: dapm: Implement mixer input auto-disable")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2888,22 +2888,19 @@ int snd_soc_dapm_put_volsw(struct snd_kc
 	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
 
 	change = dapm_kcontrol_set_value(kcontrol, val);
-
-	if (reg != SND_SOC_NOPM) {
-		mask = mask << shift;
-		val = val << shift;
-
-		change = snd_soc_test_bits(codec, reg, mask, val);
-	}
-
 	if (change) {
 		if (reg != SND_SOC_NOPM) {
-			update.kcontrol = kcontrol;
-			update.reg = reg;
-			update.mask = mask;
-			update.val = val;
+			mask = mask << shift;
+			val = val << shift;
+
+			if (snd_soc_test_bits(codec, reg, mask, val)) {
+				update.kcontrol = kcontrol;
+				update.reg = reg;
+				update.mask = mask;
+				update.val = val;
+				card->update = &update;
+			}
 
-			card->update = &update;
 		}
 
 		ret = soc_dapm_mixer_update_power(card, kcontrol, connect);


