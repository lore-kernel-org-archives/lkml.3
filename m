Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaJUPeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:34:01 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64128 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaJUPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:33:59 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] ASoC: tegra: Read and use the GPIO flags of the headphone detect
Date: Tue, 21 Oct 2014 17:33:29 +0200
Message-Id: <1413905609-23268-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.1
X-Provags-ID: V02:K0:mETQoF4ULF/3155q88IiKxU4jFVsScLhtxYjf5dDRBT
 8MvsS8IbJdeRbNJE3X9oLKq3myXWxVGy92x5oNQLfCntQVoq/F
 Pta/kVn1au107r8FpdyY8qPpcAGKEOzuRlZt2mMdD6VleYDZjx
 pAAUIiJ3J4/VR3Ae5FB+LBhJw3oaMap/4Vrilqn58HZMYNgVDF
 k1YC6B+hJqMehcZOh+jMq7ZLOhXT/l8GD4nNtGx+ClIfuoirlZ
 6GDtW5ySkYApDhEl4r0eAApOw7kGxywtQCS0M3ufX/E9CsUN7k
 di1G3ro0nfq2+kKJKUSydQ7AGNckOie8lc2ckiu96U99fOXmIe
 lHbyz/KowcfhdzuEpMhgYo67UXC/mHcMY8vyItiYZWBRewQSRh
 V34yNVko/k/W0G9JVeeWfzNTXNYtR3XJRpVe3w9tD1IA90g3a1
 K5jQ4
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headphone detect was hardcoded to low-active, use the flags from
DT to allow high-active as well.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 sound/soc/tegra/tegra_rt5640.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c
index a689883..4ebe387 100644
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -44,6 +44,7 @@
 struct tegra_rt5640 {
 	struct tegra_asoc_utils_data util_data;
 	int gpio_hp_det;
+	enum of_gpio_flags gpio_hp_det_flags;
 };
 
 static int tegra_rt5640_asoc_hw_params(struct snd_pcm_substream *substream,
@@ -119,6 +120,8 @@ static int tegra_rt5640_asoc_init(struct snd_soc_pcm_runtime *rtd)
 
 	if (gpio_is_valid(machine->gpio_hp_det)) {
 		tegra_rt5640_hp_jack_gpio.gpio = machine->gpio_hp_det;
+		tegra_rt5640_hp_jack_gpio.invert =
+			!!(machine->gpio_hp_det_flags & OF_GPIO_ACTIVE_LOW);
 		snd_soc_jack_add_gpios(&tegra_rt5640_hp_jack,
 						1,
 						&tegra_rt5640_hp_jack_gpio);
@@ -180,7 +183,8 @@ static int tegra_rt5640_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, card);
 	snd_soc_card_set_drvdata(card, machine);
 
-	machine->gpio_hp_det = of_get_named_gpio(np, "nvidia,hp-det-gpios", 0);
+	machine->gpio_hp_det = of_get_named_gpio_flags(
+		np, "nvidia,hp-det-gpios", 0, &machine->gpio_hp_det_flags);
 	if (machine->gpio_hp_det == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
-- 
2.1.1

