Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaJAF2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:28:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47931 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaJAF2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:28:37 -0400
Date: Wed, 1 Oct 2014 07:28:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tuan Bui <tuan.d.bui@hp.com>
Cc: linux-kernel@vger.kernel.org, dbueso@suse.de, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
Message-ID: <20141001052832.GA32248@gmail.com>
References: <1412120999.2941.11.camel@u64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412120999.2941.11.camel@u64>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tuan Bui <tuan.d.bui@hp.com> wrote:

> Subject: [RFC PATCH] Perf Bench: Locking Microbenchmark
> 
> In response to this thread https://lkml.org/lkml/2014/2/11/93, 
> this is a micro benchmark that stresses locking contention in 
> the kernel with creat(2) system call by spawning multiple 
> processes to spam this system call.  This workload generate 
> similar results and contentions in AIM7 fserver workload but 
> can generate outputs within seconds.
> 
> With the creat(2) system call the contention vary on what locks 
> are used in the particular file system. I have ran this 
> benchmark only on ext4 and xfs file system.
> 
> Running the creat workload on ext4 show contention in the mutex 
> lock that is used by ext4_orphan_add() and ext4_orphan_del() to 
> add or delete an inode from the list of inodes. At the same 
> time running the creat workload on xfs show contention in the 
> spinlock that is used by xsf_log_commit_cil() to commit a 
> transaction to the Committed Item List.
> 
> Here is a comparison of this benchmark with AIM7 running 
> fserver workload at 500-1000 users along with a perf trace 
> running on ext4 file system.
> 
> Test machine is a 8-sockets 80 cores Westmere system HT-off on 
> v3.17-rc6.
> 
> 	AIM7		AIM7		perf-bench	perf-bench
> Users	Jobs/min	Jobs/min/child	Ops/sec		Ops/sec/child
> 500	119668.25	239.34		104249		208
> 600	126074.90	210.12		106136		176
> 700	128662.42	183.80		106175		151
> 800	119822.05	149.78		106290		132
> 900	106150.25	117.94		105230		116
> 1000	104681.29	104.68		106489		106
> 
> Perf trace for AIM7 fserver:
> 14.51%	reaim  		[kernel.kallsyms]	[k] osq_lock
> 4.98%	reaim  		reaim			[.] add_long
> 4.98%	reaim  		reaim			[.] add_int
> 4.31%	reaim  		[kernel.kallsyms]	[k] mutex_spin_on_owner
> ...
> 
> Perf trace of perf bench creat
> 22.37%	locking-creat  [kernel.kallsyms]	[k] osq_lock
> 5.77%	locking-creat  [kernel.kallsyms]	[k] mutex_spin_on_owner
> 5.31%	locking-creat  [kernel.kallsyms]	[k] _raw_spin_lock
> 5.15%	locking-creat  [jbd2]			[k] jbd2_journal_put_journal_head
> ...

Very nice!

If you compare an strace of AIM7 steady state and 'perf bench 
lock' steady state, is it comparable, i.e. do the syscalls and 
other behavioral patterns match up?

> +'locking'::
> +        Locking stressing benchmarks.
> +
>  'all'::
>  	All benchmark subsystems.
>  
> @@ -213,6 +216,11 @@ Suite for evaluating wake calls.
>  *requeue*::
>  Suite for evaluating requeue calls.
>  
> +SUITES FOR 'locking'
> +~~~~~~~~~~~~~~~~~~
> +*creat*::
> +Suite for evaluating locking contention through creat(2).

So I'd display it in the help text prominently that it's a 
workload similar to the AIM7 workload.

> +static const struct option options[] = {
> +	OPT_UINTEGER('s', "start", &start_nr_threads, "Numbers of processes to start"),
> +	OPT_UINTEGER('e', "end", &end_nr_threads, "Numbers of process to end"),
> +	OPT_UINTEGER('i', "increment", &increment_threads_by, "Number of threads to increment)"),
> +	OPT_UINTEGER('r', "runtime", &bench_dur, "Specify benchmark runtime in seconds"),
> +	OPT_END()
> +};

Is this the kind of parameters that AIM7 takes as well?

In any case, this is a very nice benchmarking utility.

Thanks,

	Ingo
