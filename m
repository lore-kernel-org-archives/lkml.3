Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaBZFJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:09:31 -0500
Received: from [216.32.180.30] ([216.32.180.30]:10580 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbaBZFJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:09:28 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <timur@tabi.org>, <tiwai@suse.de>, <lars@metafoo.de>,
        <Guangyu.Chen@freescale.com>, <fabio.estevam@freescale.com>,
        <shawn.guo@linaro.org>, <denis@eukrea.com>, <mpa@pengutronix.de>,
        <s.hauer@pengutronix.de>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 02/10] ASoC: fsl-utils: Add fsl_asoc_of_xlate_tdm_slot_mask() support.
Date: Wed, 26 Feb 2014 11:59:27 +0800
Message-ID: <1393387175-15539-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add fsl_asoc_of_xlate_tdm_slot_mask() support for utils.
For the some spcified DAI driver, this will be used to generate the
TDM slot TX/RX mask. And the TX/RX mask will use a 0 bit for an active
slot as default, and the default active bits are at the LSB of
the masks.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_utils.c | 27 +++++++++++++++++++++++++++
 sound/soc/fsl/fsl_utils.h |  4 +++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_utils.c b/sound/soc/fsl/fsl_utils.c
index b9e42b5..b536eb1 100644
--- a/sound/soc/fsl/fsl_utils.c
+++ b/sound/soc/fsl/fsl_utils.c
@@ -86,6 +86,33 @@ int fsl_asoc_get_dma_channel(struct device_node *ssi_np,
 }
 EXPORT_SYMBOL(fsl_asoc_get_dma_channel);
 
+/**
+ * fsl_asoc_of_xlate_tdm_slot_mask - generate TDM slot TX/RX mask.
+ *
+ * @slots: Number of slots in use.
+ * @tx_mask: bitmask representing active TX slots.
+ * @rx_mask: bitmask representing active RX slots.
+ *
+ * This function used to generate the TDM slot TX/RX mask. And the TX/RX
+ * mask will use a 0 bit for an active slot as default, and the default
+ * active bits are at the LSB of the mask value.
+ */
+int fsl_asoc_of_xlate_tdm_slot_mask(unsigned int slots,
+				    unsigned int *tx_mask,
+				    unsigned int *rx_mask)
+{
+	if (!slots)
+		return -EINVAL;
+
+	if (tx_mask)
+		*tx_mask = ~((1 << slots) - 1);
+	if (rx_mask)
+		*rx_mask = ~((1 << slots) - 1);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsl_asoc_of_xlate_tdm_slot_mask);
+
 MODULE_AUTHOR("Timur Tabi <timur@freescale.com>");
 MODULE_DESCRIPTION("Freescale ASoC utility code");
 MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/fsl/fsl_utils.h b/sound/soc/fsl/fsl_utils.h
index b295112..01b01f9 100644
--- a/sound/soc/fsl/fsl_utils.h
+++ b/sound/soc/fsl/fsl_utils.h
@@ -22,5 +22,7 @@ int fsl_asoc_get_dma_channel(struct device_node *ssi_np, const char *name,
 			     struct snd_soc_dai_link *dai,
 			     unsigned int *dma_channel_id,
 			     unsigned int *dma_id);
-
+int fsl_asoc_of_xlate_tdm_slot_mask(unsigned int slots,
+				    unsigned int *tx_mask,
+				    unsigned int *rx_mask);
 #endif /* _FSL_UTILS_H */
-- 
1.8.4


