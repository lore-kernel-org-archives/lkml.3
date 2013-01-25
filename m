Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3AYEOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:14:02 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44613 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AYEN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:13:59 -0500
MIME-Version: 1.0
In-Reply-To: <1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
	<1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 25 Jan 2013 09:43:58 +0530
X-Google-Sender-Auth: Tmh3B7Uk9LnwgEWCu1Irsc5u8YI
Message-ID: <CAOh2x=nnrEo69W7sBES85KgF0+WUy8Ouoq+SG1XiB54e7QLiow@mail.gmail.com>
Subject: Re: [PATCH v3.5] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 6:37 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Currently the driver returns full length of the active descriptor which is
> wrong. We have to go throught the active descriptor and substract the length of
> each sent children in the chain from the total length along with the actual
> data in the DMA channel registers.
>
> The cyclic case is not handled by this patch due to len field in the descriptor
> structure is left untouched by the original code.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Firstly the issue i raised earlier about not updating residue from
tasklet or interrupt
handler was wrong. As i had an older version of code in my mind. This got solved
with following patch:

commit 77bcc497c60ec62dbb84abc809a6e218d53409e9
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Fri Jan 18 14:14:15 2013 +0200

    dw_dmac: move soft LLP code from tasklet to dwc_scan_descriptors


> ---
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> +static inline u32 dwc_get_residue(struct dw_dma_chan *dwc)
> +{
> +       unsigned long flags;
> +       u32 residue;
> +
> +       spin_lock_irqsave(&dwc->lock, flags);
> +
> +       residue = dwc->residue;

you need to release the lock just here.

> +       if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags) && residue)
> +               residue -= dwc_get_sent(dwc);

why do you need lock while reading the control registers? It looks you didn't
get what i wanted to say earlier. We are using locks to protect some part for
shared data or critical sections. these are playing with dwc transfer
lists, etc..

Probably we don't need a lock to read the control register as nobody can
guarantee that another access is not happening currently. As hardware is
changing this register continuously for the transfer.

Let me know if i am missing something.

> +       spin_unlock_irqrestore(&dwc->lock, flags);
> +       return residue;
> +}
