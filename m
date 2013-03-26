Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3CZRHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:07:33 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48971 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3CZRHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <1364317484-30005-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <5151B91B.7060404@metafoo.de>
	<1364317484-30005-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 26 Mar 2013 22:37:31 +0530
Message-ID: <CAKohpoksxVo3fFdaqOBucOzJs_aU3XGiTcM3b6GzW=m=ooFzQQ@mail.gmail.com>
Subject: Re: [PATCH v2.1] dw_dmac: make wrapper on of_dma_controller_register()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 22:34, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This patch introduces new method dw_dma_of_controller_register(). The wrapper
> is called only when of_node is present.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/dma/dw_dmac.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 274fd7d..12657d7 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1303,6 +1303,16 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
>         return dma_request_channel(cap, dw_dma_of_filter, &fargs);
>  }
>
> +static void dw_dma_of_controller_register(struct dw_dma *dw)
> +{
> +       struct device *dev = dw->dma.dev;
> +       int err;
> +
> +       err = of_dma_controller_register(dev->of_node, dw_dma_of_xlate, dw);
> +       if (err)
> +               dev_err(dev, "could not register of_dma_controller\n");
> +}
> +
>  /* --------------------- Cyclic DMA API extensions -------------------- */
>
>  /**
> @@ -1843,13 +1853,8 @@ static int dw_probe(struct platform_device *pdev)
>
>         dma_async_device_register(&dw->dma);
>
> -       if (pdev->dev.of_node) {
> -               err = of_dma_controller_register(pdev->dev.of_node,
> -                                                dw_dma_of_xlate, dw);
> -               if (err && err != -ENODEV)
> -                       dev_err(&pdev->dev,
> -                               "could not register of_dma_controller\n");
> -       }
> +       if (pdev->dev.of_node)
> +               dw_dma_of_controller_register(dw);

I forgot where we started from, but what's the need of this patch?
