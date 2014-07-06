Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaGFR3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:29:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56337 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751898AbaGFR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:29:16 -0400
Date: Sun, 6 Jul 2014 18:28:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, sboyd@codeaurora.org,
        k.khlebnikov@samsung.com, u.kleine-koenig@pengutronix.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140706172857.GV21766@n2100.arm.linux.org.uk>
References: <CAA-nRyoO_NmrD8aRa3OyVXz4b133Fxi0=biGXTzSPDuSuNJJxQ@mail.gmail.com> <20140705181015.GQ21766@n2100.arm.linux.org.uk> <CAA-nRyp5pPC2qZs7RhAXJdXaK_k4fKNZuq=yRTSTPLQsgPxqxQ@mail.gmail.com> <20140705190105.GR21766@n2100.arm.linux.org.uk> <CAA-nRyo2Ts3o_B1jMS8vvLJanf13u=u2WyoqnL8bCF5svOOCew@mail.gmail.com> <20140705192634.GT21766@n2100.arm.linux.org.uk> <CAA-nRyqHXCBCzKcK83UnS64f_wKcWObzui2xamt=ayVDKX9zEA@mail.gmail.com> <CAA-nRyo3T+JLpfE6M260Ws+Ddu4z3TS2fQy5sv_dETMTcYFscQ@mail.gmail.com> <20140706153542.GU21766@n2100.arm.linux.org.uk> <CAA-nRyppv-LruJK0NySQ_VGORP1+M1w++=k5rqeiC15Wc6Ks9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-nRyppv-LruJK0NySQ_VGORP1+M1w++=k5rqeiC15Wc6Ks9g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 09:22:56PM +0530, pawandeep oza wrote:
> this is the stack trace I was analyzing...please find it below.
> 
>  #0 [<c072df48>] (__schedule) from [<c072e3a0>]
> 
>  #1 [<c072e3a0>] (preempt_schedule) from [<c072f244>]
>  #2 [<c072f244>] (_raw_spin_unlock_irq) from [<c0394468>]
>  #3 [<c0394468>] (__rpm_callback) from [<c03944b0>]
>  #4 [<c03944b0>] (rpm_callback) from [<c03957bc>]
> 
>  #5 [<c03957bc>] (rpm_resume) from [<c0395d18>]
>  #6 [<c0395d18>] (__pm_runtime_resume) from [<c04675b4>]
>  #7 [<c04675b4>] (sh_mobile_i2c_xfer) from [<c0460390>]
>  #8 [<c0460390>] (__i2c_transfer) from [<c0462094>]
> 
>  #9 [<c0462094>] (i2c_transfer) from [<c03b2738>]
>  #10 [<c03b2738>] (d2153_i2c_write_device) from [<c03b08b0>]
>  #11 [<c03b08b0>] (d2153_write) from [<c03b1574>]
>  #12 [<c03b1574>] (d2153_reg_write) from [<c03b2490>]
> 
>  #13 [<c03b2490>] (d2153_system_poweroff) from [<c0011278>]
>  #14 [<c0011278>] (machine_power_off) from [<c0047d58>]
>  #15 [<c0047d58>] (kernel_power_off) from [<c0048420>]
>  #16 [<c0048420>] (sys_reboot) from [<c0010240>]

Thanks.

Right, so from the above, we can see that d2153_system_poweroff() is
hooked into pm_power_off hook, which is called with IRQs disabled.
So, the context which d2153_system_poweroff() is called from is
_fundamentally_ one where scheduling and preemption are _not_
permitted.

d2153_system_poweroff calls into the I2C code, which then calls the
shmobile I2C driver.  The shmobile I2C driver then calls into the
PM runtime stuff, which ends up re-enabling interrupts.  This is the
first bug with the code, and is the one that you're hitting.  However,
this is not the only bug.

The second bug here is that i2c_transfer() is permitted to sleep,
waiting for the transaction to complete.  As I've already stated, and
as I've said above, scheduling is not allowed with interrupts disabled.
What this means is that calling i2c_transfer() beneath pm_power_off()
is not permitted.

However, there's more problems here: what if one of the secondary CPUs
which received the IPI was in the middle of using that very same I2C
bus.  This _can_ deadlock no matter how you try and sort out that
preemption and/or scheduling problem - because the I2C bus may already
be in use but the CPU which was using it has been halted off via a STOP
IPI, preventing it from ever completing the transaction.

So, the above code path has at least _three_ potentially very serious
bugs in it:

1. calling i2c_transfer() beneath pm_power_off() due to scheduling
   possibility
2. calling i2c_transfer() beneath pm_power_off() due to deadlock on
   bus access
3. calling the runtime PM callbacks beneath pm_power_off() which result
   in interrupts being unexpectedly re-enabled.

I suspect that part of the problem here is that this "d2153" thing is a
PMIC, and you need to write to it via I2C to tell it to turn the power
off.

Some of these problems can be mitigated:

(2) can be worked around - the I2C driver receives a shutdown callback
when the system is being rebooted or powered off.  The I2C driver can
ensure that the bus is idle (if not, wait for the bus to become idle)
before _safely_ disabling the I2C interface against further transactions.

(3) can also be solved by the mechanism given above - the shutdown
callback /can/ safely call the runtime PM helpers there, and, therefore,
can lock the I2C interfaces into an active state for the shutdown or
reboot operation.

That means that when we hit pm_power_off(), we can be _sure_ that, firstly,
no one else is using the I2C bus, and secondly, it is not in a runtime
suspended state.

However, that also means that /we/ can't use i2c_transfer() either - and
in fact, that's a /good/ thing because i2c_transfer() may sleep on us,
causing bug (1).

So what we need is an out-of-band method for this - we don't have that
though.  This is a problem which would need to be solved to the I2C
maintainers satisfaction to make this kind of thing operate reliably.


PS, it would've been nice had the email addresses not had typos.  I
finally remembered to fix them and delete the one which bounces.  I've
also added the shmobile people.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
