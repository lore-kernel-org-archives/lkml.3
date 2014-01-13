Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaAMGvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:51:49 -0500
Received: from [207.46.163.24] ([207.46.163.24]:5230 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaAMGvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:51:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/6] ASoC: core: add snd_soc_get_widgets
Date: Mon, 13 Jan 2014 13:53:54 +0800
Message-ID: <1389592438-13761-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add widgets list getting.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h  |  1 +
 sound/soc/soc-core.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 23f9572..f352333 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -388,6 +388,7 @@ int devm_snd_soc_register_component(struct device *dev,
 void snd_soc_unregister_component(struct device *dev);
 int snd_soc_register_widgets(struct snd_soc_widgets *wdg);
 void snd_soc_unregister_widgets(struct snd_soc_widgets *wdg);
+struct snd_soc_widgets *snd_soc_get_widgets(struct device_node *np);
 int snd_soc_codec_volatile_register(struct snd_soc_codec *codec,
 				    unsigned int reg);
 int snd_soc_codec_readable_register(struct snd_soc_codec *codec,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9adcada..e1d26e6 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3860,6 +3860,37 @@ void snd_soc_unregister_widgets(struct snd_soc_widgets *wdg)
 }
 EXPORT_SYMBOL_GPL(snd_soc_unregister_widgets);
 
+struct snd_soc_widgets *snd_soc_get_widgets(struct device_node *np)
+{
+	struct snd_soc_widgets *wdg;
+	const char *string;
+	int ret;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	if (!of_property_read_bool(np, "sound-widgets"))
+		return NULL;
+
+	ret = of_property_read_string(np, "sound-widgets",
+				      &string);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	mutex_lock(&widgets_mutex);
+	list_for_each_entry(wdg, &widgets_list, list) {
+		if (!strcmp(string, wdg->name)) {
+			mutex_unlock(&widgets_mutex);
+			return wdg;
+		}
+
+	}
+	mutex_unlock(&widgets_mutex);
+
+	return ERR_PTR(-EPROBE_DEFER);
+}
+EXPORT_SYMBOL_GPL(snd_soc_get_widgets);
+
 /*
  * Simplify DAI link configuration by removing ".-1" from device names
  * and sanitizing names.
-- 
1.8.4


