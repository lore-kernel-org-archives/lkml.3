Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaD1OIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:08:02 -0400
Received: from ring0.de ([5.45.105.125]:51960 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbaD1OH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:07:57 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
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
Subject: [PATCHv2 5/9] ASoC: omap: rx51: omap_mcbsp_st_add_controls: add id parameter
Date: Mon, 28 Apr 2014 16:07:23 +0200
Message-Id: <1398694047-28596-6-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for DT based booting where the McBSP id
is set to -1 for all McBSP instances.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/omap-mcbsp.c | 5 +++--
 sound/soc/omap/omap-mcbsp.h | 2 +-
 sound/soc/omap/rx51.c       | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index af2764a..71d2266 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -693,7 +693,7 @@ OMAP_MCBSP_SOC_SINGLE_S16_EXT("McBSP" #port " Sidetone Channel 1 Volume", \
 OMAP_MCBSP_ST_CONTROLS(2);
 OMAP_MCBSP_ST_CONTROLS(3);
 
-int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd)
+int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd, int port_id)
 {
 	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
 	struct omap_mcbsp *mcbsp = snd_soc_dai_get_drvdata(cpu_dai);
@@ -703,7 +703,7 @@ int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd)
 		return 0;
 	}
 
-	switch (mcbsp->id) {
+	switch (port_id) {
 	case 2: /* McBSP 2 */
 		return snd_soc_add_dai_controls(cpu_dai,
 					omap_mcbsp2_st_controls,
@@ -713,6 +713,7 @@ int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd)
 					omap_mcbsp3_st_controls,
 					ARRAY_SIZE(omap_mcbsp3_st_controls));
 	default:
+		dev_err(mcbsp->dev, "Port %d not supported\n", port_id);
 		break;
 	}
 
diff --git a/sound/soc/omap/omap-mcbsp.h b/sound/soc/omap/omap-mcbsp.h
index ba8386a..2e3369c 100644
--- a/sound/soc/omap/omap-mcbsp.h
+++ b/sound/soc/omap/omap-mcbsp.h
@@ -39,6 +39,6 @@ enum omap_mcbsp_div {
 	OMAP_MCBSP_CLKGDV,		/* Sample rate generator divider */
 };
 
-int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd);
+int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd, int port_id);
 
 #endif
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index bbe3a66..e140b1b 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -297,7 +297,7 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 		return err;
 	snd_soc_limit_volume(codec, "TPA6130A2 Headphone Playback Volume", 42);
 
-	err = omap_mcbsp_st_add_controls(rtd);
+	err = omap_mcbsp_st_add_controls(rtd, 2);
 	if (err < 0)
 		return err;
 
-- 
1.9.2

