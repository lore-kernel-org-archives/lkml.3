Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbaJHWNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:13:44 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:51626 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687AbaJHWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:13:43 -0400
Message-ID: <1412806419.2908.6.camel@u64>
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, dbueso@suse.de, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Date: Wed, 08 Oct 2014 15:13:39 -0700
In-Reply-To: <20141001052832.GA32248@gmail.com>
References: <1412120999.2941.11.camel@u64>
	 <20141001052832.GA32248@gmail.com>
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 07:28 +0200, Ingo Molnar wrote:

> > 
> > Perf trace of perf bench creat
> > 22.37%	locking-creat  [kernel.kallsyms]	[k] osq_lock
> > 5.77%	locking-creat  [kernel.kallsyms]	[k] mutex_spin_on_owner
> > 5.31%	locking-creat  [kernel.kallsyms]	[k] _raw_spin_lock
> > 5.15%	locking-creat  [jbd2]			[k] jbd2_journal_put_journal_head
> > ...
> 
> Very nice!
> 
> If you compare an strace of AIM7 steady state and 'perf bench 
> lock' steady state, is it comparable, i.e. do the syscalls and 
> other behavioral patterns match up?
> 

Here is an strace -cf of my perf bench and AIM7 fserver workload at 1000
users on an ext4 file system.  My perf bench results look comparable to
the AIM7 fserver workload to me.  What do you think?

strace -cf for perf bench locking creat at 1000 users

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ---------
 79.29    4.421000         221     20018           creat
 13.07    0.729000         729      1000           unlink
  6.47    0.361000          18     20032           close
  0.60    0.033213          33      1000           wait4
  0.37    0.020365          20      1000           clone
  0.20    0.011000          11      1003         2 futex
  0.00    0.000037           6         6           munmap
  0.00    0.000010           0        24           mprotect
  0.00    0.000009           0        44           mmap
  0.00    0.000000           0        12           read
  0.00    0.000000           0         4           write
  0.00    0.000000           0      1027        14 open

strace -cf for AIM7 fserver workload at 1000 users

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- -----------
 24.42  163.436284          50   3243016           creat
 18.15  121.475390          17   7148543           brk
 14.49   96.990556       85229      1138        35 wait4
  7.86   52.605030          15   3394990           close
  5.73   38.310323          31   1222317           write
  4.99   33.389587          17   2000001           kill
  4.85   32.432000          16   2001035      1000 rt_sigreturn
  4.64   31.050979          64    483800           getdents
  4.38   29.316247          14   2029311           rt_sigaction
  3.10   20.744360          45    464016      5000 unlink
  2.57   17.171514          15   1153825           read
  1.13    7.588489          35    215104           link
  0.89    5.945480           8    786320       433 stat
  0.60    4.045701          11    366004           lseek
  0.36    2.420812           9    263006           times
  0.34    2.272305          18    124982       129 open


> > +'locking'::
> > +        Locking stressing benchmarks.
> > +
> >  'all'::
> >  	All benchmark subsystems.
> >  
> > @@ -213,6 +216,11 @@ Suite for evaluating wake calls.
> >  *requeue*::
> >  Suite for evaluating requeue calls.
> >  
> > +SUITES FOR 'locking'
> > +~~~~~~~~~~~~~~~~~~
> > +*creat*::
> > +Suite for evaluating locking contention through creat(2).
> 
> So I'd display it in the help text prominently that it's a 
> workload similar to the AIM7 workload.
> 

Thank you Ingo, I will add more comments to make it more clear that it
is similar to AIM7 fserver workload. 

> > +static const struct option options[] = {
> > +	OPT_UINTEGER('s', "start", &start_nr_threads, "Numbers of processes to start"),
> > +	OPT_UINTEGER('e', "end", &end_nr_threads, "Numbers of process to end"),
> > +	OPT_UINTEGER('i', "increment", &increment_threads_by, "Number of threads to increment)"),
> > +	OPT_UINTEGER('r', "runtime", &bench_dur, "Specify benchmark runtime in seconds"),
> > +	OPT_END()
> > +};
> 
> Is this the kind of parameters that AIM7 takes as well?
> 
> In any case, this is a very nice benchmarking utility.

Yes these parameters are similar to what AIM7 take except for the
runtime parameter.  AIM7 does not have the option to specify how long
the benchmark will run.  Also in AIM7 you can also specify numbers of
jobs per run which i did not include since i added a runtime parameter
for the benchmark.




