Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3K2PSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:18:23 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51005 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3K2PSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:18:21 -0500
MIME-Version: 1.0
In-Reply-To: <1385725828-836-1-git-send-email-will.deacon@arm.com>
References: <1385725828-836-1-git-send-email-will.deacon@arm.com>
Date: Fri, 29 Nov 2013 20:48:20 +0530
Message-ID: <CABb+yY1WQ1dJGQe8kK_R0B8A-aCf7OX3WN_dC5k10F3pa=hwVA@mail.gmail.com>
Subject: Re: [PATCH] dma: pl330: ensure DMA descriptors are zero-initialised
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Fri, Nov 29, 2013 at 5:20 PM, Will Deacon <will.deacon@arm.com> wrote:
>
> I see the following splat with 3.13-rc1 when attempting to perform DMA:
>
> [  253.004516] Alignment trap: not handling instruction e1902f9f at [<c0204b40>]
> [  253.004583] Unhandled fault: alignment exception (0x221) at 0xdfdfdfd7
> [  253.004646] Internal error: : 221 [#1] PREEMPT SMP ARM
> [  253.004691] Modules linked in: dmatest(+) [last unloaded: dmatest]
> [  253.004798] CPU: 0 PID: 671 Comm: kthreadd Not tainted 3.13.0-rc1+ #2
> [  253.004864] task: df9b0900 ti: df03e000 task.ti: df03e000
> [  253.004937] PC is at dmaengine_unmap_put+0x14/0x34
> [  253.005010] LR is at pl330_tasklet+0x3c8/0x550
> [  253.005087] pc : [<c0204b44>]    lr : [<c0207478>]    psr: a00e0193
> [  253.005087] sp : df03fe48  ip : 00000000  fp : df03bf18
> [  253.005178] r10: bf00e108  r9 : 00000001  r8 : 00000000
> [  253.005245] r7 : df837040  r6 : dfb41800  r5 : df837048  r4 : df837000
> [  253.005316] r3 : dfdfdfcf  r2 : dfb41f80  r1 : df837048  r0 : dfdfdfd7
> [  253.005384] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [  253.005459] Control: 30c5387d  Table: 9fb9ba80  DAC: fffffffd
> [  253.005520] Process kthreadd (pid: 671, stack limit = 0xdf03e248)
>
> This is due to desc->txd.unmap containing garbage (uninitialised memory).
>
> Rather than add another dummy initialisation to _init_desc, instead
> ensure that the descriptors are zero-initialised during allocation and
> remove the dummy, per-field initialisation.
>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  drivers/dma/pl330.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 98641eaca080..79e52a94f054 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2492,14 +2492,8 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
>
>  static inline void _init_desc(struct dma_pl330_desc *desc)
>  {
> -       desc->pchan = NULL;
>         desc->req.x = &desc->px;
>         desc->req.token = desc;
> -       desc->rqcfg.swap = SWAP_NO;
> -       desc->rqcfg.privileged = 0;
> -       desc->rqcfg.insnaccess = 0;
> -       desc->rqcfg.scctl = SCCTRL0;
> -       desc->rqcfg.dcctl = DCCTRL0;
>
These happen to evaluate to 0, but for completeness sake they ought to
be initialized somewhere. Otherwise we might as well drop these
members.

However I don't strongly feel about either way. So whatever comes in v2...

Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
