Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaESLpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:45:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37970 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbaESLpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:45:02 -0400
Date: Mon, 19 May 2014 17:13:45 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
Cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>,
        Yuan Hang <hang.yuan@intel.com>, Li Jiebing <jiebing.li@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: dwc3: gadget: check link trb after free_slot is
 increased
Message-ID: <20140519114345.GB2718@pratyush-vbox>
References: <20140515215757.GD16153@intel.com>
 <20140515153757.GB7360@saruman.home>
 <20140516155013.GE16153@intel.com>
 <20140516124106.GA20386@saruman.home>
 <20140516144718.GI16153@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140516144718.GI16153@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-19_01:2014-05-19,2014-05-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:47:18PM +0800, Zhuang Jin Can wrote:
> Hi,
> On Fri, May 16, 2014 at 07:41:06AM -0500, Felipe Balbi wrote:
> > On Fri, May 16, 2014 at 11:50:13PM +0800, Zhuang Jin Can wrote:
> > > > On Fri, May 16, 2014 at 05:57:57AM +0800, Zhuang Jin Can wrote:
> > > > > In ISOC transfers, when free_slot points to the last TRB (i.e. Link
> > > > > TRB), and all queued requests meet Missed Interval Isoc error, busy_slot
> > > > > points to trb0.
> > > > > 	busy_slot->trb0
> > > > > 		   trb1
> > > > > 		   ...
> > > > > 	free_slot->trb31(Link TRB)
> > > > > 
> > > > > After end transfer and receiving the XferNotReady event, trb_left is
> > > > > caculated as 1 which is wrong, and no TRB will be primed to the
> > > > > endpoint.
> > > > > 
> > > > > The root cause is free_slot is not increased the same way as busy_slot.
> > > > > When busy_slot is increased by one, it checks if points to a link TRB
> > > > > after increasement, but free_slot checks it before increasement.
> > > > > free_slot should behave the same as busy_slot to make the trb_left
> > > > > caculation correct.
> > > > > 

Reviewing the code it seems that observation of Zhuang Jin Can is
correct. Year back I did lot of testing with isoc and even with missed
path, but may be I could not get this issue because I would not have
landed into a situation where last missed TRB is 31st.

Infact, you could be able to see that bug even in other case, like
submit 31 back to back ep_queue request from gadget and then wait as
if no application data is available. They all have been transmitted to
host and callback has been called for all of them. After some time
application is ready with new data. So when gadget does ep_queue of
this new data you should be able to see this issue.

Reviewed-by: Pratyush Anand <pratyush.anand@st.com>

Regards
Pratyush
been 
> > > > > Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> > > > > Signed-off-by: Jiebing Li <jiebing.li@intel.com>
> > > > > ---
> > > > >  drivers/usb/dwc3/gadget.c |    8 ++++----
> > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > index 54da8c8..2ebe82b 100644
> > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > @@ -828,10 +828,6 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
> > > > >  			length, last ? " last" : "",
> > > > >  			chain ? " chain" : "");
> > > > >  
> > > > > -	/* Skip the LINK-TRB on ISOC */
> > > > > -	if (((dep->free_slot & DWC3_TRB_MASK) == DWC3_TRB_NUM - 1) &&
> > > > > -			usb_endpoint_xfer_isoc(dep->endpoint.desc))
> > > > > -		dep->free_slot++;
> > > > >  
> > > > >  	trb = &dep->trb_pool[dep->free_slot & DWC3_TRB_MASK];
> > > > 
> > > > I have a feeling this has a negative side effect of letting us use the
> > > > link TRB for data transfer... I mean, if we don't increment free_slot
> > > > before accessing our trb_pool, we have no way to skip link trb on this
> > > > access here.
> > > After every free_slot++ Link TRB is checked and increased if appropriate,
> > > this guarantees you next time access free_slot, it can't be a Link
> > > TRB.
> > 
> > right, next access will be fine, but you're forgetting about current
> > access.
> > 
> The current access is the next access relative to last access.
> So if the first access is fine, succeeding accesses should be fine.
> And the first access happens on when the free_slot points to slot 1
> which is not a link trb. 
> 
> > > > How did you find the bug ? do you have good instructions on how to
> > > > reproduce it ? How did you test the patch and for how long ?
> > > The bug is reproduced on Android with f_audio_source.c enabled, which
> > > has an isoc-in endpoint keeps sending audio data to host in an interval
> > > of 1 ms. Normally, you need to run for 12+ hours to hit the issue.
> > > So I think you can just run some isoc transfers for a long time to
> > > reproduce it. To accelarte the reproducing, you can run some concurrent
> > > data transfer as well, so the possibility to meet missed interval error
> > > is larger.
> > > 
> > > The patch is tested for basic functionality like enumeration, data
> > > transfers. For this bug, it was tested for 20+ hours.
> > 
> > thanks, g_audio loop should be fine.
> > 
> np.
> 
> 
> Regards
> Jincan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
