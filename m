Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaAQOGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:06:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbaAQOGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:06:10 -0500
Date: Fri, 17 Jan 2014 12:05:59 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [BUG] perf stat: corrupts memory when using PMU cpumask
Message-ID: <20140117140559.GA8801@infradead.org>
References: <CABPqkBSQ4vdT7-Cev86Bxt6T1uhiy-T28L2Eq5BzSPAC=mA8yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSQ4vdT7-Cev86Bxt6T1uhiy-T28L2Eq5BzSPAC=mA8yw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 17, 2014 at 10:00:20AM +0100, Stephane Eranian escreveu:
> Hi,
> 
> I have been debugging a NULL pointer issue with perf stat unit/scale code
> and in the process I ran into what appeared like a double-free issue reported
> by glibc. It took me a while to realize that it was because of memory corruption
> caused by a recent change in how evsel are freed.
> 
> My test case is simple. I used RAPL but I think any event with a suggested
> cpumask in /sys/devices/XXX/cpumask will do:
> 
> # perf stat -a -e power/energy-cores/ ls
> 
> The issue boils down to the fact that evsels have their file descriptors closed
> twice nowadays. Once in __run_per_stat() via perf_evsel__close_fd() and
> twice in perf_evlist__close().
> 
> Now, calling close() twice is okay. However the fd is then set to -1.
> That's still okay with close(). The problem is elsewhere.
> 
> It comes from the ncpus argument passed to perf_evsel__close(). It is
> DIFFERENT between the evsel and the evlist when cpumask are used.

Oops, at some point I knew that set of globals and mixup of evlists in
builtin-stat would bite :-\

I guess it was introduced in:

  commit 7ae92e744e3fb389afb1e24920ecda331d360c61
  Author: Yan, Zheng <zheng.z.yan@intel.com>
  Date:   Mon Sep 10 15:53:50 2012 +0800

      perf stat: Check PMU cpumask file

I need to untangle that direct usage of the target, and global evlist to
properly fix this, but in the meantime I'll take a look at your patch,
thanks for doing this work.

 
> Take my case, 8 CPUs machine but a 1 CPU cpumask. The evsel allocates
> the xyarray for 1 CPU 1 thread. The fd are first close with 1 CPU, 1 thread.
> But then evlist_close() comes in and STILL thinks the events were using
> 8 CPUs, 1 thread and thus a xyarray of that size. And this causes writes
> to entries that are beyond the xyarray when the fds are set to -1, thereby
> causing memory corruption which I was lucky to catch via glibc.
> 
> First, why are we closing the descriptors twice?
> 
> Second, I have a fix that seems to work for me. It uses the evsel->cpus
> if evsel->cpus exists, otherwise it defaults to evtlist->cpus.  Looks like
> a reasonable thing to do to me, but is it? I would rather avoid the double
> close altogether.
> 
> 
> Opinion?
