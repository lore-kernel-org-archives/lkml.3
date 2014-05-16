Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaEPOri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:47:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:45164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595AbaEPOrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1067,1389772800"; 
   d="scan'208";a="540259271"
Date: Fri, 16 May 2014 22:47:18 +0800
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        david.a.cohen@linux.intel.com, Yuan Hang <hang.yuan@intel.com>,
        Li Jiebing <jiebing.li@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: dwc3: gadget: check link trb after free_slot is
 increased
Message-ID: <20140516144718.GI16153@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140515215757.GD16153@intel.com>
 <20140515153757.GB7360@saruman.home>
 <20140516155013.GE16153@intel.com>
 <20140516124106.GA20386@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516124106.GA20386@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Fri, May 16, 2014 at 07:41:06AM -0500, Felipe Balbi wrote:
> On Fri, May 16, 2014 at 11:50:13PM +0800, Zhuang Jin Can wrote:
> > > On Fri, May 16, 2014 at 05:57:57AM +0800, Zhuang Jin Can wrote:
> > > > In ISOC transfers, when free_slot points to the last TRB (i.e. Link
> > > > TRB), and all queued requests meet Missed Interval Isoc error, busy_slot
> > > > points to trb0.
> > > > 	busy_slot->trb0
> > > > 		   trb1
> > > > 		   ...
> > > > 	free_slot->trb31(Link TRB)
> > > > 
> > > > After end transfer and receiving the XferNotReady event, trb_left is
> > > > caculated as 1 which is wrong, and no TRB will be primed to the
> > > > endpoint.
> > > > 
> > > > The root cause is free_slot is not increased the same way as busy_slot.
> > > > When busy_slot is increased by one, it checks if points to a link TRB
> > > > after increasement, but free_slot checks it before increasement.
> > > > free_slot should behave the same as busy_slot to make the trb_left
> > > > caculation correct.
> > > > 
> > > > Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> > > > Signed-off-by: Jiebing Li <jiebing.li@intel.com>
> > > > ---
> > > >  drivers/usb/dwc3/gadget.c |    8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > index 54da8c8..2ebe82b 100644
> > > > --- a/drivers/usb/dwc3/gadget.c
> > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > @@ -828,10 +828,6 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
> > > >  			length, last ? " last" : "",
> > > >  			chain ? " chain" : "");
> > > >  
> > > > -	/* Skip the LINK-TRB on ISOC */
> > > > -	if (((dep->free_slot & DWC3_TRB_MASK) == DWC3_TRB_NUM - 1) &&
> > > > -			usb_endpoint_xfer_isoc(dep->endpoint.desc))
> > > > -		dep->free_slot++;
> > > >  
> > > >  	trb = &dep->trb_pool[dep->free_slot & DWC3_TRB_MASK];
> > > 
> > > I have a feeling this has a negative side effect of letting us use the
> > > link TRB for data transfer... I mean, if we don't increment free_slot
> > > before accessing our trb_pool, we have no way to skip link trb on this
> > > access here.
> > After every free_slot++ Link TRB is checked and increased if appropriate,
> > this guarantees you next time access free_slot, it can't be a Link
> > TRB.
> 
> right, next access will be fine, but you're forgetting about current
> access.
> 
The current access is the next access relative to last access.
So if the first access is fine, succeeding accesses should be fine.
And the first access happens on when the free_slot points to slot 1
which is not a link trb. 

> > > How did you find the bug ? do you have good instructions on how to
> > > reproduce it ? How did you test the patch and for how long ?
> > The bug is reproduced on Android with f_audio_source.c enabled, which
> > has an isoc-in endpoint keeps sending audio data to host in an interval
> > of 1 ms. Normally, you need to run for 12+ hours to hit the issue.
> > So I think you can just run some isoc transfers for a long time to
> > reproduce it. To accelarte the reproducing, you can run some concurrent
> > data transfer as well, so the possibility to meet missed interval error
> > is larger.
> > 
> > The patch is tested for basic functionality like enumeration, data
> > transfers. For this bug, it was tested for 20+ hours.
> 
> thanks, g_audio loop should be fine.
> 
np.


Regards
Jincan
