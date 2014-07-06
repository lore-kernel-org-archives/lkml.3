Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaGFSnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:43:14 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56407 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749AbaGFSnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:43:12 -0400
Date: Sun, 6 Jul 2014 19:42:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        akpm@linux-foundation.org, mingo@kernel.org, sboyd@codeaurora.org,
        k.khlebnikov@samsung.com, u.kleine-koenig@pengutronix.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140706184255.GW21766@n2100.arm.linux.org.uk>
References: <CAA-nRyp5pPC2qZs7RhAXJdXaK_k4fKNZuq=yRTSTPLQsgPxqxQ@mail.gmail.com> <20140705190105.GR21766@n2100.arm.linux.org.uk> <CAA-nRyo2Ts3o_B1jMS8vvLJanf13u=u2WyoqnL8bCF5svOOCew@mail.gmail.com> <20140705192634.GT21766@n2100.arm.linux.org.uk> <CAA-nRyqHXCBCzKcK83UnS64f_wKcWObzui2xamt=ayVDKX9zEA@mail.gmail.com> <CAA-nRyo3T+JLpfE6M260Ws+Ddu4z3TS2fQy5sv_dETMTcYFscQ@mail.gmail.com> <20140706153542.GU21766@n2100.arm.linux.org.uk> <CAA-nRyppv-LruJK0NySQ_VGORP1+M1w++=k5rqeiC15Wc6Ks9g@mail.gmail.com> <20140706172857.GV21766@n2100.arm.linux.org.uk> <CAA-nRyqaOoXKs9OfaLGObDAG3=Gey+7UoOYdjLUfv45kprqdFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-nRyqaOoXKs9OfaLGObDAG3=Gey+7UoOYdjLUfv45kprqdFg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 11:59:31PM +0530, pawandeep oza wrote:
> Hi,
> 
> thanks for your elaborate inputs.
> 
> So, the above code path has at least _three_ potentially very serious
> bugs in it:
> 
> 1. calling i2c_transfer() beneath pm_power_off() due to scheduling
>    possibility
> 
> oza: this I have already fixed in the code by making i2c in poll mode in
> shutdown case.
> so it doesnt do schedule_timeout(.....) and it doesnt sleep anymore.
> so bug 1 is no more there.
> I have a patch, Can I submit that ?
> 
> 2. calling i2c_transfer() beneath pm_power_off() due to deadlock on
>    bus access
> 
> 3. calling the runtime PM callbacks beneath pm_power_off() which result
>    in interrupts being unexpectedly re-enabled.
> 
> if I understood right, you are suggesting to register driver shutdown
> method ?
> where syscore_shutdown will call them in order to solve 2 and 3 ?
> if thats the case, I believe it is too early to trigger poweroff
> at syscore_shutdown, because kernel_power_off calls it very early.

You didn't understand right.

Firstly, there's no need to get involved with the syscore stuff at all.
All drivers in the system are notified of a clean system shutdown via
a function in their driver structure.

For example, struct platform_driver has a "shutdown" function pointer
in it.  This is called fairly early in the shutdown sequence where it
is still permitted to sleep, where preemption is possible, interrupts
are still enabled etc.

This is where you need to ensure that (2) and (3) are solved in the
I2C driver.

What I'm *not* saying is to use the driver shutdown function pointer
as a replacement for pm_power_off(), as it would be too early, before
the system has finished quiescing.  You still need to do stuff in
pm_power_off().

What you need to do is to _prepare_ the system for pm_power_off() so
that it is in a sane state where you _can_ safely access the I2C bus.

> what I would still think is: even if we make the things right in driver,
> still the solution would not be generic until make changes in uppermost
> layer which is machine_power_off.

No changes are needed there.

> if we cut the preemption from there, the things will be taken care at the
> highest generic kernel layer rather then individual driver taking care of
> the same.

Please, get this idea of disabling preemption out of you head.  It is
a /complete/ fallicy that the bug(s) you are seeing are caused by it.
It's merely a symptom of an incorrectly thought out process.


The steps required to power off may have been correctly identified,
but what has been totally missed by whoever started hitting that
keyboard is to think about the _context_ which the code gets run.

The answer is *not* to change the context in which the code is run.

As I've already said, disabling preemption does NOT fix the problems.
It papers over the problem you have found, but leaves other problems.

Fix code properly.  Never paper over problems.  Papering over problems
is not an acceptable bug fixing strategy.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
