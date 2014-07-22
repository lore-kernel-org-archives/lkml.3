Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaGVI7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:59:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33858 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbaGVI7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:59:07 -0400
Date: Tue, 22 Jul 2014 10:59:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140722085902.GB6462@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
 <20140721224039.5d8b5faa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140721224039.5d8b5faa@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:40:39PM -0400, Steven Rostedt wrote:
> Your patch inspired me to write this hack. I was curious to know how
> the TSCs of my boxes were with respect to each other, and wanted to get
> an idea. Maybe there's a better way, but I decided to waste an hour and
> write this hack up.
> 
> Here's what it does. It creates the file /sys/kernel/debug/rdtsc_test,
> and when you read it, it does some whacky things.
> 
> 1) A table is set up with the number of possible CPUs. The cable
> consists of: index, TSC count, CPU.
> 
> 2) A atomic variable is set to the number of online CPUS.
> 
> 3) An IPI is sent to each of the other CPUs to run the test.
> 
> 4) The test decrements the atomic, and then spins until it reaches zero.
> 
> 5) The caller of smp_call_function() then calls the test iself, being
> the last to decrement the counter causing it to go to zero and all CPUs
> then fight for a spinlock.
> 
> 6) When the spin lock is taken, it records which place it was in (order
> of spinlock taken, and records its own TSC. Then it releases the lock.
> 
> 7) It then records in the table where its position is, its TSC counter
> and CPU number.
> 
> 
> Finally, the read will show the results of the table. Looks something
> like this:
> 
> # cat /debug/rdtsc_test 
>     0)  1305910016816  (cpu:5)
>     1)  1305910017550  (cpu:7)
>     2)  1305910017712  (cpu:1)
>     3)  1305910017910  (cpu:6)
>     4)  1305910018042  (cpu:2)
>     5)  1305910018226  (cpu:3)
>     6)  1305910018416  (cpu:4)
>     7)  1305910018540  (cpu:0)
> 
> As long as the TSC counts are in order of the index, the TSC is moving
> forward nicely. If they are not in order, then the TSCs are not in sync.
> 
> Yes, this is a hack, but I think it's a somewhat useful hack.

I think so too, especially if one would like to take a look at the TSCs
and how they're looking like after, say, suspend cycle, a long machine
runtime when there is suspicion that some SMM might've been entered or so...

However, I think you can do all that from luserspace, even though you'd
have to do more dancing like pinning threads to cpus and those threads
would have to synchronize back on rdtsc_start after having read the TSC,
i.e.

	while(atomic_read(&rdtsc_start) != num_online_cpus())
		cpu_relax();

so that you can make sure they all have read the TSC at least once and
nothing gets reordered.

It might work if I'm not missing something.

Doing it in the kernel is much easier with all that ring0 functionality
present. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
