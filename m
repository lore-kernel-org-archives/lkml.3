Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaAVKqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:46:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaAVKqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:46:07 -0500
Date: Wed, 22 Jan 2014 11:45:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122104532.GJ31570@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEF495.2020304@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:28:37PM -0500, Sasha Levin wrote:
> On 12/12/2013 09:08 AM, Peter Zijlstra wrote:
> 
> This patch seems to be causing an issue with booting a KVM guest. It seems that it
> causes the time to go random during early boot process:
> 
> 	[    0.000000] Initmem setup node 30 [mem 0x12ee000000-0x138dffffff]
> 	[    0.000000]   NODE_DATA [mem 0xcfa42000-0xcfa72fff]
> 	[    0.000000]     NODE_DATA(30) on node 1
> 	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
> 	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
> 	[    0.000000]     NODE_DATA(31) on node 1
> 	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> 	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
> 	[133538.294040] Zone ranges:
> 	[133538.294338]   DMA      [mem 0x00001000-0x00ffffff]
> 	[133538.294804]   DMA32    [mem 0x01000000-0xffffffff]
> 	[133538.295223]   Normal   [mem 0x100000000-0x142fffffff]
> 	[133538.295670] Movable zone start for each node
> 
> Looking at the code, initially I though that the problem is with:
> 
> 	+void set_sched_clock_stable(void)
> 	+{
> 	+       if (!sched_clock_stable())
> 	+               static_key_slow_dec(&__sched_clock_stable);
> 	+}
> 	+
> 	+void clear_sched_clock_stable(void)
> 	+{
> 	+       /* XXX worry about clock continuity */
> 	+       if (sched_clock_stable())
> 	+               static_key_slow_inc(&__sched_clock_stable);
> 	+}
> 
> I think the jump label inc/dec is reversed here. We would want to inc
> it when enabling and dec when disabling, no?

I got terribly confused with that static_key trainwreck. I know I
definitely got it wrong a few times.

I helped write the jump label stuff, but the current interface is
horrible, I really couldn't figure out what is what anymore :-(

The current code seems to work for me in that my machine ends up with
sched_clock_stable() == true and when I call clear_sched_clock_stable()
it returns false and nothing explodes.

> However, trying to reverse the two didn't help. I was still seeing the
> same odd behaviour.

I got a crash when I flipped the inc and dec ;-)

> I tried doing a simple conversion to using a simple var like before,
> which looks like this:

<snip>

> This has corrected the issue:
> 
> 	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
> 	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
> 	[    0.000000]     NODE_DATA(31) on node 1
> 	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> 	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
> 	[    0.000000] Zone ranges:
> 	[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> 	[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> 	[    0.000000]   Normal   [mem 0x100000000-0x142fffffff]
> 	[    0.000000] Movable zone start for each node
> 	[    0.000000] Early memory node ranges
> 		[ timing is correct for the rest of the boot]
> 
> At this point, I thought that there's something up with jump labels
> being used this early (?) and tried compiling with
> CONFIG_JUMP_LABELS=n, this didn't solve the issue.
> 
> This makes me thing there's something different related to jumplabels
> we're missing, as the no-jumplabel config should be very similar to
> the patch I did above, I just can't figure out what it is.

Does this kvm thing have sched_clock_stable==true ever? My machine ends
up setting set_sched_clock_stable() very early indeed, in
early_init_intel().

I suspect what happens is that the way I wrote it; the jump_label is
true per boot, so sched_clock_stable() == true. My initial
set_sched_clock_stable() call then does nothing as the state is already
good.

KVM doesn't do this and runs with sched_clock_stable()==true for a
while, detects the TSC really isn't stable and calls
clear_sched_clock_stable() and you get this jump in time.

Now the next patch 'fixes' this patch by adding a workqueue to delay the
actual jump_label poke; that fixed a few wierd lockdep errors.

But the above is still obviously wrong for machines that do not call
set_sched_clock_stable() on boot.

Ho humm.
