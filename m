Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaAWGCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:02:19 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:14841
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaAWGCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:02:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <shawn.guo@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>
CC: <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH Resend 7/8] ASoC: add snd_soc_of_parse_audio_simple_widgets for DeviceTree
Date: Thu, 23 Jan 2014 13:02:49 +0800
Message-ID: <1390453370-29194-8-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds snd_soc_of_parse_audio_simple_widgets() and supports
below style of widgets name on DT.

"wname-prefix[ individual name]"
"wname-prefix" includes: "Mic", "Line", "Hp", "Spk"...

For instance:
	simple-audio-widgets =
		"Mic Jack", "Line In Jack",
		"Hp Jack", "Spk Ext",
		"Line Out Jack";

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

Add :
                  widgets[i].name = wname;

And this will use the widget name from DT node.




 include/sound/soc.h  |  2 ++
 sound/soc/soc-core.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 9a00147..465dc6e 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1173,6 +1173,8 @@ void snd_soc_util_exit(void);
 
 int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname);
+int snd_soc_of_parse_audio_simple_widgets(struct snd_soc_card *card,
+					  const char *propname);
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 393ff06..9c8a686 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4417,6 +4417,69 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_card_name);
 
+static struct snd_soc_dapm_widget simple_widgets[] = {
+	SND_SOC_DAPM_MIC("Mic", NULL),
+	SND_SOC_DAPM_LINE("Line", NULL),
+	SND_SOC_DAPM_HP("Hp", NULL),
+	SND_SOC_DAPM_SPK("Spk", NULL),
+};
+
+int snd_soc_of_parse_audio_simple_widgets(struct snd_soc_card *card,
+					  const char *propname)
+{
+	struct device_node *np = card->dev->of_node;
+	struct snd_soc_dapm_widget *widgets;
+	const char *wname;
+	int i, j, cnt, ret;
+
+	cnt = of_property_count_strings(np, propname);
+	if (cnt <= 0) {
+		dev_err(card->dev,
+			"ASoC: Property '%s' does not exist or "
+			"length is zero\n", propname);
+		return -EINVAL;
+	}
+
+	widgets = devm_kcalloc(card->dev, cnt, sizeof(*widgets), GFP_KERNEL);
+	if (!widgets) {
+		dev_err(card->dev,
+			"ASoC: Could not allocate DAPM widgets table\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < cnt; i++) {
+		ret = of_property_read_string_index(np, propname, i, &wname);
+		if (ret) {
+			dev_err(card->dev,
+				"ASoC: Property '%s' index %d could not be "
+				"read: %d\n", propname, i, ret);
+			return -EINVAL;
+		}
+
+		for (j = 0; j < ARRAY_SIZE(simple_widgets); j++) {
+			if (!strncmp(wname, simple_widgets[j].name,
+				     strlen(simple_widgets[j].name))) {
+				widgets[i] = simple_widgets[j];
+				widgets[i].name = wname;
+				break;
+			}
+		}
+
+		if (j >= ARRAY_SIZE(simple_widgets)) {
+			dev_err(card->dev,
+				"ASoC: DAPM widget : '%s' is not supported\n",
+				wname);
+			return -EINVAL;
+		}
+	}
+
+	card->dapm_widgets = widgets;
+	card->num_dapm_widgets = cnt;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_simple_widgets);
+
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname)
 {
-- 
1.8.4


