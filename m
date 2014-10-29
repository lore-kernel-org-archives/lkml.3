Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303AbaJ2PyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:54:20 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58196 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467AbaJ2PyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:54:18 -0400
Date: Wed, 29 Oct 2014 16:51:09 +0100
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
Message-ID: <20141029155109.GH2265@localhost>
References: <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <20141029131020.GB12379@n2100.arm.linux.org.uk>
 <20141029132244.GD2265@localhost>
 <20141029152502.GA20565@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029152502.GA20565@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:25:02AM -0700, Guenter Roeck wrote:
> On Wed, Oct 29, 2014 at 02:22:44PM +0100, Johan Hovold wrote:
> > On Wed, Oct 29, 2014 at 01:10:20PM +0000, Russell King - ARM Linux wrote:
> > > On Wed, Oct 29, 2014 at 01:34:18PM +0100, Johan Hovold wrote:
> > > > On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
> > > > > And how is that different from having a set of power-off handlers, and
> > > > > reporting when each individual one fails?  Don't you want to know if
> > > > > your primary high priority reboot handler fails, just as much as you
> > > > > want to know if your final last-resort power-off handler fails?
> > > > 
> > > > Good point. Failed power-off should probably be logged by the power-off
> > > > call chain implementation (which seems to makes notifier chains a bad
> > > > fit).
> > > > 
> > > > And what about any power-off latencies? Should this always be dealt with
> > > > in the power-off handler?
> > > > 
> > > > Again, if it's predictable and high, as in the OMAP RTC case, it should
> > > > go in the handler. But what if it's just normal bus latencies
> > > > (peripheral busses, i2c, or whatever people may come up with)?
> > > > 
> > > > Should there always be a short delay before calling the next handler?
> > > 
> > > If the handler has determined that it has failed, then why delay before
> > > trying the next handler?  At the point it has decided it has failed,
> > > surely that's after it has waited sufficient time to determine that
> > > failure?
> > 
> > The current handlers we have are not expecting any other handler to be
> > run after they return. My question was whether all these handlers should
> > get a short mdelay added to them (e.g. to compensate for bus latencies)
> 
> Some of them do add a delay.

Yes, but not all.

> > or if this could be done in the power-off handler (e.g. before printing
> > the error message).
> > 
> That might make sense, but it would have to be configurable, since the delay
> is platform specific and power-off handler does not know how long to wait
> (the longest delay I have seen is 10 seconds).

We've already concluded in this thread that such delays must be encoded
in the actual handler (even if it's an argument to the power-off call
chain code). The only exception should be generic handlers such as
gpio-poweroff, which may need to define different delays depending on
board. This could of course just be an argument of the corresponding DT
node.

My question above was if it was reasonable to add some generic short
delay after calling each power-off handler to handle short power-off
latencies (e.g. bus latencies) so that not every handler needs an
explicit delay.

> > > > > Or different from having no power-off handlers.
> > > > 
> > > > That is actually quite different, as in that case we call machine_halt
> > > > instead (via kernel_halt).
> > > 
> > > Today, ARM does exactly what x86 does.  If there's no power off handler
> > > registered, machine_power_off() shuts down other CPUs and returns.
> > 
> > No, if there are no power-off handlers registered, kernel/reboot.c will
> > never call machine_power_off:
> > 
> > 	/* Instead of trying to make the power_off code look like
> > 	 * halt when pm_power_off is not set do it the easy way.
> > 	 */
> > 	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
> > 		cmd = LINUX_REBOOT_CMD_HALT;
> > 
> > So in that case on arm, a system-halted message is printed, and we never
> > return to user-space.
> > 
> Some architectures do that, or go into an endless loop. Others do return
> from machine_power_off.

Please re-read my comment and the code above. machine_power_off is never
called if there's no handler registered.

Some archs machine_power_off to spin on failed power-off (i.e. when
there is a handler), something which I've mentioned a few times already
in this thread.

> Having a well defined behavior would be nice
> (such as dumping an error mesasge and calling machine_halt if
> machine_power_off returns). Only question would be where to put it.
> kernel_power_off() might be a good place; only problem is that there
> are direct callers of machine_power_off().

Indeed. Adding an error message to the power-off handler call chain code
would solve the first problem as I mentioned before.

Then it's mostly a matter of whether we care about consistency, and
either remove the indefinite spins from those non-x86/non-arm arches, or
prevent the latter (and some others) from returning to user-space.

I'm inclined to having all arches return to user space on failed
power-off, even if it means systemd cannot call reboot() from PID 1.

Johan
