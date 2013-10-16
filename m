Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab3JPJtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:49:20 -0400
Received: from multi.imgtec.com ([194.200.65.239]:23418 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760173Ab3JPJtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:49:18 -0400
Message-ID: <525E611A.6070708@imgtec.com>
Date: Wed, 16 Oct 2013 10:49:14 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Protect read-modify-write of INTMASK
 with a lock
References: <1381876762-10892-1-git-send-email-dianders@chromium.org> <1381876762-10892-3-git-send-email-dianders@chromium.org>
In-Reply-To: <1381876762-10892-3-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_10_16_10_49_16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug.

Nice catch.

On 15/10/13 23:39, Doug Anderson wrote:
> We're running into cases where our enabling of the SDIO interrupt in
> dw_mmc doesn't actually take effect.  Specifically, adding patch like
> this:
> 
>  +++ b/drivers/mmc/host/dw_mmc.c
>  @@ -1076,6 +1076,9 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
> 
>       mci_writel(host, INTMASK,
>            (int_mask | SDMMC_INT_SDIO(slot->id)));
>  +    int_mask = mci_readl(host, INTMASK);
>  +    if (!(int_mask & SDMMC_INT_SDIO(slot->id)))
>  +      dev_err(&mmc->class_dev, "failed to enable sdio irq\n");
>     } else {
> 
> ...actually triggers the error message.  That's because the
> dw_mci_enable_sdio_irq() unsafely does a read-modify-write of the
> INTMASK register.
> 
> We can't just use the standard host->lock since that lock is not irq
> safe and mmc_signal_sdio_irq() (called from interrupt context) calls
> dw_mci_enable_sdio_irq().  Add a new irq-safe lock to protect INTMASK.
> 
> An alternate solution to this is to punt mmc_signal_sdio_irq() to the
> tasklet and then protect INTMASK modifications by the standard host
> lock.  This seemed like a bit more of a high-latency change.

A probably lighter-weight alternative to that alternative is to just
make the existing lock irq safe. Has this been considered?

I'm not entirely convinced it's worth having a separate lock rather than
changing the existing one, but the patch still appears to be correct, so:
Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

