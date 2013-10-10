Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3JJTEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:04:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:4653 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754093Ab3JJTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:04:47 -0400
Date: Thu, 10 Oct 2013 15:04:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010150444.51f9c929@gandalf.local.home>
In-Reply-To: <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
References: <20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
	<20131010094355.6f75e5a2.akpm@linux-foundation.org>
	<20131010165337.GT3081@twins.programming.kicks-ass.net>
	<20131010131305.58558079@gandalf.local.home>
	<20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
	<20131010183409.GP13848@laptop.programming.kicks-ass.net>
	<CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 11:49:15 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:
 
> Oh, and I'm sure there are several users that currently depend on
> being able to sleep over get_online_cpu's.  But I'm pretty sure it's
> "several", not "hundreds", and I think we could fix them up.

I'm wondering if we can have a for_each_cpu() that only disables
preemption in the loop. That is, each iteration will enable preemption,
but the loop itself will guarantee that the current cpu to process
still exists.

	rcu_read_lock();
	for_each_cpu(cpu, mask) {
		rcu_read_unlock();
		rcu_read_lock();
		if (!cpu_online(cpu))
			continue;
		[...]
	}
	rcu_read_unlock();

That way expensive loops wont stop the current CPU to process all
online CPUs.

Of course, it will miss a CPU that comes online. But it would still
need to handle the case of a CPU coming online after the final
put_online_cpus(), so I'm not sure that's a problem.

-- Steve
