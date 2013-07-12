Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab3GLMOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:14:51 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56312 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070Ab3GLMOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:14:49 -0400
X-Auth-Info: k78+m5To1Yb82lc+7J3YluQD1jXAY5mhTSHDdVD1hFs=
Date: Fri, 12 Jul 2013 14:14:41 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lars@metafoo.de
Subject: Re: [V2 1/2] powerpc: mpc512x_dma: add support for data transfers
 between memory and i/o memory
Message-ID: <20130712121441.GH2615@book.gsilab.sittig.org>
Mail-Followup-To: Alexander Popov <a13xp0p0v88@gmail.com>,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	lars@metafoo.de
References: <1373451651-20029-1-git-send-email-a13xp0p0v88@gmail.com>
 <20130710125811.GB2615@book.gsilab.sittig.org>
 <CAF0T0X70wa1DBPtvccr+-cb9_2AAw1tFaqJSt7_7GP-xa1qyVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF0T0X70wa1DBPtvccr+-cb9_2AAw1tFaqJSt7_7GP-xa1qyVg@mail.gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Lars to Cc: since we talk about OF-DMA ]

I put your DMA part of the series into a local test setup, and
slightly modified it in the suggested ways.  This may not suffice
for a Tested-By attribute, since it did not test your LPB part
and did not use your original patch.  But it verified that the
DMA part can be made operational and others can build on it. :)

We shall combine the parts which currently are floating around.
So that others aren't supposed to pick up pieces but instead can
use a series and get something consistent.

Here are the parts that I'm aware of:
- Anatolij's work that was motivated by SD card support, the
  mxcmmc(4) part went mainline, the DMA part did not (patchwork
  2368581, 2368591)
- Lars' work on OF support that was motivated by a different
  platform but is useful for the MPC512x as well (2331091)
- your Alex' work that is motivated by SCLPC support is currently
  under review (while the DMA part appears to re-use Anatolij's
  approach?)
- my local work that's picking up Anatolij's previous work and
  includes items which are unrelated to DMA yet are helpful here
  (MPC512x common clock support, preprocessor use in DTS builds)

So I suggest that I create an RFC series which combines those
parts that I consider "DMA related", which you can in turn put
your SCLPC support onto, or pick it up and fold it into yours.
The latter may be more appropriate since announcing something via
OF is only useful after implementing the support (here: slave
S/G in the DMA engine).

On Fri, Jul 12, 2013 at 14:15 +0400, Alexander Popov wrote:
> 
> 2013/7/10 Gerhard Sittig <gsi@denx.de>:
> 
> >> @@ -256,7 +256,9 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
> >>
> >>               prev->tcd->dlast_sga = mdesc->tcd_paddr;
> >>               prev->tcd->e_sg = 1;
> >> -             mdesc->tcd->start = 1;
> >> +             /* only start explicitly on MDDRC channel */
> >> +             if (cid == 32)
> >> +                     mdesc->tcd->start = 1;
> >>
> >>               prev = mdesc;
> >>       }
> >> @@ -268,7 +270,15 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
> >>
> >>       if (first != prev)
> >>               mdma->tcd[cid].e_sg = 1;
> >> -     out_8(&mdma->regs->dmassrt, cid);
> >> +
> >> +     switch (cid) {
> >> +     case 26:
> >> +             out_8(&mdma->regs->dmaserq, cid);
> >> +             break;
> >> +     case 32:
> >> +             out_8(&mdma->regs->dmassrt, cid);
> >> +             break;
> >> +     }
> >>  }
> >>
> >>  /* Handle interrupt on one half of DMA controller (32 channels) */
> 
> > This part of the change looks suspicious to me.  The logic
> > changes from always starting the transfer in software to only
> > starting from software for memory or having hardware request the
> > start for LPB controller requests, while _all_other_ channels
> > remain without setup of the start condition.
> >
> > Either make sure that only the new source (LPB) gets handled
> > specially, or
> 
> I agree, I'll use this way.

I'd prefer the other approach since it lasts longer.  Upon second
thought it turns out that "memory transfers" are special since
they are software initiated, while "everything else" is hardware
driven (requester lines used).

The change is simple and handles all future DMA channel use as
well.  Just say 'default' instead of 'case 26'.  See my series
that I'll submit later.

> > In addition, try to get rid of the magic numbers.  Use symbolic
> > identifiers instead (regardless of whether other floating patches
> > used magic numbers as well).
> 
> Ok.

This gets addressed as well by what I have here (CPP use in DTS
nodes and driver code).

