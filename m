Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaKUSwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:52:07 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57462 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaKUSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:52:05 -0500
Message-ID: <1416595920.3482.8.camel@u64>
Subject: Re: [PATCH v2] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, dbueso@suse.de, a.p.zijlstra@chello.nl,
        paulus@samba.org, artagnon@gmail.com, jolsa@redhat.com,
        dvhart@linux.intel.com, Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org,
        mingo@kernel.org
Date: Fri, 21 Nov 2014 10:52:00 -0800
In-Reply-To: <20141121160413.GC18625@kernel.org>
References: <20141121155706.GB18625@kernel.org>
	 <20141121160413.GC18625@kernel.org>
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 13:04 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 21, 2014 at 12:57:06PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Nov 20, 2014 at 11:06:05AM -0800, Tuan Bui escreveu:
> > > Subject: [PATCH] Perf Bench: Locking Microbenchmark
> > > 
> > > In response to this thread https://lkml.org/lkml/2014/2/11/93, this is
> > > a micro benchmark that stresses locking contention in the kernel with
> > > creat(2) system call by spawning multiple processes to spam this system
> > > call.  This workload generate similar results and contentions in AIM7
> > > fserver workload but can generate outputs within seconds.
> > > 
> > > With the creat system call the contention vary on what locks are used
> > > in the particular file system. I have ran this benchmark only on ext4
> > > and xfs file system.
> 
> I noticed that if control+C it it leaves tons of files in the current
> directory, can you please add code to make it handle this? I think that
> it would also be better to create a temporary directory, etc.
> 

Thank you for the suggestion Arnaldo.  I will implement code to handle
control+C using a temp directory.

> And please take a look at the edited changelog below, to reflect those
> changes on your next attempt to submit this patch, ok? I added an
> Example so that people can now at a glance how it changes the existing
> output for 'perf bench' and what is the output for 'perf bench locking'.
> 
> - Arnaldo
> 

I will definitely include your edited changelog on my next attempt to
submit this patch.  Thank you.

-Tuan


> Subject: [PATCH] perf bench: Locking Microbenchmark
> 
> In response to this thread https://lkml.org/lkml/2014/2/11/93, this is
> a micro benchmark that stresses locking contention in the kernel with
> creat(2) system call by spawning multiple processes to spam this system
> call.  This workload generate similar results and contentions in AIM7
> fserver workload but can generate outputs within seconds.
> 
> With the creat system call the contention vary on what locks are used
> in the particular file system. I have ran this benchmark only on ext4
> and xfs file system.
> 
> Running the creat workload on ext4 show contention in the mutex lock
> that is used by ext4_orphan_add() and ext4_orphan_del() to add or delete
> an inode from the list of inodes. At the same time running the creat
> workload on xfs show contention in the spinlock that is used by
> xsf_log_commit_cil() to commit a transaction to the Committed Item List.
> 
> Here is a comparison of this benchmark with AIM7 running fserver workload
> at 500-1000 users along with a perf trace running on ext4 file system.
> 
> Test machine is a 8-sockets 80 cores Westmere system HT-off on v3.17-rc6.
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
> Perf report for AIM7 fserver:
> 14.51%	reaim  		[kernel.kallsyms]	[k] osq_lock
> 4.98%	reaim  		reaim			[.] add_long
> 4.98%	reaim  		reaim			[.] add_int
> 4.31%	reaim  		[kernel.kallsyms]	[k] mutex_spin_on_owner
> ...
> 
> Perf report of 'perf bench locking vfs'
> 
> 22.37%	locking-creat  [kernel.kallsyms]	[k] osq_lock
> 5.77%	locking-creat  [kernel.kallsyms]	[k] mutex_spin_on_owner
> 5.31%	locking-creat  [kernel.kallsyms]	[k] _raw_spin_lock
> 5.15%	locking-creat  [jbd2]			[k] jbd2_journal_put_journal_head
> ...
> 
> Example:
> 
> [root@zoo ~]# perf bench
> Usage:
> 	perf bench [<common options>] <collection> <benchmark>
> [<options>]
> 
>         # List of all available benchmark collections:
> 
>          sched: Scheduler and IPC benchmarks
>            mem: Memory access benchmarks
>           numa: NUMA scheduling and MM benchmarks
>          futex: Futex stressing benchmarks
>        locking: Kernel locking benchmarks
>            all: All benchmarks
> 
> [root@zoo ~]# perf bench locking
> 
>         # List of available benchmarks for collection 'locking':
> 
>            vfs: Benchmark vfs using creat(2)
>            all: Run all benchmarks in this suite
> 
> [root@zoo ~]# perf bench locking vfs
> 
>    100 processes: throughput = 342506 average opts/sec all processes
>    100 processes: throughput = 3425 average opts/sec per process
> 
>    200 processes: throughput = 341309 average opts/sec all processes
>    200 processes: throughput = 1706 average opts/sec per process
> <SNIP>
> 
> Changes since v1:
> - Added -j options to specified jobs per processes.
> - Change name of microbenchmark from creat to vfs.
> - Change all instances of threads to proccess.
> 


