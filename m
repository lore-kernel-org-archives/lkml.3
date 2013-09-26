Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3IZP3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:29:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab3IZP3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:29:44 -0400
Date: Thu, 26 Sep 2013 16:29:41 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: devicetree@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mfd: arizona: Update device tree regulator bindings
Message-ID: <20130926152941.GQ3635@opensource.wolfsonmicro.com>
References: <1380131272-16982-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20130925183201.GT3226@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925183201.GT3226@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

What are your thoughts on this approach? I basically add a way to
specify in the DAPM regulator supply widget that the supply lives
on the parent rather than the current device. If you like it I
will send it in as a proper patch.

I had considered adding something like a recursive regulator get
that works it's way up the tree but this felt rather invasive and
most places the user code does the regulator get rather than a
framework so the issue is only really likely to crop up with
regards to ASoC.

Thanks,
Charles
---
 include/sound/soc-dapm.h  |    2 ++
 sound/soc/codecs/wm5102.c |   13 +++++++------
 sound/soc/soc-dapm.c      |    7 ++++++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 27a72d5..f21b261 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -360,6 +360,8 @@ struct device;
 
 /* regulator widget flags */
 #define SND_SOC_DAPM_REGULATOR_BYPASS     0x1     /* bypass when disabled */
+/* use codec parent device for regulator get */
+#define SND_SOC_DAPM_REGULATOR_USE_PARENT 0x2
 
 struct snd_soc_dapm_widget;
 enum snd_soc_dapm_type;
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 8bbddc1..ee31f15 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -980,12 +980,13 @@ SND_SOC_DAPM_SUPPLY("OPCLK", ARIZONA_OUTPUT_SYSTEM_CLOCK,
 SND_SOC_DAPM_SUPPLY("ASYNCOPCLK", ARIZONA_OUTPUT_ASYNC_CLOCK,
 		    ARIZONA_OPCLK_ASYNC_ENA_SHIFT, 0, NULL, 0),
 
-SND_SOC_DAPM_REGULATOR_SUPPLY("DBVDD2", 0, 0),
-SND_SOC_DAPM_REGULATOR_SUPPLY("DBVDD3", 0, 0),
-SND_SOC_DAPM_REGULATOR_SUPPLY("CPVDD", 20, 0),
-SND_SOC_DAPM_REGULATOR_SUPPLY("MICVDD", 0, SND_SOC_DAPM_REGULATOR_BYPASS),
-SND_SOC_DAPM_REGULATOR_SUPPLY("SPKVDDL", 0, 0),
-SND_SOC_DAPM_REGULATOR_SUPPLY("SPKVDDR", 0, 0),
+SND_SOC_DAPM_REGULATOR_SUPPLY("DBVDD2", 0, SND_SOC_DAPM_REGULATOR_USE_PARENT),
+SND_SOC_DAPM_REGULATOR_SUPPLY("DBVDD3", 0, SND_SOC_DAPM_REGULATOR_USE_PARENT),
+SND_SOC_DAPM_REGULATOR_SUPPLY("CPVDD", 20, SND_SOC_DAPM_REGULATOR_USE_PARENT),
+SND_SOC_DAPM_REGULATOR_SUPPLY("MICVDD", 0, SND_SOC_DAPM_REGULATOR_BYPASS |
+					   SND_SOC_DAPM_REGULATOR_USE_PARENT),
+SND_SOC_DAPM_REGULATOR_SUPPLY("SPKVDDL", 0, SND_SOC_DAPM_REGULATOR_USE_PARENT),
+SND_SOC_DAPM_REGULATOR_SUPPLY("SPKVDDR", 0, SND_SOC_DAPM_REGULATOR_USE_PARENT),
 
 SND_SOC_DAPM_SIGGEN("TONE"),
 SND_SOC_DAPM_SIGGEN("NOISE"),
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c17c14c..899bd2e 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3181,7 +3181,12 @@ snd_soc_dapm_new_control(struct snd_soc_dapm_context *dapm,
 
 	switch (w->id) {
 	case snd_soc_dapm_regulator_supply:
-		w->regulator = devm_regulator_get(dapm->dev, w->name);
+		if (w->on_val & SND_SOC_DAPM_REGULATOR_USE_PARENT)
+			w->regulator = devm_regulator_get(dapm->dev->parent,
+							  w->name);
+		else
+			w->regulator = devm_regulator_get(dapm->dev, w->name);
+
 		if (IS_ERR(w->regulator)) {
 			ret = PTR_ERR(w->regulator);
 			dev_err(dapm->dev, "ASoC: Failed to request %s: %d\n",
-- 
1.7.2.5

