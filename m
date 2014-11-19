Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaKSKOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:14:23 -0500
Received: from gloria.sntech.de ([95.129.55.99]:54126 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbaKSKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:14:22 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, huangtao@rock-chips.com,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH v2 2/2] ASoC: rockchip: i2s: add support for grabbing output clock to codec
Date: Wed, 19 Nov 2014 11:17:56 +0100
Message-ID: <3448679.qPaq5DHST3@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416384567-29476-1-git-send-email-jay.xu@rock-chips.com>
References: <1416366468-4744-1-git-send-email-jay.xu@rock-chips.com> <1416384567-29476-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,


Am Mittwoch, 19. November 2014, 16:09:27 schrieb Jianqun Xu:
> Patch is from Sonny Rao <sonnyrao@chromium.org>
that line above should read exactly:
From: Sonny Rao <sonnyrao@chromium.org>

that way git will also set the author correctly when importing the patch mbox.

> 
> We need to claim the clock which is driving the codec so that when we enable
> clock gating, we continue to clock the codec when needed.  I make this an
> optional clock since there might be some applications where we don't need
> it but can still use the I2S block.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

I think we you're submitting someone elses patch you'll need a Signed-off-by 
line for yourself too [which marks that you were allowed to submit it etc], so 
it should read something like

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>


> ---
> changes since v1:
> - modify commit message
> 
>  sound/soc/rockchip/rockchip_i2s.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/sound/soc/rockchip/rockchip_i2s.c
> b/sound/soc/rockchip/rockchip_i2s.c index c74ba37..2820ade 100644
> --- a/sound/soc/rockchip/rockchip_i2s.c
> +++ b/sound/soc/rockchip/rockchip_i2s.c
> @@ -28,6 +28,7 @@ struct rk_i2s_dev {
> 
>  	struct clk *hclk;
>  	struct clk *mclk;
> +	struct clk *oclk;
> 
>  	struct snd_dmaengine_dai_dma_data capture_dma_data;
>  	struct snd_dmaengine_dai_dma_data playback_dma_data;
> @@ -439,6 +440,14 @@ static int rockchip_i2s_probe(struct platform_device
> *pdev) return PTR_ERR(i2s->mclk);
>  	}
> 
> +	i2s->oclk = devm_clk_get(&pdev->dev, "i2s_clk_out");
> +	if (IS_ERR(i2s->oclk)) {
> +		dev_dbg(&pdev->dev, "Didn't find output clock\n");
> +		i2s->oclk = NULL;
> +	}

blank line here?

> +	if (i2s->oclk)
> +		ret = clk_prepare_enable(i2s->oclk);
> +
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	regs = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(regs))
> @@ -505,6 +514,8 @@ static int rockchip_i2s_remove(struct platform_device
> *pdev) if (!pm_runtime_status_suspended(&pdev->dev))
>  		i2s_runtime_suspend(&pdev->dev);
> 
> +	if (i2s->oclk)
> +		clk_disable_unprepare(i2s->oclk);
>  	clk_disable_unprepare(i2s->mclk);
>  	clk_disable_unprepare(i2s->hclk);
>  	snd_dmaengine_pcm_unregister(&pdev->dev);


Heiko

