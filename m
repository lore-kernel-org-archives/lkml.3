Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3LBKNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:13:07 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39736 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3LBKNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:13:02 -0500
Date: Mon, 2 Dec 2013 10:12:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinusW <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [alsa-devel] [PATCH 07/10] ASoC: ux500: Store DMA data in the
 DAI differently in the pdata and DT case
Message-ID: <20131202101256.GA29373@lee--X1>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
 <CAOesGMiu16f_L=cMWFCNZMjNB9tBK-2LXn02k-R7FhkkgR5-+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMiu16f_L=cMWFCNZMjNB9tBK-2LXn02k-R7FhkkgR5-+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Dec 2013, Olof Johansson wrote:

> Hi,
> 
> On Tue, Nov 19, 2013 at 3:07 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > In this patch we do two things. Firstly, instead of open coding the
> > store of DMA data in to the DAI for later use, we use the API provided.
> > Secondly we create and store similar DMA data for the DT case, only
> > this time we use 'struct snd_dmaengine_dai_dma_data' which is provided
> > by the core for this very reason.
> >
> > Cc: alsa-devel@alsa-project.org
> > Cc: Mark Brown <broonie@kernel.org>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> 
> Seems like this hit -next for the first time today, and it panics
> snowball on boot of u8500_defconfig. I bisected down to this patch.
> 
> The panic is below. Last output is the dev_dbg() in
> ux500_pcm_request_chan. dma_cfg seems to be 0x0000004(!) at that
> point. It's indeed crashing on first deref of dma_cfg (confirmed via
> addr2line).

Okay, I just debugged this.

It's actually my fault. I had two patches round the wrong way in the
series. The imediately subsequent patch in the set fixes this issue:

Author: Lee Jones <lee.jones@linaro.org>
Date:   Tue Nov 5 22:57:31 2013 +0000

    ASoC: ux500_pcm: Differentiate between pdata and DT initialisation
    
    If booting with full DT support (i.e. DMA too, the last piece of the
    puzzle), then we don't need to use the compatible request channel call
    back and, due to the work we laid down earlier in this patch-set, we
    can use core function calls to populate the DMA slave_config. We also
    require slightly different flags to inform the core that we 'are'
    booting with DT.
    
    Cc: alsa-devel@alsa-project.org
    Cc: Mark Brown <broonie@kernel.org>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index ce554de..acfec98 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -139,15 +139,33 @@ static const struct snd_dmaengine_pcm_config ux500_dmaengine_pcm_config = {
 	.prepare_slave_config = ux500_pcm_prepare_slave_config,
 };
 
+static const struct snd_dmaengine_pcm_config ux500_dmaengine_of_pcm_config = {
+	.pcm_hardware = &ux500_pcm_hw,
+	.prealloc_buffer_size = 128 * 1024,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+};
+
 int ux500_pcm_register_platform(struct platform_device *pdev)
 {
+	const struct snd_dmaengine_pcm_config *pcm_config;
+	struct device_node *np = pdev->dev.of_node;
+	unsigned int pcm_flags;
 	int ret;
 
-	ret = snd_dmaengine_pcm_register(&pdev->dev,
-			&ux500_dmaengine_pcm_config,
-			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
-			SND_DMAENGINE_PCM_FLAG_COMPAT |
-			SND_DMAENGINE_PCM_FLAG_NO_DT);
+	if (np) {
+		pcm_config = &ux500_dmaengine_of_pcm_config;
+
+		pcm_flags = SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
+			SND_DMAENGINE_PCM_FLAG_COMPAT;
+	} else {
+		pcm_config = &ux500_dmaengine_pcm_config;
+
+		pcm_flags = SND_DMAENGINE_PCM_FLAG_NO_RESIDUE |
+			SND_DMAENGINE_PCM_FLAG_NO_DT |
+			SND_DMAENGINE_PCM_FLAG_COMPAT;
+	}
+
+	ret = snd_dmaengine_pcm_register(&pdev->dev, pcm_config, pcm_flags);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"%s: ERROR: Failed to register platform '%s' (%d)!\n",

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
