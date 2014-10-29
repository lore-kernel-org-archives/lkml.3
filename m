Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaJ2NZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:25:55 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42712 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbaJ2NZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:25:53 -0400
Date: Wed, 29 Oct 2014 14:22:44 +0100
From: Johan Hovold <johan@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141029132244.GD2265@localhost>
References: <20141024194442.GG11455@saruman>
 <20141024195532.GF19377@localhost>
 <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <20141029131020.GB12379@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029131020.GB12379@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 01:10:20PM +0000, Russell King - ARM Linux wrote:
> On Wed, Oct 29, 2014 at 01:34:18PM +0100, Johan Hovold wrote:
> > On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
> > > And how is that different from having a set of power-off handlers, and
> > > reporting when each individual one fails?  Don't you want to know if
> > > your primary high priority reboot handler fails, just as much as you
> > > want to know if your final last-resort power-off handler fails?
> > 
> > Good point. Failed power-off should probably be logged by the power-off
> > call chain implementation (which seems to makes notifier chains a bad
> > fit).
> > 
> > And what about any power-off latencies? Should this always be dealt with
> > in the power-off handler?
> > 
> > Again, if it's predictable and high, as in the OMAP RTC case, it should
> > go in the handler. But what if it's just normal bus latencies
> > (peripheral busses, i2c, or whatever people may come up with)?
> > 
> > Should there always be a short delay before calling the next handler?
> 
> If the handler has determined that it has failed, then why delay before
> trying the next handler?  At the point it has decided it has failed,
> surely that's after it has waited sufficient time to determine that
> failure?

The current handlers we have are not expecting any other handler to be
run after they return. My question was whether all these handlers should
get a short mdelay added to them (e.g. to compensate for bus latencies)
or if this could be done in the power-off handler (e.g. before printing
the error message).

> > > Or different from having no power-off handlers.
> > 
> > That is actually quite different, as in that case we call machine_halt
> > instead (via kernel_halt).
> 
> Today, ARM does exactly what x86 does.  If there's no power off handler
> registered, machine_power_off() shuts down other CPUs and returns.

No, if there are no power-off handlers registered, kernel/reboot.c will
never call machine_power_off:

	/* Instead of trying to make the power_off code look like
	 * halt when pm_power_off is not set do it the easy way.
	 */
	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
		cmd = LINUX_REBOOT_CMD_HALT;

So in that case on arm, a system-halted message is printed, and we never
return to user-space.

> > > Here's the x86 code:
> > > 
> > > void machine_power_off(void)
> > > {
> > >         machine_ops.power_off();
> > > }
> > > 
> > > struct machine_ops machine_ops = {
> > >         .power_off = native_machine_power_off,
> > > ...
> > > 
> > > static void native_machine_power_off(void)
> > > {
> > >         if (pm_power_off) {
> > >                 if (!reboot_force)
> > >                         machine_shutdown();
> > >                 pm_power_off();
> > >         }
> > >         /* A fallback in case there is no PM info available */
> > >         tboot_shutdown(TB_SHUTDOWN_HALT);
> > > }
> > > 
> > > void tboot_shutdown(u32 shutdown_type)
> > > {
> > >         void (*shutdown)(void);
> > > 
> > >         if (!tboot_enabled())
> > >                 return;
> > > 
> > > See - x86 can very well just fall straight back out of machine_power_off()
> > > if there's no pm_power_off() hook and tboot is not enabled.
> > 
> > I never doubted that, but is the right thing to do? Not all arches do it
> > that way.
> 
> Well, the biggest question there is: if the power off or restart syscall
> fails, what is the _generic_ non-architecture action which is supposed to
> happen?
> 
> Whatever the answer is to that question, that action should be performed
> by the _generic_ non-architecture code, rather than having the same
> implementation spread across all 30 architectures which the kernel
> supports today.

I fully agree.

> > And what about the killing of init? Shall we simply consider that a
> > systemd bug? 
> > 
> > 	case LINUX_REBOOT_CMD_POWER_OFF:
> > 		kernel_power_off();
> > 		do_exit(0);
> > 		break;
> > 
> > If power-off fails (for whatever reason), do_exit(0) will trigger a
> > panic when called from PID 1.
> 
> Oh, systemd calls this from PID1?  I guess that's another reason to hate
> systemd with vitriol.  :)  SysVinit and upstart implementations call it
> from the "halt" command, which is itself normally run from a script,
> which totally avoids that problem.

Yeah, that's why I never noticed the missing mdelay.

> I'm quite sure the insane systemd lobby will scream that this is a kernel
> bug and will want to change it somehow, just like they want to change the
> kernel in soo many other silly ways.

Will be interesting to follow. :)

Johan
