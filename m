Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaKSD5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:57:39 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:36608 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaKSD5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:57:37 -0500
MIME-Version: 1.0
In-Reply-To: <1416366468-4744-1-git-send-email-jay.xu@rock-chips.com>
References: <1416366365-4632-1-git-send-email-jay.xu@rock-chips.com> <1416366468-4744-1-git-send-email-jay.xu@rock-chips.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Tue, 18 Nov 2014 19:57:16 -0800
X-Google-Sender-Auth: ia9NzcoUcv3OfB8HEIixMyxtAII
Message-ID: <CAPz6YkXGUh5aw3=nNaLM+O-FfVeSJWb-xyQGciZOsm2mw_txfw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: rockchip: i2s: add support for grabbing output
 clock to codec
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tao Huang <huangtao@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay,

On Tue, Nov 18, 2014 at 7:07 PM, Jianqun Xu <jay.xu@rock-chips.com> wrote:

Mostly FYI, but if you take someone else's patch, you should also
retain their authorship by saying:
From: <person>
at the top of the message. I don't really mind, but please keep it in
mind for the future, thanks.

> We need to claim the clock which is driving the codec so that when we enable
> clock gating, we continue to clock the codec when needed.  I make this an
> optional clock since there might be some applications where we don't need it
> but can still use the I2S block.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
> ---
>  sound/soc/rockchip/rockchip_i2s.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
> index c74ba37..2820ade 100644
> --- a/sound/soc/rockchip/rockchip_i2s.c
> +++ b/sound/soc/rockchip/rockchip_i2s.c
> @@ -28,6 +28,7 @@ struct rk_i2s_dev {
>
>         struct clk *hclk;
>         struct clk *mclk;
> +       struct clk *oclk;
>
>         struct snd_dmaengine_dai_dma_data capture_dma_data;
>         struct snd_dmaengine_dai_dma_data playback_dma_data;
> @@ -439,6 +440,14 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
>                 return PTR_ERR(i2s->mclk);
>         }
>
> +       i2s->oclk = devm_clk_get(&pdev->dev, "i2s_clk_out");
> +       if (IS_ERR(i2s->oclk)) {
> +               dev_dbg(&pdev->dev, "Didn't find output clock\n");
> +               i2s->oclk = NULL;
> +       }
> +       if (i2s->oclk)
> +               ret = clk_prepare_enable(i2s->oclk);
> +
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         regs = devm_ioremap_resource(&pdev->dev, res);
>         if (IS_ERR(regs))
> @@ -505,6 +514,8 @@ static int rockchip_i2s_remove(struct platform_device *pdev)
>         if (!pm_runtime_status_suspended(&pdev->dev))
>                 i2s_runtime_suspend(&pdev->dev);
>
> +       if (i2s->oclk)
> +               clk_disable_unprepare(i2s->oclk);
>         clk_disable_unprepare(i2s->mclk);
>         clk_disable_unprepare(i2s->hclk);
>         snd_dmaengine_pcm_unregister(&pdev->dev);
> --
> 1.9.1
>
