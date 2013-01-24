Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3AXKp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:45:26 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:49629 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3AXKpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <1359023660-29084-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359023660-29084-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1359023660-29084-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 24 Jan 2013 16:15:17 +0530
X-Google-Sender-Auth: xdGW0Fkh6KQDtV0x2AG3sgWQQME
Message-ID: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I told you, we can get rid of that routine :)

On Thu, Jan 24, 2013 at 4:04 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

I don't see residue - len from interrupt handler. It isn't required?

> @@ -1062,6 +1090,7 @@ dwc_tx_status(struct dma_chan *chan,
>               struct dma_tx_state *txstate)
>  {
>         struct dw_dma_chan      *dwc = to_dw_dma_chan(chan);
> +       unsigned long           flags;
>         enum dma_status         ret;
>
>         ret = dma_cookie_status(chan, cookie, txstate);
> @@ -1071,8 +1100,17 @@ dwc_tx_status(struct dma_chan *chan,
>                 ret = dma_cookie_status(chan, cookie, txstate);
>         }
>
> -       if (ret != DMA_SUCCESS)
> -               dma_set_residue(txstate, dwc_first_active(dwc)->len);
> +       spin_lock_irqsave(&dwc->lock, flags);
> +
> +       if (ret != DMA_SUCCESS) {
> +               u32 residue = dwc->residue;

If you agree with the explanation that i gave in last mail, you must drop lock
right here. and also take it in this if block.

> +               if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags) && residue)
> +                       residue -= dwc_get_sent(dwc);
> +               dma_set_residue(txstate, residue);
> +       }
> +
> +       spin_unlock_irqrestore(&dwc->lock, flags);

other than that:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
