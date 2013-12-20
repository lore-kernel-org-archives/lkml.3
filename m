Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3LTKtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:49:12 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:47531
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932115Ab3LTKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:49:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: Add resource managed devm_snd_soc_register_codec()
Date: Fri, 20 Dec 2013 17:56:47 +0800
Message-ID: <1387533407-15623-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a resource managed version of snd_soc_register_codec() which makes
it possible to simplify the remove function as well as the error path
for codec drivers.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h    |  3 +++
 sound/soc/soc-devres.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 5a049d9..60d6c67 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -378,6 +378,9 @@ int snd_soc_register_codec(struct device *dev,
 		const struct snd_soc_codec_driver *codec_drv,
 		struct snd_soc_dai_driver *dai_drv, int num_dai);
 void snd_soc_unregister_codec(struct device *dev);
+int devm_snd_soc_register_codec(struct device *dev,
+		const struct snd_soc_codec_driver *codec_drv,
+		struct snd_soc_dai_driver *dai_drv, int num_dai);
 int snd_soc_register_component(struct device *dev,
 			 const struct snd_soc_component_driver *cmpnt_drv,
 			 struct snd_soc_dai_driver *dai_drv, int num_dai);
diff --git a/sound/soc/soc-devres.c b/sound/soc/soc-devres.c
index 7ac745d..3c8552f 100644
--- a/sound/soc/soc-devres.c
+++ b/sound/soc/soc-devres.c
@@ -125,3 +125,41 @@ int devm_snd_dmaengine_pcm_register(struct device *dev,
 EXPORT_SYMBOL_GPL(devm_snd_dmaengine_pcm_register);
 
 #endif
+
+static void devm_codec_release(struct device *dev, void *res)
+{
+	snd_soc_unregister_codec(*(struct device **)res);
+}
+
+/**
+ * devm_snd_soc_register_codec - resource managed codec registration
+ * @codec_drv: codec to register
+ * @dai_drv: DAI to register
+ * @num_dai: Number of DAIs
+ *
+ * Register a codec with automatic unregistration when the device is
+ * unregistered.
+ */
+int devm_snd_soc_register_codec(struct device *dev,
+		const struct snd_soc_codec_driver *codec_drv,
+		struct snd_soc_dai_driver *dai_drv,
+		int num_dai)
+{
+	struct device **ptr;
+	int ret;
+
+	ptr = devres_alloc(devm_codec_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	ret = snd_soc_register_codec(dev, codec_drv, dai_drv, num_dai);
+	if (ret == 0) {
+		*ptr = dev;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_snd_soc_register_codec);
-- 
1.8.4


