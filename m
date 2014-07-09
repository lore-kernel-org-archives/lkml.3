Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaGIPMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:12:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20415 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756405AbaGIPMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:12:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+X36Xs2cvasMEvMWvegP9s
Date: Wed, 9 Jul 2014 08:12:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mika.westerberg@linux.intel.com
Subject: Re: [RFC PATCH 3/4] tty: serial: 8250 core: add runtime pm
Message-ID: <20140709151242.GY28884@atomide.com>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
 <1404491651-1388-3-git-send-email-bigeasy@linutronix.de>
 <20140707142056.46f61cf9@alan.etchedpixels.co.uk>
 <20140709111705.GR28884@atomide.com>
 <53BD291D.3040307@linutronix.de>
 <20140709114837.GU28884@atomide.com>
 <53BD38D3.2000204@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD38D3.2000204@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140709 05:45]:
> On 07/09/2014 01:48 PM, Tony Lindgren wrote:
> >>> So we can certainly enable this in a generic way, however, this
> >>> can only be done under the following conditions:
> > 
> > Sorry forgot to mention why I think this can now be done in a
> > generic way, that's because we have now runtime PM in Linux.
> 
> I have a problem to follow here. I need set SET_RUNTIME_PM_OPS in
> .pm member of the driver. This is around for a while now maybe it
> wasn't around by the omap-serial was written but this doesn't matter
> now.

Right, the lack of runtime PM was one of the reasons for doing
omap-serial earlier.
 
> As for the dw driver (as one of the gnomes points out) it shouldn't
> matter because it is enabled / disabled based on 8250's pm callback. So
> while the device is active and the 8250 core grabs & puts the
> reference, nothing should change. Still a double check from Mika
> wouldn't hurt.

OK
 
> If I understand the omap case correct (and please correct me if I don't)
> the 8250-omap driver assumes that the device can go to sleep
> after the probe function completes. This does not happen
> because pm_runtime_set_autosuspend_delay() sets the delay to -1.

Correct. And once the timeout is enabled, the serial driver
autoidles itself using runtime PM based on the timeout value.

And also please note that for runtime PM the wake-up events need
to be always enabled, so the device_may_wakeup() checks should
be only implemented for suspend and resume. I think I got that
corrected for most part in omap-serial.c recently, but knowing
that might reduce the confusion a bit :)

> If the user changes this via sysfs, then the device might go to sleep
> and the IP block switched of. Therefore we need the runtime pm
> callbacks in 8250-core before the register access because we can't
> access the it otherwise.

Correct. And it's not just the 8250 idle state, it's the whole SoC
getting powered down during idle and rebooted when waking to a
timer interrupt or device interrupt.

> The core should wake us up in case there is incoming RX action to be
> handled so we can restore register's content. And for TX we have the
> proper pm hooks.

The piece of code that runs in that case is the interrupt handler
for the serial port. That handler could be separate from the
regular serial port handler if necessary though and do a callback
to the serial core code. But I don't know if that's needed.

> The dw driver also only disables / enables the clock. So they don't
> lose the register's content like omap does. Thus they don't need the
> one struct I exported.

Right, enabling and disabling the clock is done too for omaps
when the SoC hits retention idle.
 
> I don't think that it makes sense to make this restore/save part
> generic if this what it is about. OMAP at least has a few registers
> more to take care of and set-termios is already different.

Yeah, and that can be done later on if others need it.
 
> >>> 1. We can save and restore the serial register context and detect
> >>>    when context was lost in the serial driver. The context loss
> >>>    can be detected by looking at some registers that are only
> >>>    initialized during init.
> >>
> >> A register check on restore context? DLL+DLH might be a good hint here
> >> since its value should be >0 in the running case.
> > 
> > OK yeah that would be a generic way to do it potentially ;)
> > 
> > Note that all the context_loss_cnt stuff in omap-serial.c can
> > then be ignored, that's still only needed for the omap3 legacy
> > mode booting case and won't be needed much longer.
> 
> Ah. The way the code reads, it is just an optimization in case the core
> didn't go off after all so we don't have to restore the registers.

Well the interconnect code knows when the context was lost on omaps,
but there's currently no Linux generic API for that. And since we
can do it by checking some registers, it's best to implement it that
way.
 
> >>> 2. There's a way for the serial RX pin to wake the SoC. On some
> >>>    omaps there's a separate pin specific wake-up interrupt that
> >>>    can be used for that.
> >>
> >> That one would be handled by omap separately.
> > 
> > OK great.
> >  
> >>> 3. The serial PM features must be only enabled if requested by
> >>>    the user via sysfs. Typically extra latency and loss of the
> >>>    first RX character occur which is not acceptable to most
> >>>    applications.
> >>
> >> Unless I'm mistaken the omap driver now initializes the timeout to -1.
> >> So nothing happens unless this is enabled separately.
> > 
> > Yes that's the only safe approach so the serial port behaves in
> > the standard Linux way unless specifically requested by the
> > user.
> > 
> > Regards,
> > 
> > Tony
> 
> Sebastian
