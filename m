Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab3GLKPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:15:22 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63573 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab3GLKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130710125811.GB2615@book.gsilab.sittig.org>
References: <1373451651-20029-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130710125811.GB2615@book.gsilab.sittig.org>
Date: Fri, 12 Jul 2013 14:15:16 +0400
Message-ID: <CAF0T0X70wa1DBPtvccr+-cb9_2AAw1tFaqJSt7_7GP-xa1qyVg@mail.gmail.com>
Subject: Re: [V2 1/2] powerpc: mpc512x_dma: add support for data transfers
 between memory and i/o memory
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Alexander Popov <a13xp0p0v88@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/10 Gerhard Sittig <gsi@denx.de>:
> Disclaimer:  It's been a while since I worked with the MPC512x
> DMA controller, and I only read the RM rev3 back then.

Hello Gerhard.

Thank you for fast and detailed feedback.

>> @@ -256,7 +256,9 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>>
>>               prev->tcd->dlast_sga = mdesc->tcd_paddr;
>>               prev->tcd->e_sg = 1;
>> -             mdesc->tcd->start = 1;
>> +             /* only start explicitly on MDDRC channel */
>> +             if (cid == 32)
>> +                     mdesc->tcd->start = 1;
>>
>>               prev = mdesc;
>>       }
>> @@ -268,7 +270,15 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>>
>>       if (first != prev)
>>               mdma->tcd[cid].e_sg = 1;
>> -     out_8(&mdma->regs->dmassrt, cid);
>> +
>> +     switch (cid) {
>> +     case 26:
>> +             out_8(&mdma->regs->dmaserq, cid);
>> +             break;
>> +     case 32:
>> +             out_8(&mdma->regs->dmassrt, cid);
>> +             break;
>> +     }
>>  }
>>
>>  /* Handle interrupt on one half of DMA controller (32 channels) */

> This part of the change looks suspicious to me.  The logic
> changes from always starting the transfer in software to only
> starting from software for memory or having hardware request the
> start for LPB controller requests, while _all_other_ channels
> remain without setup of the start condition.
>
> Either make sure that only the new source (LPB) gets handled
> specially, or

I agree, I'll use this way.

> In addition, try to get rid of the magic numbers.  Use symbolic
> identifiers instead (regardless of whether other floating patches
> used magic numbers as well).

Ok.

>> +             if (!IS_ALIGNED(sg_dma_address(sg), 4))
>> +                     return NULL;
>> +
>> +             if (direction == DMA_DEV_TO_MEM) {
>> +                     tcd->saddr = mchan->per_paddr;
>> +                     tcd->daddr = sg_dma_address(sg);
>> +                     tcd->soff = 0;
>> +                     tcd->doff = 4;
>> +             } else if (direction == DMA_MEM_TO_DEV) {
>> +                     tcd->saddr = sg_dma_address(sg);
>> +                     tcd->daddr = mchan->per_paddr;
>> +                     tcd->soff = 4;
>> +                     tcd->doff = 0;
>> +             } else {
>> +                     return NULL;
>> +             }
>> +             tcd->ssize = MPC_DMA_TSIZE_4;
>> +             tcd->dsize = MPC_DMA_TSIZE_4;

> This hardcodes the address increments and the source and
> destination port sizes to 32bits, right?  This may be an
> acceptable limitation given the current use of the DMA engine,
> but might need a comment as well.

Ok, I'll add it.

>> +             } else {
>> +                     /* citer_linkch contains the high bits of iter */
>> +                     tcd->biter = iter & 0x1ff;
>> +                     tcd->biter_linkch = iter >> 9;
>> +                     tcd->citer = tcd->biter;
>> +                     tcd->citer_linkch = tcd->biter_linkch;
>> +             }

> I cannot tell how these magic numbers here (bit masks, shift
> numbers) are acceptable or shall get replaced by something else.
> Just pointing at potential for improvement. :)

This piece of code may become clearer if I improve the comment.

>> +
>> +             tcd->e_sg = 0;
>> +             tcd->d_req = 1;
>> +
>> +             /* Place descriptor in prepared list */
>> +             spin_lock_irqsave(&mchan->lock, iflags);
>> +             list_add_tail(&mdesc->node, &mchan->prepared);
>> +             spin_unlock_irqrestore(&mchan->lock, iflags);
>> +     }
>> +
>> +     /* Return the last descriptor */
>> +     return &mdesc->desc;
>> +}
>> +

> It's not related to your specific patch, but I guess that the
> current implementation of the MPC512x DMA engine cannot really
> cope with scatter/gather as it should.  Unfortunately the Linux
> DMA API appears to "somehow intermingle" the S/G aspect with
> "peripheral access", while it actually should be orthogonal.

That's why I tried to add my code to mpc_dma_prep_memcpy()
in the first version of this patch.

> To cut it short:  As long as "mdesc" items and "TCD" items can't
> get allocated and chained individually, and as long as the prep
> and submit routines assume that an mdesc is associated with
> exactly one tcd, there should be a comment about this limitation
> or even better an explicit check in the prep slave sg routine to
> reject S/G lists with more than one entry.

I'll fix that and return with the third version.

Best regards,
Alexander
