Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaJOSgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:36:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:60219 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaJOSgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:36:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,726,1406617200"; 
   d="scan'208";a="619309727"
Date: Wed, 15 Oct 2014 11:36:33 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: be more verbose on ERRATIC_ERROR interrupt
Message-ID: <20141015183633.GD4529@psi-dev26.jf.intel.com>
References: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141015050022.GA2378@saruman>
 <20141015165718.GB4529@psi-dev26.jf.intel.com>
 <20141015170145.GC4529@psi-dev26.jf.intel.com>
 <20141015170610.GC15770@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015170610.GC15770@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:06:10PM -0500, Felipe Balbi wrote:
> On Wed, Oct 15, 2014 at 10:01:45AM -0700, David Cohen wrote:
> > On Wed, Oct 15, 2014 at 09:57:18AM -0700, David Cohen wrote:
> > > On Wed, Oct 15, 2014 at 12:00:22AM -0500, Felipe Balbi wrote:
> > > > Hi,
> > > > 
> > > > On Tue, Oct 14, 2014 at 01:15:05PM -0700, David Cohen wrote:
> > > > > ERRATIC_ERROR interrupt is an event that needs more attention from
> > > > > developers than currently implemented, since this indicates a serious
> > > > > stability issue. The only way to get warned about it is by selecting the
> > > > > maximum driver's verbosity.
> > > > > 
> > > > > This patch increases a bit the error's verbosity.
> > > > > 
> > > > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > > > ---
> > > > >  drivers/usb/dwc3/gadget.c | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > > > index 3818b26bfc05..132e761d62e4 100644
> > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > @@ -2484,7 +2484,8 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
> > > > >  		dev_vdbg(dwc->dev, "Start of Periodic Frame\n");
> > > > >  		break;
> > > > >  	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
> > > > > -		dev_vdbg(dwc->dev, "Erratic Error\n");
> > > > > +		WARN_ON_ONCE(1);
> > > > > +		dev_dbg(dwc->dev, "Erratic Error\n");
> > > > 
> > > > how about:
> > > > 		WARN_ONCE(true, "Erratic Error\n");
> > > > 
> > > > instead ?
> > > 
> > > When erratic error event happens, in my experience it is usually
> > > followed but many of them in a row. It may end up too verbose.
> > 
> > Oops, sorry for my confusion. I read WARN(), not WARN_ONCE() when I read
> > for the first time :)
> > 
> > I let the dev_dbg() because it may be useful to get all the occurrences
> > in case debug is enabled. But WARN_ONCE() is fine too if you prefer.
> 
> We might WARN_ONCE() and forcibly disconnect from host as the platform
> worn't work anymore after Erratic Error happens. Then just make that
> clear with "Erratic Error: disconnecting from host\n" or something like
> that.

That works.
I assume calling dwc3_gadget_disconnect_interrupt() from
DWC3_DEVICE_EVENT_ERRATIC_ERROR should be enough to disconnect the
gadget and propagate the status to userspace.

> 
> The only way to fix erratic error (by fixing code - probably PHY driver)
> will require rebooting the platform anyway. At a minimum, you'd have to
> unload and reload dwc3.ko, just make sure (if you can reproduce erratic
> error easily) modprobe -r dwc3 && modprobe dwc3 still causes dwc3 to
> reconnect to host.

It does. Forcing soft reset on whole IP is how databook describes to
solve it.

Br, David

> 
> cheers
> 
> -- 
> balbi


