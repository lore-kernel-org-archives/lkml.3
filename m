Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab3E1K0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:26:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:50844 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab3E1K0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:26:41 -0400
Date: Tue, 28 May 2013 12:26:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "eag0628@gmail.com" <eag0628@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: WARNING: at kernel/smp.c:385 smp_call_function_many
In-Reply-To: <5195242A.4040007@oracle.com>
Message-ID: <alpine.LFD.2.02.1305281210400.4220@ionos>
References: <5170602E.3050206@oracle.com> <27240C0AC20F114CBF8149A2696CBE4AC1B56C@SHSMSX101.ccr.corp.intel.com> <51708FE5.6000301@oracle.com> <5195242A.4040007@oracle.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013, Sasha Levin wrote:
> On 04/18/2013 08:29 PM, Sasha Levin wrote:
> > Hi Liu,
> > 
> > On 04/18/2013 08:10 PM, Liu, Chuansheng wrote:
> >>> It seems that with commit "smp: Give WARN()ing when calling
> >>>> smp_call_function_many()/single() in serving irq" I'm getting a bunch of these:
> >> This patch gives the warning even when the smp_call_function_many() is called in softirq context,
> >> because it will bring the possible deadlock cases, the example is below:
> >> CPUA                            CPUB
> >>                                 spin_lock(&spinlock)
> >>                                 Any irq coming, call the irq handler
> >>                                 irq_exit()
> >> spin_lock_irq(&spinlock)
> >> <== Blocking here due to
> >> CPUB hold it
> >>                                   __do_softirq()
> >>                                     run_timer_softirq()
> >>                                       timer_cb()
> >>                                         call smp_call_function_many()
> >>                                           send IPI interrupt to CPUA
> >>                                             wait_csd()
> >>
> >> Then both CPUA and CPUB will be deadlocked here.
> > 
> > Right.

Well, that's only true if LOCKDEP is enabled. The !LOCKDEP case
reenables interrupts if the lock is contended.

> > So commit f55a6faa3 ("hrtimer: Provide clock_was_set_delayed()") followed by one
> > of the commits that used clock_was_set_delayed() may trigger the deadlock you've
> > described. (cc John Stultz...)

I'll have a look. It's non trivial to fix :(

Thanks,

	tglx
