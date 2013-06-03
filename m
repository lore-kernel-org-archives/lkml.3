Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3FCKHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:07:48 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46853 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3FCKHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <1370246529-17155-3-git-send-email-wangxfdu@gmail.com>
References: <1370246529-17155-1-git-send-email-wangxfdu@gmail.com>
	<1370246529-17155-3-git-send-email-wangxfdu@gmail.com>
Date: Mon, 3 Jun 2013 13:07:44 +0300
Message-ID: <CAHp75Vcv9Uicn=auPLaSymYDHgWrd6-KnFN=GkHL-5MZQicYFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: mmp_pdma: clear DRCMR when free a phy channel
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 11:02 AM, Xiang Wang <wangxfdu@gmail.com> wrote:
> From: Xiang Wang <wangx@marvell.com>
>
> In mmp pdma, phy channels are allocated/freed dynamically.
> The mapping from DMA request to DMA channel number in DRCMR
> should be cleared when a phy channel is freed. Otherwise
> conflicts will happen when:
> 1. A is using channel 2 and free it after finished, but A
> still maps to channel 2 in DRCMR of A.
> 2. Now another one B gets channel 2. So B maps to channel 2
> too in DRCMR of B.
> In the datasheet, it is described that "Do not map two active
> requests to the same channel since it produces unpredictable
> results" and we can observe that during test.


> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -252,9 +252,15 @@ static void free_phy(struct mmp_pdma_chan *pchan)
>  {
>         struct mmp_pdma_device *pdev = to_mmp_pdma_dev(pchan->chan.device);
>         unsigned long flags;
> +       u32 reg;

May be empty line here (and maybe even in previous patch)?

>         if (!pchan->phy)
>                 return;
>
> +       /* clear the channel mapping in DRCMR */
> +       reg = pchan->phy->vchan->drcmr;
> +       reg = (((reg) < 64) ? 0x0100 : 0x1100) + (((reg) & 0x3f) << 2);

Too many braces.
It is not a macro, you don't need to embrace reg.

> +       writel(0, pchan->phy->base + reg);
> +
>         spin_lock_irqsave(&pdev->phy_lock, flags);
>         pchan->phy->vchan = NULL;
>         pchan->phy = NULL;



--
With Best Regards,
Andy Shevchenko
