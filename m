Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3GRGw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:52:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59609 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab3GRGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:52:54 -0400
Date: Thu, 18 Jul 2013 08:52:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Hunter <ahh@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] [PATCH] x86: avoid per_cpu for APIC id tables
Message-ID: <20130718065249.GA17622@gmail.com>
References: <1374090073-1957-1-git-send-email-ahh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374090073-1957-1-git-send-email-ahh@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Hunter <ahh@google.com> wrote:

> Hi, I have a patch (following) that modifies handling of APIC id tables,
> trading a small amount of space in the (NR_CPUS - nr_cpu_ids) >> 0 case for
> faster accesses and slightly better cache layout (as APIC ids are mostly used
> cross-cpu.)  I'm not an APIC expert so I'd appreciate some eyes on this, but
> it shouldn't change any behavior whatsoever.  Thoughts? (We're likely to merge
> this internally even if upstream judges the space loss too much of a cost, so
> I'd like to know if there's some other problem I've missed that this causes.)
> 
> I've tested this cursorily in most of our internal configurations but not in
> any particularly exotic hardware/config.
> 
> 
> From e6bf354c05d98651e8c27f96582f0ab56992e58a Mon Sep 17 00:00:00 2001
> From: Andrew Hunter <ahh@google.com>
> Date: Tue, 16 Jul 2013 16:50:36 -0700
> Subject: [PATCH] x86: avoid per_cpu for APIC id tables
> 
> DEFINE_PER_CPU(var) and friends go to lengths to arrange all of cpu
> i's per cpu variables as contiguous with each other; this requires a
> double indirection to reference a variable.
> 
> For data that is logically per-cpu but
> 
> a) rarely modified
> b) commonly accessed from other CPUs
> 
> this is bad: no writes means we don't have to worry about cache ping
> pong, and cross-CPU access means there's no cache savings from not
> pulling in remote entries.  (Actually, it's worse than "no" cache
> savings: instead of one cache line containing 32 useful APIC ids, it
> will contain 3 useful APIC ids and much other percpu data from the
> remote CPU we don't want.)  It's also slower to access, due to the
> indirection.
> 
> So instead use a flat array for APIC ids, most commonly used for IPIs
> and the like.  This makes a measurable improvement (up to 10%) in some
> benchmarks that heavily stress remote wakeups.
> 
> The one disadvantage is that we waste 8 bytes per unused CPU (NR_CPUS
> - actual). But this is a fairly small amount of memory for reasonable
> values of NR_CPUS.
> 
> Tested: builds and boots, runs a suite of wakeup-intensive test without failure.

1)

To make it easier to merge such patches it would also be nice to integrate 
a remote wakeup performance test into 'perf bench sched pipe', so that we 
can measure it more easily. You can also cite the results in your 
changelog.

Currently 'perf bench sched pipe' measures 'free form' context-switch 
overhead:

 $ perf bench sched pipe
 # Running sched/pipe benchmark...
 # Executed 1000000 pipe operations between two tasks

     Total time: 11.453 [sec]

      11.453781 usecs/op
          87307 ops/sec

Which is typically a mixture of remote and local wakeups.

This needs only minimal modification to always measure remote wakeups: I 
suspect binding the first benchmark task to the first CPU, and the second 
benchmark task to the last CPU should give a pretty good remote wakeup 
scenario. You can find the code in tools/perf/bench/sched-pipe.c.

2)

As to the merits of the patch, on typical 64-bit x86 it replaces two APIC 
ID related percpu arrays:

-DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
-DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid, BAD_APICID);

with tightly packed [NR_CPUS] arrays:

+u16 x86_cpu_to_apicid[NR_CPUS];
+u16 x86_bios_cpu_apicid[NR_CPUS];

The other change in the patch:

 -DEFINE_EARLY_PER_CPU_READ_MOSTLY(int, x86_cpu_to_logical_apicid, BAD_APICID);
 +int x86_cpu_to_logical_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = BAD_APICID };

only affects 32-bit or SGI/UV systems. Is the system you are testing on 
32-bit or SGI/UV? How many CPUs does your test system have and how many 
CPUs do you utilize in your remote-wakeup test?

The main difference is the ordering of the variables as they are laid out 
in memory. With per CPU we'll essentially end up with having the two 
fields next to each other, modulo other percpu variables getting 
inbetween. On x86 defconfig the current unpatched layout is:

000000000000b020 D x86_bios_cpu_apicid
000000000000b022 D x86_cpu_to_apicid

These will sit in the same 64-byte cacheline, but the ID mappings of all 
CPUs will be isolated from each other, into separate cachelines.

With your changes the IDs will pack tighter but are spread out, so for a 
single cache-cold remote wakeup a CPU needs to fetch not one but two (or
on 32-bit, three) separate cachelines to wake up a particular remote CPU.

The main benefit is that in the cache-hot case fewer cachelines are needed 
to do random remote wakeups: instead of 2 (or 3) IDs packed into a single 
cacheline, the patch allows denser packing into cache.

I'm wondering, why does this result in a 10% difference? Is the 
indirection cost perhaps the bigger effect? Is there maybe some other 
effect from changing the layout?

Also, if the goal is to pack better then we could do even better than 
that: we could create a 'struct x86_apic_ids':

  struct x86_apic_ids {
	u16 bios_apicid;
	u16 apicid;
	u32 logical_apicid;	/* NOTE: does this really have to be 32-bit? */
  };

and put that into an explicit, [NR_CPUS] array. This preserves the tight 
coupling between fields that PER_CPU offered, requiring only a single 
cacheline fetch in the cache-cold case, while also giving efficient, 
packed caching for cache-hot remote wakeups.

[ Assuming remote wakeups access all of these fields in the hot path to 
  generate an IPI. Do they? ]

Also, this NR_CPUS array should be cache-aligned and read-mostly, to avoid 
false sharing artifacts. Your current patch does not do either.

Thanks,

	Ingo
