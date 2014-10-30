Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbaJ3KE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:04:57 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40084 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbaJ3KEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:04:55 -0400
Date: Thu, 30 Oct 2014 11:01:43 +0100
From: Johan Hovold <johan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Johan Hovold <johan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141030100143.GA7846@localhost>
References: <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <20141029131020.GB12379@n2100.arm.linux.org.uk>
 <20141029132244.GD2265@localhost>
 <20141029152502.GA20565@roeck-us.net>
 <20141029155109.GH2265@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029155109.GH2265@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:51:09PM +0100, Johan Hovold wrote:
> On Wed, Oct 29, 2014 at 08:25:02AM -0700, Guenter Roeck wrote:
> > On Wed, Oct 29, 2014 at 02:22:44PM +0100, Johan Hovold wrote:
> > > On Wed, Oct 29, 2014 at 01:10:20PM +0000, Russell King - ARM Linux wrote:
> > > > On Wed, Oct 29, 2014 at 01:34:18PM +0100, Johan Hovold wrote:
> > > > > On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
> > > > > > And how is that different from having a set of power-off handlers, and
> > > > > > reporting when each individual one fails?  Don't you want to know if
> > > > > > your primary high priority reboot handler fails, just as much as you
> > > > > > want to know if your final last-resort power-off handler fails?
> > > > > 
> > > > > Good point. Failed power-off should probably be logged by the power-off
> > > > > call chain implementation (which seems to makes notifier chains a bad
> > > > > fit).
> > > > > 
> > > > > And what about any power-off latencies? Should this always be dealt with
> > > > > in the power-off handler?
> > > > > 
> > > > > Again, if it's predictable and high, as in the OMAP RTC case, it should
> > > > > go in the handler. But what if it's just normal bus latencies
> > > > > (peripheral busses, i2c, or whatever people may come up with)?
> > > > > 
> > > > > Should there always be a short delay before calling the next handler?
> > > > 
> > > > If the handler has determined that it has failed, then why delay before
> > > > trying the next handler?  At the point it has decided it has failed,
> > > > surely that's after it has waited sufficient time to determine that
> > > > failure?
> > > 
> > > The current handlers we have are not expecting any other handler to be
> > > run after they return. My question was whether all these handlers should
> > > get a short mdelay added to them (e.g. to compensate for bus latencies)
> > 
> > Some of them do add a delay.
> 
> Yes, but not all.
> 
> > > or if this could be done in the power-off handler (e.g. before printing
> > > the error message).
> > > 
> > That might make sense, but it would have to be configurable, since the delay
> > is platform specific and power-off handler does not know how long to wait
> > (the longest delay I have seen is 10 seconds).
> 
> We've already concluded in this thread that such delays must be encoded
> in the actual handler (even if it's an argument to the power-off call
> chain code). The only exception should be generic handlers such as
> gpio-poweroff, which may need to define different delays depending on
> board. This could of course just be an argument of the corresponding DT
> node.

There probably should be a generic device-tree property for this, even
if some delays would be device specific (e.g. the two second delay for
omap rtc).

But on top of that, external latencies would be quite board specific.
The PMIC on the Beaglebone black adds a 50ms deglitch time, for
instance.

> My question above was if it was reasonable to add some generic short
> delay after calling each power-off handler to handle short power-off
> latencies (e.g. bus latencies) so that not every handler needs an
> explicit delay.

I just added a 500ms margin to the OMAP rtc power-off handler. That
should be more than enough, and perhaps something like that could be a
default in the power-off call chain. Consider that arch-arm has a 1s
grace period before reporting failed reboot already today.

Johan
