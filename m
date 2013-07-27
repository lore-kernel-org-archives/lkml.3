Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3G0MP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 08:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3G0MPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 08:15:55 -0400
Date: Sat, 27 Jul 2013 14:15:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: sample after exit loses thread correlation
Message-ID: <20130727121518.GA1038@krava.brq.redhat.com>
References: <1374876254-44372-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374876254-44372-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:04:14PM -0600, David Ahern wrote:
> Occassionally events (e.g., context-switch, sched tracepoints) are losing
> the conversion of sample data associated with a thread. For example:
> 
> $ perf record -e sched:sched_switch -c 1 -a -- sleep 5
> $ perf script
> <selected events shown>
>     ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>     ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> :30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> 
> The last line lost the conversion from tid to comm. If you look at the events
> (perf script -D) you see why - SAMPLE event is generated after the EXIT:
> 
> 0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
> 0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
> ... thread: :30482:30482
> 
> When perf processes the EXIT event the thread is moved to the dead_threads
> list. When the SAMPLE event is processed no thread exists for the pid so a new
> one is created by machine__findnew_thread.
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
> ... thread: ls:30482
> 
> v2: Rebased to latest perf/core branch. Changed time comparison to use
>     a macro which explicitly shows the time basis
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>

tested and

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
