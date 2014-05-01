Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaEALu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:50:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaEALu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:50:56 -0400
Date: Thu, 1 May 2014 13:50:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140501115042.GC13658@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
 <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
 <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1404302310530.6261@ionos.tec.linutronix.de>
 <20140501102602.GP11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501102602.GP11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 12:26:02PM +0200, Peter Zijlstra wrote:
> On Thu, May 01, 2014 at 12:51:33AM +0200, Thomas Gleixner wrote:
> > And that's the issue which puzzles us. Let's look at what we expect:
> > 
> > Now the trace shows a different story:
> > 
> >      perf_fuzzer-4387  [001]  1802.628659: sys_enter:            NR 298 (69bb58, 0, ffffffff, 12, 0, 0)
> 
> That's a per-cpu event (.pid = -1, .cpu = 12), they don't get inherited,
> so the only thing keeping it alive is the fd the child got. So
> exit_files() killing this thing makes perfect sense.
> 
> Onwards to find another funny.

awk '/alloc/ { 
	for(i=1; i<=NF; i++) { 
		if ($i ~ /^ptr=/) { 
			ptr=gensub("^ptr=","","g",$i); 
			if (ptr ~ /nil/) break; 
			seen[ptr]=1; 
			m = ++memory[ptr]; 
			if (m != 1) { 
				printf "alloc: %d ptr=%s\n", m, ptr; 
				memory[ptr] = 0; 
			} 
			break; 
		}
	}
}
/free/ { 
	for(i=1; i<=NF; i++) { 
		if ($i ~ /^ptr=/) { 
			ptr=gensub("^ptr=","","g",$i); 
			if (ptr ~ /nil/) 
				break; 
			m = --memory[ptr]; 
			if (m != 0) { 
				memory[ptr] = 0; 
				s = seen[ptr]; 
				seen[ptr] = 1; 
				if (!s) 
					break; 
				printf "free: %d ptr=%s\n", m, ptr; 
			} 
			break; 
		}
	}
}' bug.out | less

Gives fun things like:

alloc: 2 ptr=0xffff880118fda000
free: -1 ptr=0xffff880118fda000
alloc: 2 ptr=0xffff880118fda000


And if we then look at

grep ptr=0xffff880118fda000 bug.out | less

We find lovely bits such as:

     perf_fuzzer-4387  [001]  1773.427175: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff880118fda000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
     ksoftirqd/6-38    [006]  1773.457770: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff880118fda000
          <idle>-0     [007]  1774.020378: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff880118fda000
     perf_fuzzer-4387  [000]  1774.096354: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff880118fda000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO


That's almost half a second between the double free, Vince, is your TSC
solid?

# grep sched_clock_stable /proc/sched_debug 
sched_clock_stable()                    : 1

Should tell, if that's a 0 reading the trace becomes a whole lot more
'interesting'.


