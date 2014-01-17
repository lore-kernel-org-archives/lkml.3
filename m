Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaAQJA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:00:29 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41832 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAQJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:00:22 -0500
MIME-Version: 1.0
Date: Fri, 17 Jan 2014 10:00:20 +0100
Message-ID: <CABPqkBSQ4vdT7-Cev86Bxt6T1uhiy-T28L2Eq5BzSPAC=mA8yw@mail.gmail.com>
Subject: [BUG] perf stat: corrupts memory when using PMU cpumask
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been debugging a NULL pointer issue with perf stat unit/scale code
and in the process I ran into what appeared like a double-free issue reported
by glibc. It took me a while to realize that it was because of memory corruption
caused by a recent change in how evsel are freed.

My test case is simple. I used RAPL but I think any event with a suggested
cpumask in /sys/devices/XXX/cpumask will do:

# perf stat -a -e power/energy-cores/ ls

The issue boils down to the fact that evsels have their file descriptors closed
twice nowadays. Once in __run_per_stat() via perf_evsel__close_fd() and
twice in perf_evlist__close().

Now, calling close() twice is okay. However the fd is then set to -1.
That's still okay with close(). The problem is elsewhere.

It comes from the ncpus argument passed to perf_evsel__close(). It is
DIFFERENT between the evsel and the evlist when cpumask are used.

Take my case, 8 CPUs machine but a 1 CPU cpumask. The evsel allocates
the xyarray for 1 CPU 1 thread. The fd are first close with 1 CPU, 1 thread.
But then evlist_close() comes in and STILL thinks the events were using
8 CPUs, 1 thread and thus a xyarray of that size. And this causes writes
to entries that are beyond the xyarray when the fds are set to -1, thereby
causing memory corruption which I was lucky to catch via glibc.

First, why are we closing the descriptors twice?

Second, I have a fix that seems to work for me. It uses the evsel->cpus
if evsel->cpus exists, otherwise it defaults to evtlist->cpus.  Looks like
a reasonable thing to do to me, but is it? I would rather avoid the double
close altogether.


Opinion?
