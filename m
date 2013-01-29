Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3A2FHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:07:34 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38185 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3A2FHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 29 Jan 2013 10:29:43 +0530
X-Google-Sender-Auth: D_FVoY8VZT__2f4yjORpKohVFJ8
Message-ID: <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next time, please direct these mails to my Linaro id :)

On Mon, Jan 28, 2013 at 4:34 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On some hardware configurations we have got the request line with the offset.
> The patch introduces convert_slave_id() helper for that cases. The request line
> base is got from the platform device resources provided by the IORESOURCE_DMA
> type.

@Vinod: Is IORESOURCE_DMA suitable for this purpose?

> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c      |   13 +++++++++++++
>  drivers/dma/dw_dmac_regs.h |    1 +
>  2 files changed, 14 insertions(+)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 3155c11..8484ca1 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -995,6 +995,13 @@ static inline void convert_burst(u32 *maxburst)
>                 *maxburst = 0;
>  }
>
> +static inline void convert_slave_id(struct dw_dma_chan *dwc)
> +{
> +       struct dw_dma *dw = to_dw_dma(dwc->chan.device);
> +
> +       dwc->dma_sconfig.slave_id -= dw->request_line_base;
> +}
> +
>  static int
>  set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
>  {
> @@ -1009,6 +1016,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
>
>         convert_burst(&dwc->dma_sconfig.src_maxburst);
>         convert_burst(&dwc->dma_sconfig.dst_maxburst);
> +       convert_slave_id(dwc);
>
>         return 0;
>  }
> @@ -1717,6 +1725,11 @@ static int dw_probe(struct platform_device *pdev)
>                 memcpy(dw->data_width, pdata->data_width, 4);
>         }
>
> +       /* Get the base request line if set */
> +       io = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> +       if (io)
> +               dw->request_line_base = (unsigned int)io->start;
> +

How will it work in case of DT?

>         /* Calculate all channel mask before DMA setup */
>         dw->all_chan_mask = (1 << nr_channels) - 1;
>
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 88dd8eb..3eeb766 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -248,6 +248,7 @@ struct dw_dma {
>         /* hardware configuration */
>         unsigned char           nr_masters;
>         unsigned char           data_width[4];
> +       unsigned int            request_line_base;
>
>         struct dw_dma_chan      chan[0];
>  };

--
viresh
