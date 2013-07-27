Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3G0Pji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:39:38 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:20845 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3G0Pje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:39:34 -0400
Date: Sat, 27 Jul 2013 17:02:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: linux@roeck-us.net, thierry.reding@gmail.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 3/4] hwmon: (lm90) add support to handle IRQ
Message-ID: <20130727170212.29297696@endymion.delvare>
In-Reply-To: <51E8DFB2.9070701@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
 <1373615287-18502-4-git-send-email-wni@nvidia.com>
 <20130718175822.62c358bf@endymion.delvare>
 <51E8DFB2.9070701@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Sorry for the late reply.

On Fri, 19 Jul 2013 14:41:54 +0800, Wei Ni wrote:
> On 07/18/2013 11:58 PM, Jean Delvare wrote:
> > First of all, how is the chip wired on your system? You are using an
> > NCT1008, right? Which output of the chip is connected to your interrupt
> > line, THERM or ALERT/THERM2? ALERT is normally used for SMBus Alert but
> > I suppose it could be used for an interrupt too. THERM and THERM2 OTOH
> > are comparator outputs, they stay low as long as the temperature are
> > above the therm limits. Reading the status register won't bring them
> > back up as I understand it, and contrary to the ALERT output, they
> > can't be masked. Won't this result in an interrupt flood if using
> > IRQF_TRIGGER_LOW? Have you tested your code already?
> 
> Let me explain why I want to add the IRQ thread.
> In our tegra30 platform, we use an NCT1008, and in our downstream tree,
> it programmed as following:
> 1. The pin THERM is connected to the PMIC, we will set the THERM limit
> in the initialization, once the this limit is tripped, it will trigged
> the PMIC, and the PMIC will shutdown the system immediately.

OK, this is what the chip is designed for, good.

> 2. The pin ALERT/THERM2 is configured as ALERT, and it is connected to
> the interrupt line.

Why don't you use the SMBus alert mechanism then? It is already
implemented and allows you to reuse the interrupt of the SMBus
controller.

Of course this is a question for the hardware designers, not you... If
the board uses a separate interrupt pin for the NCT1008's ALERT output,
then the driver has to handle that interrupt explicitly, as done in your
patch.

One thing which worries me though is this explanation in the NCT1008
datasheet:

"The ALERT interrupt latch is not reset by reading the
status register. It resets when the ALERT output has been
serviced by the master reading the device address, provided
the error condition has gone away and the status register flag
bits are reset."

This suggests that connecting the ALERT output to a separate interrupt
pin will not work, as the ALERT output will never be de-asserted even
if the fault conditions are gone and the status register was read. But
as you say this is how your system is supposed to work, can you explain
how it can work?

> In the platform init, we will prepare some trip
> temps, such as 20C, 40C,60C, 80C, and we will set 20C to the
> remote-low-temp-limit, and set 40C to remote-high-temp-limit. When the
> temperature exceed this rang, it will interrupt the system, then we will
> update the low/high limit to next rang, for example, if the temp raise
> to 50C, we will set 40C to low-limit, and set 60C to hight-limit, then
> we will run the throttle functions, and update cooling state.

Hu ho, I have seen this kind of design in the past, and I must say I
don't quite like it. Moving critical thermal management handling to the
software makes me feel unsafe. System thermal safety should not rely on
the OS IMHO. It is best handled by the hardware, or if that can't be
done, by the BIOS. And these limit updates are tricky, they could fail
and then you're in trouble. Imagine for example that another chip on
the SMBus hugs the bus and delays or even plain prevents the change of
limits...

But once again I guess you're not responsible for this.

Another problem with this design, even if no such problem happens, is
that the limits are user(-space)-writable in the lm90 driver, while
with your design these limits are under full control of the platform
management code. You definitely don't want the user to come and adjust
the limits, this could result in overheating of the system. So, do you
have a plan to optionally switch limits to read only in the lm90
driver? If not, how do you intend to solve the problem?

The more I think about it, the more I wonder if a custom thermal driver
wouldn't be better for your case. Exposing a few read-only values to
user-space through the thermal/hwmon bridge would IMHO make more sense
than cluttering the lm90 driver with conditionals to limit what it
exposes to user-space.

> We wish to upstream these codes, but as you know, it's difficult to use
> current lm90.c and thermal framework to implement it, and these codes
> related many other things, such as throttling cpufreq, other clock freq.
> So at first, I want to update the lm90.c, so that I can add it to the
> thermal fw and use interrupt handler easily. And at the same time I
> followed the thermal framework thread, there has new infrastructure
> posted, which is more easy to add lm90 to thermal fw.

Don't get me wrong, I'm very happy with your efforts to upstream your
code, this is very welcome. And I am also very happy that you split it
into small chunks which are easier to review. But I also need to know
the big picture to see where you're ultimately going.

> > (...)
> > For a real system, if the THERM output is connected to an interrupt line
> > (instead of directly to a fan controller) I would expect the platform
> > to provide a callback to handle thermal events and take whatever
> > appropriate measure is needed (e.g. throttling.) Just logging the
> > problem won't save the system, by the time someone looks at the log it
> > might be too late.
> 
> In our downstream tree, we write a new driver nct1008.c, whci can handle
> these interrupts and all other things, but as you know this driver can't
> be upstreamed, because there already has the lm90.c :).
> Anyway I think this patch is the first step of the implementation.

I'm curious how the nct1008 driver "handles these interrupts." IMHO
only the platform code knows what needs to be done upon reception of an
interrupt, in particular in your case where you'll do some magic with the
limit registers. There's no way this can be hard-coded in a hwmon
driver, lm90 or any other.

-- 
Jean Delvare