> >> +             if (!IS_ALIGNED(sg_dma_address(sg), 4))
> >> +                     return NULL;
> >> +
> >> +             if (direction == DMA_DEV_TO_MEM) {
> >> +                     tcd->saddr = mchan->per_paddr;
> >> +                     tcd->daddr = sg_dma_address(sg);
> >> +                     tcd->soff = 0;
> >> +                     tcd->doff = 4;
> >> +             } else if (direction == DMA_MEM_TO_DEV) {
> >> +                     tcd->saddr = sg_dma_address(sg);
> >> +                     tcd->daddr = mchan->per_paddr;
> >> +                     tcd->soff = 4;
> >> +                     tcd->doff = 0;
> >> +             } else {
> >> +                     return NULL;
> >> +             }
> >> +             tcd->ssize = MPC_DMA_TSIZE_4;
> >> +             tcd->dsize = MPC_DMA_TSIZE_4;
> 
> > This hardcodes the address increments and the source and
> > destination port sizes to 32bits, right?  This may be an
> > acceptable limitation given the current use of the DMA engine,
> > but might need a comment as well.
> 
> Ok, I'll add it.
> 
> >> +             } else {
> >> +                     /* citer_linkch contains the high bits of iter */
> >> +                     tcd->biter = iter & 0x1ff;
> >> +                     tcd->biter_linkch = iter >> 9;
> >> +                     tcd->citer = tcd->biter;
> >> +                     tcd->citer_linkch = tcd->biter_linkch;
> >> +             }
> 
> > I cannot tell how these magic numbers here (bit masks, shift
> > numbers) are acceptable or shall get replaced by something else.
> > Just pointing at potential for improvement. :)
> 
> This piece of code may become clearer if I improve the comment.

[ I might be mixing DMA and LPB comments here ]

This specific part (one 15bit spec that happens to get stored in
two 6bit and 9bit fields) may be the simplest case.  But I
thought I've seen others.

> >> +
> >> +             tcd->e_sg = 0;
> >> +             tcd->d_req = 1;
> >> +
> >> +             /* Place descriptor in prepared list */
> >> +             spin_lock_irqsave(&mchan->lock, iflags);
> >> +             list_add_tail(&mdesc->node, &mchan->prepared);
> >> +             spin_unlock_irqrestore(&mchan->lock, iflags);
> >> +     }
> >> +
> >> +     /* Return the last descriptor */
> >> +     return &mdesc->desc;
> >> +}
> >> +
> 
> > It's not related to your specific patch, but I guess that the
> > current implementation of the MPC512x DMA engine cannot really
> > cope with scatter/gather as it should.  Unfortunately the Linux
> > DMA API appears to "somehow intermingle" the S/G aspect with
> > "peripheral access", while it actually should be orthogonal.
> 
> That's why I tried to add my code to mpc_dma_prep_memcpy()
> in the first version of this patch.

Several months ago I had a look at the MPC512x DMA support.  What
I disliked was
- that 'slave' support actually means 'peripherals involved'
  (took me a while to figure that out, with the wrong association
  due to terminology something was lacking on my side)
- that 'scatter/gather' is "interwoven" with 'slave' support (the
  literature and other development suggest that it's applicable
  to memory transfers as well)
- the "thin" transport between prep and submit, which just could
  carry one single mdesc
- the driver's not cleanly supporting "multiple TCDs for one
  mdesc" which would be required for s/g support (unless I'm
  missing something, and the prep/submit API may carry several
  mdescs for one submission)

Most of the issues are in the subsystem's API and cannot get
changed easily, but OTOH may not need to since they are
"unexpected" yet acceptable and most of all established.

Part is the specific driver's focus on "memory transfers only for
now".  That can get addressed later, and separately.

> 
> > To cut it short:  As long as "mdesc" items and "TCD" items can't
> > get allocated and chained individually, and as long as the prep
> > and submit routines assume that an mdesc is associated with
> > exactly one tcd, there should be a comment about this limitation
> > or even better an explicit check in the prep slave sg routine to
> > reject S/G lists with more than one entry.
> 
> I'll fix that and return with the third version.

I suggest to just put a comment and an explicit check in.  The
code works for "S/G lists of length 1".  That's OK for now, I
guess.

Adding real S/G support is much more involved and includes
chaining TCDs separately from mdesc items.  Adjusting the prep,
submit, and execute steps, to map both single TCD as well as
multiple TCD jobs into the common "S/G list" that's currently run
on the DMA hardware.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
