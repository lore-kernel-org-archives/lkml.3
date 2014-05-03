Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaEBQGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:06:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:27756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbaEBQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="525023568"
Date: Sat, 3 May 2014 00:05:41 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: gadget: giveback request if start transfer
 fail
Message-ID: <20140503040541.GC19925@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140501063608.GA30575@intel.com>
 <20140430195829.GA3839@saruman.home>
 <20140501204452.GD30575@intel.com>
 <20140501151328.GB6355@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501151328.GB6355@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 01, 2014 at 10:13:28AM -0500, Felipe Balbi wrote:
> On Thu, May 01, 2014 at 04:44:52PM -0400, Zhuang Jin Can wrote:
> > On Wed, Apr 30, 2014 at 02:58:29PM -0500, Felipe Balbi wrote:
> > > On Thu, May 01, 2014 at 02:36:08AM -0400, Zhuang Jin Can wrote:
> > > > At least we should giveback the current request to the
> > > > gadget. Otherwise, the gadget will be stuck without knowing
> > > > anything.
> > > > 
> > > > It was oberved that the failure can happen if the request is
> > > > queued when the run/stop bit of controller is not set.
> > > 
> > > why is your gadget queueing any requests before calling ->udc_start() ?
> > > 
> > > A better question, what modification have you done to udc-core.c which
> > > broke this ? udc-core *always* calls ->udc_start() by the time you load
> > > a gadget driver so this case will *never* happen. Whatever modification
> > > you did, broke this assumption and I will *not* accept this patch
> > > because the bug is elsewhere and *not* in mainline kernel.
> > > 
> > It's found in Android using kernel 3.10.20. Android has its own
> > usb_composite_driver usb/gadget/android.c (not in mainline), and it
> 
> so you found something on an old kernel using an out-of-tree gadget
> driver.
> 
> > allows userspace to disconnect the pullup (i.e clear run/stop bit in dwc3)
> > and remove the gadget functions like adb, mtp and then add new functions
> > like rndis, acm. The problem is when you disconnect the pullup, a gadget
> > maybe in the middle of queuing a request, and result in the "start
> > transfer cmd failure". I think this is also a common issue for other
> 
> Android gadget needs to learn how to cope with that.
> 
Agree.

> > usb_composite_drivers too. Normally, if one of the gadget deactivate its
> > own function, the pullup will be disconnected, other gadgets won't get
> > notified until their requests are failed. So it makes dwc3 more robust
> > to deal with these situations.
> 
> Right, but Android gadget can run on top of several other UDCs and you
> want to have a single one of them cope with android's bug ?
> 
> You'd be better off getting google to accept a bugfix to the android
> gadget, since that's where the problem lies.
> 
I agree. I'll try to push the fix to google.
It's really hard to fix the race condition (for me), as any gadget or
/sys/class/udc/soft_connect can just disconnect the pullup anytime they
want. The only thing I can do is giving back the request to the
gadget if the condition happens.

Jincan
