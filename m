Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaAQOJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:09:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaAQOJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:09:28 -0500
Date: Fri, 17 Jan 2014 12:09:21 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [BUG] perf stat: corrupts memory when using PMU cpumask
Message-ID: <20140117140921.GB8801@infradead.org>
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
> The issue boils down to the fact that evsels have their file descriptors closed
> twice nowadays. Once in __run_per_stat() via perf_evsel__close_fd() and
> twice in perf_evlist__close().
 
> Now, calling close() twice is okay. However the fd is then set to -1.
> That's still okay with close(). The problem is elsewhere.
 
> It comes from the ncpus argument passed to perf_evsel__close(). It is
> DIFFERENT between the evsel and the evlist when cpumask are used.
 
> Take my case, 8 CPUs machine but a 1 CPU cpumask. The evsel allocates
> the xyarray for 1 CPU 1 thread. The fd are first close with 1 CPU, 1 thread.
> But then evlist_close() comes in and STILL thinks the events were using
> 8 CPUs, 1 thread and thus a xyarray of that size. And this causes writes
> to entries that are beyond the xyarray when the fds are set to -1, thereby
> causing memory corruption which I was lucky to catch via glibc.
 
> First, why are we closing the descriptors twice?

The idea here was to reduce the boilerplate that tools need to do when
they are done dealing with evlists, so evlist__delete would do what the
kernel does to resources allocated to a thread when it exits without
explicitely deallocating them: release them all.

So it seems, from your analysis, that bugs were left that need to be
hammered out so that this works as intended. Can you share your patch?
 
> Second, I have a fix that seems to work for me. It uses the evsel->cpus
> if evsel->cpus exists, otherwise it defaults to evtlist->cpus.  Looks like
> a reasonable thing to do to me, but is it? I would rather avoid the double
> close altogether.
> 
> 
> Opinion?
