Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3CUKVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:21:30 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52403 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3CUKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <1363859357-31545-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1363859357-31545-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 21 Mar 2013 15:51:28 +0530
Message-ID: <CAKohpo=yNtBwgLQYRGBG77yy2yePo1R22fM4kKw+S3L1P++FZA@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: don't wait for FIFO_EMPTY endlessly in dwc_chan_pause
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2013 15:19, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> When we pause the channel after transfer is completed we might stuck in the
> dwc_chan_pause() because the FIFO_EMPTY flag will never be asserted. To avoid
> the endless loop we introduce a timeout here (*). The proper solution is to
> somehow get the residue in FIFO and avoid busyloop when transfer is done, but
> this task is not simple and fast.
>
> Unfortunately we can't use cpu_relax() in conjunction with jiffies checker, due
> to we have interrupts disabled by spin_lock_irqsave() and there is a big chance
> that no interrupts will come to update the jiffies..
>
> (*) The worst case is
>         AHB write * FIFO size / hclk = 5.12 us,
>     where
>         AHB write = 2 cycles,
>         hclk = 100 MHz,
>         burst size = 1 byte,
>         FIFO size = 256 bytes.
>     The proposed 40us timeout might be considered as a big one, though we enter
>     to that state only when we have the transfer already completed.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 43a5329..43e2e89 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1030,10 +1030,11 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
>  static inline void dwc_chan_pause(struct dw_dma_chan *dwc)
>  {
>         u32 cfglo = channel_readl(dwc, CFG_LO);
> +       unsigned int count = 20;        /* timeout iterations */
>
>         channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
> -       while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY))
> -               cpu_relax();
> +       while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY) && count--)
> +               udelay(2);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
