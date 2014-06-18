Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaFRVMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:12:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbaFRVMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:12:51 -0400
Date: Wed, 18 Jun 2014 23:12:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <20140618210757.GU4669@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1406182310070.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz> <20140529000909.GC6507@localhost.localdomain> <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz> <20140610164641.GD1951@localhost.localdomain> <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
 <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz> <20140618143612.GC4669@linux.vnet.ibm.com> <CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com> <20140618162117.GM4669@linux.vnet.ibm.com> <alpine.LNX.2.00.1406182232390.2303@pobox.suse.cz>
 <20140618210757.GU4669@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Paul E. McKenney wrote:

> > >  	/* Complain about tasks blocking the grace period. */
> > > @@ -1044,8 +1041,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
> > >  	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
> > >  		jiffies - rsp->gp_start,
> > >  		(long)rsp->gpnum, (long)rsp->completed, totqlen);
> > > -	if (!trigger_all_cpu_backtrace())
> > > -		dump_stack();
> > > +	rcu_dump_cpu_stacks(rsp);
> > 
> > This is prone to producing not really consistent stacktraces though, 
> > right? As the target task is still running at the time the stack is being 
> > walked, it might produce stacktraces that are potentially nonsensial.
> 
> If a CPU is stuck, the stack trace down to where it is stuck is
> likely to be static.  But yes, there is some potential for confusion.
> My (admittedly limited) rcutorture testing produced sensible stack traces,
> but things might be a bit uglier in other situations.

I agree that it might work nicely for RCU stall detector indeed. I was 
looking for solution that'd work nicely both for RCU and for sysrq-l 
(where we can't rely on processess being stuck in any way).

> > How about sending NMI to the target CPU, so that the task is actually 
> > stopped, but printing its stacktrace from the CPU that detected the stall 
> > while it's stopped?
> > 
> > That way, there is no printk()-from-NMI, but also the stacktrace is 
> > guaranteed to be self-consistent.
> 
> I believe that this was what Steven was suggesting, though by using
> tracing.  

My understanding was that Steven is suggesting using trace_printk() from 
NMI.

> Of course, if my current approach isn't up to the job, then something 
> like this general approach would look quite good.

Thanks,

-- 
Jiri Kosina
SUSE Labs
