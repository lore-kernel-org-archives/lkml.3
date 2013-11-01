Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3KAMQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:16:13 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:58978
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab3KAMQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:16:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz154dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ASoC: Add pinctrl PM to components of active DAIs
Date: Fri, 1 Nov 2013 20:16:15 +0800
Message-ID: <1383308175-5053-1-git-send-email-b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's quite popular that more drivers are using pinctrl PM, for example:
(Documentation/devicetree/bindings/arm/primecell.txt). Just like what
runtime PM does, it would de-active and en-active pin group depending
on whether it's being used or not.

And this pinctrl PM might be also beneficial to cpu dai drivers because
they might have actual pinctrl so as to sleep their pins and wake them
up as needed.

To achieve this goal, this patch sets pins to the default state during
resume or startup; While during suspend and shutdown, it would set pins
to the sleep state.

As pinctrl PM would return zero if there is no such pinctrl sleep state
settings, this patch would not break current ASoC subsystem directly.

[ However, there is still an exception that the patch can not handle,
that is, when cpu dai driver does not have pinctrl property but another
device has it. (The AUDMUX <-> SSI on Freescale i.MX6 series for example.
SSI as a cpu dai doesn't contain pinctrl property while AUDMUX, an Audio
Multiplexer, has it). In this case, this kind of cpu dai driver needs to
find a way to obtain the pinctrl property as its own, by moving property
from AUDMUX to SSI, or creating a pins link/dependency between these two
devices, or using a more decent way after we figure it out. ]

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
Changelog:
v3:
 * Add pinctrl_pm() for codec_dai/codec
 * Add more proper active check for each pinctrl_pm_select_xx()
v2:
 * Add cpu_dai->active check

 sound/soc/soc-core.c | 33 +++++++++++++++++++++++++++++++++
 sound/soc/soc-pcm.c  | 10 ++++++++++
 2 files changed, 43 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index bdc1d74..4e53d87 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -662,6 +662,8 @@ int snd_soc_suspend(struct device *dev)
 				codec->cache_sync = 1;
 				if (codec->using_regmap)
 					regcache_mark_dirty(codec->control_data);
+				/* deactivate pins to sleep state */
+				pinctrl_pm_select_sleep_state(codec->dev);
 				break;
 			default:
 				dev_dbg(codec->dev,
@@ -679,6 +681,9 @@ int snd_soc_suspend(struct device *dev)
 
 		if (cpu_dai->driver->suspend && cpu_dai->driver->ac97_control)
 			cpu_dai->driver->suspend(cpu_dai);
+
+		/* deactivate pins to sleep state */
+		pinctrl_pm_select_sleep_state(cpu_dai->dev);
 	}
 
 	if (card->suspend_post)
@@ -807,6 +812,16 @@ int snd_soc_resume(struct device *dev)
 	if (list_empty(&card->codec_dev_list))
 		return 0;
 
+	/* activate pins from sleep state */
+	for (i = 0; i < card->num_rtd; i++) {
+		struct snd_soc_dai *cpu_dai = card->rtd[i].cpu_dai;
+		struct snd_soc_dai *codec_dai = card->rtd[i].codec_dai;
+		if (cpu_dai->active)
+			pinctrl_pm_select_default_state(cpu_dai->dev);
+		if (codec_dai->active)
+			pinctrl_pm_select_default_state(codec_dai->dev);
+	}
+
 	/* AC97 devices might have other drivers hanging off them so
 	 * need to resume immediately.  Other drivers don't have that
 	 * problem and may take a substantial amount of time to resume
@@ -1929,6 +1944,14 @@ int snd_soc_poweroff(struct device *dev)
 
 	snd_soc_dapm_shutdown(card);
 
+	/* deactivate pins to sleep state */
+	for (i = 0; i < card->num_rtd; i++) {
+		struct snd_soc_dai *cpu_dai = card->rtd[i].cpu_dai;
+		struct snd_soc_dai *codec_dai = card->rtd[i].codec_dai;
+		pinctrl_pm_select_sleep_state(codec_dai->dev);
+		pinctrl_pm_select_sleep_state(cpu_dai->dev);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_poweroff);
@@ -3767,6 +3790,16 @@ int snd_soc_register_card(struct snd_soc_card *card)
 	if (ret != 0)
 		soc_cleanup_card_debugfs(card);
 
+	/* deactivate pins to sleep state */
+	for (i = 0; i < card->num_rtd; i++) {
+		struct snd_soc_dai *cpu_dai = card->rtd[i].cpu_dai;
+		struct snd_soc_dai *codec_dai = card->rtd[i].codec_dai;
+		if (!codec_dai->active)
+			pinctrl_pm_select_sleep_state(codec_dai->dev);
+		if (!cpu_dai->active)
+			pinctrl_pm_select_sleep_state(cpu_dai->dev);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_register_card);
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index d81b792..1f0aeea 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -183,6 +183,8 @@ static int soc_pcm_open(struct snd_pcm_substream *substream)
 	struct snd_soc_dai_driver *codec_dai_drv = codec_dai->driver;
 	int ret = 0;
 
+	pinctrl_pm_select_default_state(cpu_dai->dev);
+	pinctrl_pm_select_default_state(codec_dai->dev);
 	pm_runtime_get_sync(cpu_dai->dev);
 	pm_runtime_get_sync(codec_dai->dev);
 	pm_runtime_get_sync(platform->dev);
@@ -317,6 +319,10 @@ out:
 	pm_runtime_put(platform->dev);
 	pm_runtime_put(codec_dai->dev);
 	pm_runtime_put(cpu_dai->dev);
+	if (!codec_dai->active)
+		pinctrl_pm_select_sleep_state(codec_dai->dev);
+	if (!cpu_dai->active)
+		pinctrl_pm_select_sleep_state(cpu_dai->dev);
 
 	return ret;
 }
@@ -426,6 +432,10 @@ static int soc_pcm_close(struct snd_pcm_substream *substream)
 	pm_runtime_put(platform->dev);
 	pm_runtime_put(codec_dai->dev);
 	pm_runtime_put(cpu_dai->dev);
+	if (!codec_dai->active)
+		pinctrl_pm_select_sleep_state(codec_dai->dev);
+	if (!cpu_dai->active)
+		pinctrl_pm_select_sleep_state(cpu_dai->dev);
 
 	return 0;
 }
-- 
1.8.4


