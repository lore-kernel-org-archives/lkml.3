Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaANTHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:07:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaANTHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:48 -0500
Date: Tue, 14 Jan 2014 14:06:57 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
In-Reply-To: <20140114141406.GD7572@laptop.programming.kicks-ass.net>
Message-ID: <alpine.LRH.2.02.1401141400030.19206@file01.intranet.prod.int.rdu2.redhat.com>
References: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au> <20140114141406.GD7572@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Jan 2014, Peter Zijlstra wrote:

> On Tue, Jan 14, 2014 at 02:26:27PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/cpufreq/speedstep-lib.c: In function 'speedstep_get_freqs':
> > drivers/cpufreq/speedstep-lib.c:467:2: error: implicit declaration of function 'preempt_check_resched' [-Werror=implicit-function-declaration]
> >   preempt_check_resched();
> >   ^
> > 
> > Caused by commit 62b94a08da1b ("sched/preempt: Take away
> > preempt_enable_no_resched() from modules") interacting with commit
> > 24e1937b2386 ("speedstep-smi: enable interrupts when waiting") from the
> > pm tree.

Try adding #include <linux/preempt.h> to speedstep-lib.c. Does it help?

> I think that pm commit is a very good example of why the sched/preempt
> patch is a very good idea.
> 
> Also that Changelog fails to explain why enabling interrupts helps. What
> interrupt is required for progress, and how does it make the progress
> happen.

There is no explanation. It's hardware issue and I have no documentation 
for the hardware.


The general problem is that if there are bus-master transfers running (or 
possibly for other hardware reasons), the CPU refuses to change frequency. 
You can wait a little bit and retry and maybe you succeed changing the 
frequency next time.

If you enable interrupts, wait, disable interrupts and retry, you may 
succeed. If you keep interrupts disabled and retry, you never succeed, no 
matter how long do you wait. I found it experimentally, I don't know 
reason for that.

Mikulas
