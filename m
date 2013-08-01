Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3HARQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:16:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:60013 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3HARQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:16:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,795,1367996400"; 
   d="scan'208";a="374689019"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "Mason, Jon" <jon.mason@intel.com>
CC: Brice Goglin <Brice.Goglin@inria.fr>, Dan Williams <djbw@fb.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
Thread-Topic: ioatdma: add ioat_raid_enabled module parameter
Thread-Index: AQHOjjom0XMeyUNRoUmcakeh/vzoC5l/z3CAgAE92oCAAAEvgA==
Date: Thu, 1 Aug 2013 17:15:59 +0000
Message-ID: <1375377359.40527.2.camel@djiang5-linux2.ch.intel.com>
References: <51F98A3F.3000102@inria.fr>
	 <1375308847.6448.6.camel@djiang5-linux2.ch.intel.com>
	 <20130801171144.GB13747@jonmason-lab>
In-Reply-To: <20130801171144.GB13747@jonmason-lab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E7C1BE2D247D64EB2FEAE6AB6041864@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r71HG9Vo022633

On Thu, 2013-08-01 at 10:11 -0700, Jon Mason wrote:
> On Wed, Jul 31, 2013 at 03:14:07PM -0700, Jiang, Dave wrote:
> > I'm ok with enabling this for people that just want to use DMA and not
> > RAID. 
> 
> I might be crazy, but I'd be in favor of disabling the RAID offload by
> default on non-Atom platforms.
> 

I suppose. Technically it is disabled starting with 3.10 because of the
channel switch issue. I'm ok with this disabled by default for the 3.2
platforms that has broken pq-val. 

> Thanks,
> Jon
> 
> > 
> > Acked-by: Dave Jiang <dave.jiang@intel.com>
> > 
> > On Thu, 2013-08-01 at 00:05 +0200, Brice Goglin wrote:
> > > ioatdma: add ioat_raid_enabled module parameter
> > > 
> > > Commit f26df1a1 added a 64-byte alignment requirement for legacy
> > > operations to work around a silicon errata when mixing legacy and
> > > RAID descriptors.
> > > Passing ioat_raid_enabled=0 now disables RAID offload entirely in
> > > the ioatdma driver so that legacy operations (memcpy, etc.) can
> > > work without alignment restrictions anymore.
> > > 
> > > Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> > > ---
> > >  drivers/dma/ioat/dma_v3.c |    9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > Index: b/drivers/dma/ioat/dma_v3.c
> > > ===================================================================
> > > --- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
> > > +++ b/drivers/dma/ioat/dma_v3.c	2013-07-31 23:47:54.246719841 +0200
> > > @@ -67,6 +67,11 @@
> > >  #include "dma.h"
> > >  #include "dma_v2.h"
> > >  
> > > +static int ioat_raid_enabled = 1;
> > > +module_param(ioat_raid_enabled, int, 0444);
> > > +MODULE_PARM_DESC(ioat_raid_enabled,
> > > +		 "control support of RAID offload (default: 1)");
> > > +
> > >  /* ioat hardware assumes at least two sources for raid operations */
> > >  #define src_cnt_to_sw(x) ((x) + 2)
> > >  #define src_cnt_to_hw(x) ((x) - 2)
> > > @@ -1775,7 +1780,7 @@ int ioat3_dma_probe(struct ioatdma_devic
> > >  	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
> > >  	dma->device_free_chan_resources = ioat2_free_chan_resources;
> > >  
> > > -	if (is_xeon_cb32(pdev))
> > > +	if (is_xeon_cb32(pdev) && ioat_raid_enabled)
> > >  		dma->copy_align = 6;
> > >  
> > >  	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
> > > @@ -1783,7 +1788,7 @@ int ioat3_dma_probe(struct ioatdma_devic
> > >  
> > >  	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
> > >  
> > > -	if (is_bwd_noraid(pdev))
> > > +	if (!ioat_raid_enabled || is_bwd_noraid(pdev))
> > >  		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
> > >  
> > >  	/* dca is incompatible with raid operations */
> > > 
> > 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
