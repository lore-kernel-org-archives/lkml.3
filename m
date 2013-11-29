Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3K2M55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:57:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:27685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3K2M5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,797,1378882800"; 
   d="scan'208";a="416904951"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Will Deacon <will.deacon@arm.com>
CC: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: ensure DMA descriptors are zero-initialised
Thread-Topic: [PATCH] dma: pl330: ensure DMA descriptors are zero-initialised
Thread-Index: AQHO7QKbqHQefA2SR0uQoM0gQsMzbQ==
Date: Fri, 29 Nov 2013 12:57:50 +0000
Message-ID: <1385729844.1871.24.camel@smile>
References: <1385725828-836-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1385725828-836-1-git-send-email-will.deacon@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EB916C76AD97941A8A1D7F21EA52B50@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rATCw26o000581

On Fri, 2013-11-29 at 11:50 +0000, Will Deacon wrote:
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
> -	desc->pchan = NULL;
>  	desc->req.x = &desc->px;
>  	desc->req.token = desc;
> -	desc->rqcfg.swap = SWAP_NO;
> -	desc->rqcfg.privileged = 0;
> -	desc->rqcfg.insnaccess = 0;
> -	desc->rqcfg.scctl = SCCTRL0;
> -	desc->rqcfg.dcctl = DCCTRL0;
>  	desc->req.cfg = &desc->rqcfg;
>  	desc->req.xfer_cb = dma_pl330_rqcb;
>  	desc->txd.tx_submit = pl330_tx_submit;
> @@ -2517,7 +2511,7 @@ static int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
>  	if (!pdmac)
>  		return 0;
>  
> -	desc = kmalloc(count * sizeof(*desc), flg);
> +	desc = kzalloc(count * sizeof(*desc), flg);

Maybe kcalloc() ?

>  	if (!desc)
>  		return 0;
>  

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
