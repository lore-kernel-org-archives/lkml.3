Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaEAIpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:45:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:53325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbaEAIpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:45:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,964,1389772800"; 
   d="scan'208";a="532928258"
Date: Thu, 1 May 2014 16:44:52 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: gadget: giveback request if start transfer
 fail
Message-ID: <20140501204452.GD30575@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140501063608.GA30575@intel.com>
 <20140430195829.GA3839@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430195829.GA3839@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,

On Wed, Apr 30, 2014 at 02:58:29PM -0500, Felipe Balbi wrote:
> On Thu, May 01, 2014 at 02:36:08AM -0400, Zhuang Jin Can wrote:
> > At least we should giveback the current request to the
> > gadget. Otherwise, the gadget will be stuck without knowing
> > anything.
> > 
> > It was oberved that the failure can happen if the request is
> > queued when the run/stop bit of controller is not set.
> 
> why is your gadget queueing any requests before calling ->udc_start() ?
> 
> A better question, what modification have you done to udc-core.c which
> broke this ? udc-core *always* calls ->udc_start() by the time you load
> a gadget driver so this case will *never* happen. Whatever modification
> you did, broke this assumption and I will *not* accept this patch
> because the bug is elsewhere and *not* in mainline kernel.
> 
It's found in Android using kernel 3.10.20. Android has its own
usb_composite_driver usb/gadget/android.c (not in mainline), and it
allows userspace to disconnect the pullup (i.e clear run/stop bit in dwc3)
and remove the gadget functions like adb, mtp and then add new functions
like rndis, acm. The problem is when you disconnect the pullup, a gadget
maybe in the middle of queuing a request, and result in the "start
transfer cmd failure". I think this is also a common issue for other
usb_composite_drivers too. Normally, if one of the gadget deactivate its
own function, the pullup will be disconnected, other gadgets won't get
notified until their requests are failed. So it makes dwc3 more robust
to deal with these situations.

> > Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> > ---
> >  drivers/usb/dwc3/gadget.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 70715ee..8d0c3c7 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -1000,9 +1000,7 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep, u16 cmd_param,
> >  		 * here and stop, unmap, free and del each of the linked
> >  		 * requests instead of what we do now.
> >  		 */
> > -		usb_gadget_unmap_request(&dwc->gadget, &req->request,
> > -				req->direction);
> > -		list_del(&req->list);
> > +		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
> >  		return ret;
> >  	}
> >  
> > -- 
> > 1.7.9.5
> > 

Jincan
