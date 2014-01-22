Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaAVSfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:35:42 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:58961 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaAVSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:35:40 -0500
Date: Wed, 22 Jan 2014 19:35:38 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122183538.GA389@x4>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
 <20140122120048.GB389@x4>
 <20140122120757.GL31570@twins.programming.kicks-ass.net>
 <20140122122609.GA392@x4>
 <20140122123022.GN31570@twins.programming.kicks-ass.net>
 <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DFD50E.800@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.22 at 09:26 -0500, Sasha Levin wrote:
> On 01/22/2014 08:14 AM, Markus Trippelsdorf wrote:
> > On 2014.01.22 at 13:30 +0100, Peter Zijlstra wrote:
> >> >On Wed, Jan 22, 2014 at 01:26:09PM +0100, Markus Trippelsdorf wrote:
> >>> > >On 2014.01.22 at 13:07 +0100, Peter Zijlstra wrote:
> >>>> > > >On Wed, Jan 22, 2014 at 01:00:48PM +0100, Markus Trippelsdorf wrote:
> >>>>> > > > >FYI it happens on real hardware on my machine:
> >>>>> > > > >...
> >>>>> > > > >[    0.000000] Hierarchical RCU implementation.
> >>>>> > > > >[    0.000000] NR_IRQS:4352 nr_irqs:712 16
> >>>>> > > > >[    0.000000] spurious 8259A interrupt: IRQ7.
> >>>>> > > > >[    0.000000] Console: colour VGA+ 80x25
> >>>>> > > > >[    0.000000] console [tty0] enabled
> >>>>> > > > >[    0.000000] hpet clockevent registered
> >>>>> > > > >[    0.000000] tsc: Fast TSC calibration using PIT
> >>>>> > > > >[    0.003333] tsc: Detected 3210.681 MHz processor
> >>>>> > > > >[   60.375238] Calibrating delay loop (skipped), value calculated using timer frequency.. 6423.91 BogoMIPS (lpj=10702270)
> >>>>> > > > >[   60.375240] pid_max: default: 32768 minimum: 301
> >>>>> > > > >[   60.375259] Mount-cache hash table entries: 256
> >>>>> > > > >[   60.375373] tseg: 0000000000
> >>>>> > > > >[   60.375377] CPU: Physical Processor ID: 0
> >>>>> > > > >[   60.375377] CPU: Processor Core ID: 0
> >>>>> > > > >[   60.375378] mce: CPU supports 6 MCE banks
> >>>>> > > > >[   60.375382] LVT offset 0 assigned for vector 0xf9
> >>>>> > > > >[   60.375384] process: using AMD E400 aware idle routine
> >>>>> > > > >[   60.375386] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
> >>>> > > >
> >>>> > > >Should have always happened like that I think. From the log it looks
> >>>> > > >like the moment we switch from jiffies to actual TSC in
> >>>> > > >arch/x86/kernel/tsc.c:sched_clock().
> >>>> > > >
> >>>> > > >I don't think I changed the logic there, just switched from a condition
> >>>> > > >to a jump_label.
> >>> > >
> >>> > >Well, v3.13 was fine. So it's definitely a regression. But it may be
> >>> > >another issue. I will try to bisect later.
> >> >
> >> >OK, weird, I'll see if I can spot anything.
> > Unfortunately the issue is unbisectable (but the remaining commits are
> > all yours):
> 
> I've actually bisected it previously by fixing the build errors manually, and that took me
> to this patch you see in the subject line :)

But this is a different issue. I've bisected it to:

commit 20d1c86a57762f0a33a78988e3fc8818316badd4
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Nov 29 15:40:29 2013 +0100

    sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs

Reverting the commit "fixes" the issue:
...
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 3211.075 MHz processor
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 6424.73 BogoMIPS (lpj=10703583)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000026] Mount-cache hash table entries: 256
[    0.000139] tseg: 0000000000
[    0.000143] CPU: Physical Processor ID: 0
[    0.000144] CPU: Processor Core ID: 0
[    0.000145] mce: CPU supports 6 MCE banks
[    0.000148] LVT offset 0 assigned for vector 0xf9
[    0.000151] process: using AMD E400 aware idle routine
[    0.000152] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
...

-- 
Markus
