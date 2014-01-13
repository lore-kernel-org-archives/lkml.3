Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaAMGvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:51:45 -0500
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:26204
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbaAMGvP (ORCPT
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
Subject: [PATCHv2 1/6] ASoC: core: add off-CODEC widgets list register/unregister
Date: Mon, 13 Jan 2014 13:53:53 +0800
Message-ID: <1389592438-13761-2-git-send-email-Li.Xiubo@freescale.com>
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

This will be need for some audio card, which maybe using the simple
card and the off-CODEC widgets is needed.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h  | 10 ++++++++++
 sound/soc/soc-core.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 03ce45b..23f9572 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -326,6 +326,7 @@ struct snd_soc_platform_driver;
 struct snd_soc_codec;
 struct snd_soc_codec_driver;
 struct snd_soc_component;
+struct snd_soc_widgets;
 struct snd_soc_component_driver;
 struct soc_enum;
 struct snd_soc_jack;
@@ -385,6 +386,8 @@ int devm_snd_soc_register_component(struct device *dev,
 			 const struct snd_soc_component_driver *cmpnt_drv,
 			 struct snd_soc_dai_driver *dai_drv, int num_dai);
 void snd_soc_unregister_component(struct device *dev);
+int snd_soc_register_widgets(struct snd_soc_widgets *wdg);
+void snd_soc_unregister_widgets(struct snd_soc_widgets *wdg);
 int snd_soc_codec_volatile_register(struct snd_soc_codec *codec,
 				    unsigned int reg);
 int snd_soc_codec_readable_register(struct snd_soc_codec *codec,
@@ -664,6 +667,13 @@ struct snd_soc_component {
 	const struct snd_soc_component_driver *driver;
 };
 
+struct snd_soc_widgets {
+	const char *name;
+	struct list_head list;
+	const struct snd_soc_dapm_widget *widgets;
+	unsigned int cnt;
+};
+
 /* SoC Audio Codec device */
 struct snd_soc_codec {
 	const char *name;
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 3a128f0..9adcada 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3821,6 +3821,45 @@ int snd_soc_unregister_card(struct snd_soc_card *card)
 }
 EXPORT_SYMBOL_GPL(snd_soc_unregister_card);
 
+static DEFINE_MUTEX(widgets_mutex);
+static LIST_HEAD(widgets_list);
+/**
+ * snd_soc_register_widgets - Register off codec widgets with
+ * the ASoC core
+ *
+ * @wdg: widgets to register
+ *
+ */
+int snd_soc_register_widgets(struct snd_soc_widgets *wdg)
+{
+	int ret;
+
+	if (!wdg)
+		return -EINVAL;
+
+	mutex_lock(&widgets_mutex);
+	list_add(&wdg->list, &widgets_list);
+	mutex_unlock(&widgets_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snd_soc_register_widgets);
+
+/**
+ * snd_soc_unregister_widgets - Unregister off codec widgets with
+ * the ASoC core
+ *
+ * @wdg: widgets to unregister
+ *
+ */
+void snd_soc_unregister_widgets(struct snd_soc_widgets *wdg)
+{
+	mutex_lock(&widgets_mutex);
+	list_del(&wdg->list);
+	mutex_unlock(&widgets_mutex);
+}
+EXPORT_SYMBOL_GPL(snd_soc_unregister_widgets);
+
 /*
  * Simplify DAI link configuration by removing ".-1" from device names
  * and sanitizing names.
-- 
1.8.4


