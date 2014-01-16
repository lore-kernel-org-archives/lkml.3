Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaAPJIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:08:02 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49993
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbaAPJHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:07:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lars@metafoo.de>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: core: Fix possible NULL pointer dereference of pcm->config
Date: Thu, 16 Jan 2014 16:08:04 +0800
Message-ID: <1389859684-27456-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the soc generic dmaengine pcm driver allows using the defualt settings,
so the pcm->config maybe NULL.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 560a778..5bace12 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -176,17 +176,20 @@ static struct dma_chan *dmaengine_pcm_compat_request_channel(
 {
 	struct dmaengine_pcm *pcm = soc_platform_to_pcm(rtd->platform);
 	struct snd_dmaengine_dai_dma_data *dma_data;
+	dma_filter_fn fn = NULL;
 
 	dma_data = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
 
 	if ((pcm->flags & SND_DMAENGINE_PCM_FLAG_HALF_DUPLEX) && pcm->chan[0])
 		return pcm->chan[0];
 
-	if (pcm->config->compat_request_channel)
+	if (pcm->config && pcm->config->compat_request_channel)
 		return pcm->config->compat_request_channel(rtd, substream);
 
-	return snd_dmaengine_pcm_request_channel(pcm->config->compat_filter_fn,
-						 dma_data->filter_data);
+	if (pcm->config)
+		fn = pcm->config->compat_filter_fn;
+
+	return snd_dmaengine_pcm_request_channel(fn, dma_data->filter_data);
 }
 
 static bool dmaengine_pcm_can_report_residue(struct dma_chan *chan)
-- 
1.8.4


