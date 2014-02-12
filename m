Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBLIsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:48:51 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:2778 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaBLIss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:48:48 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <tiwai@suse.de>, <perex@perex.cz>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 2/3] ASoC: core: add slot information parsing supports
Date: Wed, 12 Feb 2014 15:45:11 +0800
Message-ID: <1392191112-27028-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some CPU/CODEC DAI devices the slot infomation maybe needed. This
patch adds the slot parsing from DT supports.

The style of the slot information in DT should be:
	<tx_mask, rx_mask, slots, slot_width>

For instance:
	simple-slot-info = <0xffffffc 0xffffffc 2 0>;

Please refer to tdm-slot.txt for more detail.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h  | 10 ++++++++++
 sound/soc/soc-core.c | 23 +++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 21d025e..1aa85d0 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1110,6 +1110,13 @@ struct soc_enum {
 	const unsigned int *values;
 };
 
+struct soc_slot_info {
+	unsigned int tx_mask;
+	unsigned int rx_mask;
+	int slots;
+	int slot_width;
+};
+
 /* codec IO */
 unsigned int snd_soc_read(struct snd_soc_codec *codec, unsigned int reg);
 unsigned int snd_soc_write(struct snd_soc_codec *codec,
@@ -1190,6 +1197,9 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname);
 int snd_soc_of_parse_audio_simple_widgets(struct snd_soc_card *card,
 					  const char *propname);
+int snd_soc_of_parse_slot_info(struct device_node *np,
+			      struct soc_slot_info *info,
+			      const char *propname);
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index abee5f4..3ad4b88 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4558,6 +4558,29 @@ int snd_soc_of_parse_audio_simple_widgets(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_simple_widgets);
 
+int snd_soc_of_parse_slot_info(struct device_node *np,
+			       struct soc_slot_info *info,
+			       const char *propname)
+{
+	u32 out_value[4];
+	int ret;
+
+	if (!info)
+		return -EINVAL;
+
+	ret = of_property_read_u32_array(np, propname, out_value, 4);
+	if (ret)
+		return ret;
+
+	info->tx_mask = out_value[0];
+	info->rx_mask = out_value[1];
+	info->slots = out_value[2];
+	info->slot_width = out_value[3];
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_parse_slot_info);
+
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname)
 {
-- 
1.8.4


