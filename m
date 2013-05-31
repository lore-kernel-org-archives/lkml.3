Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3EaIer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:34:47 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:37403 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3EaIei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:34:38 -0400
MIME-Version: 1.0
In-Reply-To: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
References: <1369988485-23176-1-git-send-email-wangxfdu@gmail.com>
Date: Fri, 31 May 2013 11:34:36 +0300
Message-ID: <CAHp75Veb+FK=5u_HBUp+KNT4__GjbSg1T-kq1tGebDq2pEJOBA@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_pdma: support for getting residual bytes
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:21 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
> In some of our drivers (e.g. UART) we may stop a running DMA
> before it finishes. So we need to know how many bytes have
> been transferred.

Couple of comments below.

> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c

> @@ -589,7 +638,13 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
>                 mmp_pdma_free_desc_list(chan, &chan->chain_pending);
>                 mmp_pdma_free_desc_list(chan, &chan->chain_running);
>                 spin_unlock_irqrestore(&chan->desc_lock, flags);
> -               chan->idle = true;
> +               chan->status = DMA_SUCCESS;
> +               chan->bytes_residue = 0;
> +               break;
> +       case DMA_PAUSE:
> +               disable_chan(chan->phy);
> +               chan->status = DMA_PAUSED;
> +               chan->bytes_residue = mmp_pdma_get_bytes_residue(chan);

Does it mean user has to do DMA_PAUSE first to get more or less
accurate residue?
Logically that sound correct, but in general we may allow user to get
approximate residue value of on going transfer.

>                 break;
>         case DMA_SLAVE_CONFIG:
>                 if (cfg->direction == DMA_DEV_TO_MEM) {
> @@ -637,7 +692,8 @@ static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
>         unsigned long flags;
>
>         spin_lock_irqsave(&chan->desc_lock, flags);
> -       ret = dma_cookie_status(dchan, cookie, txstate);
> +       ret = chan->status;
> +       dma_set_residue(txstate, chan->bytes_residue);
>         spin_unlock_irqrestore(&chan->desc_lock, flags);

Besides my patch which removes this spinlock I think the workflow
should be something like

status = dma_cookie_status()
if status == DMA_SUCCESS or !txstate:
return status

dma_set_residue()
return status

Because there is no reason to return residue of successfully finished
transfer. It should be 0.

--
With Best Regards,
Andy Shevchenko
