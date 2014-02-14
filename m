Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaBNCic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:38:32 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:22479
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbaBNCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:38:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <b47053@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH v3 2/3] ASoC: core: add TDM slot parsing from DT supports
Date: Fri, 14 Feb 2014 09:34:35 +0800
Message-ID: <1392341676-4143-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some CPU/CODEC DAI devices the TDM slot infomation maybe needed. This
patch adds the slot parsing from DT supports.

TDM slot properties:
    dai-tdm-slot-num : Number of slots in use.
    dai-tdm-slot-width :  Width in bits for each slot.

For instance:
    dai-tdm-slot-num = <2>;
    dai-tdm-slot-width = <8>;

And for each spcified driver, there could be one .of_xlate_tdm_slot_mask()
to specify a explicit mapping of the channels and the slots. If it's absent
the default snd_soc_of_xlate_tdm_slot_mask() will be used to generating the
tx and rx masks.

For snd_soc_of_xlate_tdm_slot_mask(), the tx and rx masks will use a 1 bit
for an active slot as default, and the default active bits are at the LSB of
the masks.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@linaro.org>
---
 include/sound/soc-dai.h |  2 ++
 include/sound/soc.h     |  3 +++
 sound/soc/soc-core.c    | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/sound/soc-dai.h b/include/sound/soc-dai.h
index 71f27c4..d86e0fc 100644
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -142,6 +142,8 @@ struct snd_soc_dai_ops {
 	 * Called by soc_card drivers, normally in their hw_params.
 	 */
 	int (*set_fmt)(struct snd_soc_dai *dai, unsigned int fmt);
+	int (*of_xlate_tdm_slot_mask)(unsigned int slots,
+		unsigned int *tx_mask, unsigned int *rx_mask);
 	int (*set_tdm_slot)(struct snd_soc_dai *dai,
 		unsigned int tx_mask, unsigned int rx_mask,
 		int slots, int slot_width);
diff --git a/include/sound/soc.h b/include/sound/soc.h
index 21d025e..759db05 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1190,6 +1190,9 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname);
 int snd_soc_of_parse_audio_simple_widgets(struct snd_soc_card *card,
 					  const char *propname);
+int snd_soc_of_parse_tdm_slot(struct device_node *np,
+			      unsigned int *slots,
+			      unsigned int *slot_width);
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index abee5f4..bc3d090 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3663,6 +3663,30 @@ int snd_soc_dai_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 EXPORT_SYMBOL_GPL(snd_soc_dai_set_fmt);
 
 /**
+ * snd_soc_of_xlate_tdm_slot - generate tx/rx slot mask.
+ * @slots: Number of slots in use.
+ * @tx_mask: bitmask representing active TX slots.
+ * @rx_mask: bitmask representing active RX slots.
+ *
+ * Generates the TDM tx and rx slot default masks for DAI.
+ */
+static int snd_soc_of_xlate_tdm_slot_mask(unsigned int slots,
+					  unsigned int *tx_mask,
+					  unsigned int *rx_mask)
+{
+	if (*tx_mask || *rx_mask)
+		return 0;
+
+	if (!slots)
+		return -EINVAL;
+
+	*tx_mask = (1 << slots) - 1;
+	*rx_mask = (1 << slots) - 1;
+
+	return 0;
+}
+
+/**
  * snd_soc_dai_set_tdm_slot - configure DAI TDM.
  * @dai: DAI
  * @tx_mask: bitmask representing active TX slots.
@@ -3676,6 +3700,12 @@ EXPORT_SYMBOL_GPL(snd_soc_dai_set_fmt);
 int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 	unsigned int tx_mask, unsigned int rx_mask, int slots, int slot_width)
 {
+	if (dai->driver && dai->driver->ops->of_xlate_tdm_slot_mask)
+		dai->driver->ops->of_xlate_tdm_slot_mask(slots,
+						&tx_mask, &rx_mask);
+	else
+		snd_soc_of_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+
 	if (dai->driver && dai->driver->ops->set_tdm_slot)
 		return dai->driver->ops->set_tdm_slot(dai, tx_mask, rx_mask,
 				slots, slot_width);
@@ -4558,6 +4588,35 @@ int snd_soc_of_parse_audio_simple_widgets(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_simple_widgets);
 
+int snd_soc_of_parse_tdm_slot(struct device_node *np,
+			      unsigned int *slots,
+			      unsigned int *slot_width)
+{
+	u32 val;
+	int ret;
+
+	if (of_property_read_bool(np, "dai-tdm-slot-num")) {
+		ret = of_property_read_u32(np, "dai-tdm-slot-num", &val);
+		if (ret)
+			return ret;
+
+		if (slots)
+			*slots = val;
+	}
+
+	if (of_property_read_bool(np, "dai-tdm-slot-width")) {
+		ret = of_property_read_u32(np, "dai-tdm-slot-width", &val);
+		if (ret)
+			return ret;
+
+		if (slot_width)
+			*slot_width = val;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_parse_tdm_slot);
+
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname)
 {
-- 
1.8.4


