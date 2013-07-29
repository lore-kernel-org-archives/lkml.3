Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3G2K3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:29:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:5505 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab3G2K3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:29:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,768,1367996400"; 
   d="scan'208";a="274722370"
Message-ID: <51F64411.9060506@intel.com>
Date: Mon, 29 Jul 2013 13:29:37 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: sample after exit loses thread correlation
References: <1374876254-44372-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1374876254-44372-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/2013 1:04 a.m., David Ahern wrote:
> Occassionally events (e.g., context-switch, sched tracepoints) are losing
> the conversion of sample data associated with a thread. For example:
>
> $ perf record -e sched:sched_switch -c 1 -a -- sleep 5
> $ perf script
> <selected events shown>
>      ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>      ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> :30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>
> The last line lost the conversion from tid to comm. If you look at the events
> (perf script -D) you see why - SAMPLE event is generated after the EXIT:
>
> 0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
> 0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
> .... thread: :30482:30482
>
> When perf processes the EXIT event the thread is moved to the dead_threads
> list. When the SAMPLE event is processed no thread exists for the pid so a new
> one is created by machine__findnew_thread.

In the case of per-cpu recording, it is normal for sample events to 
occur after the EXIT event simply because the EXIT event is recorded 
while the task is still running (in kernel).  It is therefore a mistake 
to move the thread to dead_threads just because of the EXIT event.

Instead the thread should be marked as exiting and not moved to 
dead_threads until another thread starts on the same CPU. i.e. a comm, 
mmap, fork event with the same tid and same CPU, or any event with a 
different tid and same CPU.

>
> This patch addresses the problem by saving the exit time and checking the
> dead_threads list for the requested tid. If the time passed into
> machine_findnew_thread is non-0 the dead_threads list is walked looking for
> the tid. If the thread struct associated with the tid exited within 1 msec
> of the time passed in the thread is considered a match and returned.
>
> If samples do not contain timestamps then sample->time will be 0 and the
> dead_threads list will not be checked. -1 can be used to force always checking
> the dead_threads list and returning a match.
>
> With this patch we get the previous example shows:
>
> ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> ls 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>
> and
>
> 0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
> 0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
> .... thread: ls:30482
>
> v2: Rebased to latest perf/core branch. Changed time comparison to use
>      a macro which explicitly shows the time basis
>
> Signed-off-by: David Ahern<dsahern@gmail.com>
> Cc: Frederic Weisbecker<fweisbec@gmail.com>
> Cc: Ingo Molnar<mingo@kernel.org>
> Cc: Jiri Olsa<jolsa@redhat.com>
> Cc: Mike Galbraith<efault@gmx.de>
> Cc: Namhyung Kim<namhyung@kernel.org>
> Cc: Peter Zijlstra<peterz@infradead.org>
> Cc: Stephane Eranian<eranian@google.com>
> ---
>   tools/perf/builtin-inject.c   |    2 +-
>   tools/perf/builtin-kmem.c     |    3 +--
>   tools/perf/builtin-kvm.c      |    2 +-
>   tools/perf/builtin-lock.c     |    2 +-
>   tools/perf/builtin-sched.c    |   16 +++++++--------
>   tools/perf/builtin-script.c   |    2 +-
>   tools/perf/builtin-trace.c    |    6 +++---
>   tools/perf/perf.h             |    3 +++
>   tools/perf/tests/hists_link.c |    2 +-
>   tools/perf/util/build-id.c    |    9 ++++-----
>   tools/perf/util/event.c       |   10 ++++++++--
>   tools/perf/util/machine.c     |   44 ++++++++++++++++++++++++++++++-----------
>   tools/perf/util/machine.h     |    6 ++++--
>   tools/perf/util/session.c     |    2 +-
>   tools/perf/util/thread.h      |    2 +-
>   15 files changed, 71 insertions(+), 40 deletions(-)
