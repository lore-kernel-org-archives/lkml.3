Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKFEk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:40:57 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33728 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKFEk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:40:56 -0500
Message-ID: <545AFBD1.9080704@hitachi.com>
Date: Thu, 06 Nov 2014 13:40:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] ftracetest: Add basic event tracing test cases
References: <1415239470-28705-1-git-send-email-namhyung@kernel.org> <1415239470-28705-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1415239470-28705-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/06 11:04), Namhyung Kim wrote:
> This patch adds basic event tracing tests like enable/disable with
> top-level, subsystem-level and individual event files.
> 
>   # ./ftracetest
>   === Ftrace unit tests ===
>   [1] Basic trace file check	[PASS]
>   [2] Basic trace clock test	[PASS]
>   [3] Basic event tracing check	[PASS]
>   [4] Basic test for tracers	[PASS]
>   [5] event tracing - enable/disable with top level files	[PASS]
>   [6] event tracing - enable/disable with subsystem level files	[PASS]
>   [7] event tracing - enable/disable with event level files	[PASS]
>   [8] ftrace - function graph filters	[PASS]
>   [9] ftrace - function profiler with function tracing	[PASS]
>   [10] ftrace - function graph filters with stack tracer	[PASS]
>   [11] Kretprobe dynamic event with arguments	[PASS]
>   [12] Kprobe dynamic event - busy event check	[PASS]
>   [13] Kprobe dynamic event with arguments	[PASS]
>   [14] Kprobe dynamic event - adding and removing	[PASS]
> 
>   # of passed:  14
>   # of failed:  0
>   # of unresolved:  0
>   # of untested:  0
>   # of unsupported:  0
>   # of xfailed:  0
>   # of undefined(test bug):  0

Nice :)

> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  .../selftests/ftrace/test.d/00basic/basic4.tc      |  5 ++
>  .../selftests/ftrace/test.d/event/event-enable.tc  | 53 ++++++++++++++++++++++
>  .../ftrace/test.d/event/subsystem-enable.tc        | 53 ++++++++++++++++++++++
>  .../ftrace/test.d/event/toplevel-enable.tc         | 47 +++++++++++++++++++
>  4 files changed, 158 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/test.d/00basic/basic4.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/event/event-enable.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/00basic/basic4.tc b/tools/testing/selftests/ftrace/test.d/00basic/basic4.tc
> new file mode 100644
> index 000000000000..fd9c49a13612
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/00basic/basic4.tc
> @@ -0,0 +1,5 @@
> +#!/bin/sh
> +# description: Basic event tracing check
> +test -f available_events -a -f set_event -a -d events
> +# check scheduler events are available
> +grep -q sched available_events && exit 0 || exit -1
> \ No newline at end of file
> diff --git a/tools/testing/selftests/ftrace/test.d/event/event-enable.tc b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
> new file mode 100644
> index 000000000000..668616d9bb03
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
> @@ -0,0 +1,53 @@
> +#!/bin/sh
> +# description: event tracing - enable/disable with event level files
> +
> +do_reset() {
> +    echo > set_event
> +    clear_trace
> +}
> +
> +fail() { #msg
> +    do_reset
> +    echo $1
> +    exit -1
> +}
> +
> +if [ ! -f set_event -o ! -d events/sched ]; then
> +    echo "event tracing is not supported"
> +    exit_unsupported
> +fi
> +
> +reset_tracer
> +do_reset
> +
> +echo 'sched:sched_switch' > set_event
> +usleep 1
> +
> +count=`cat trace | grep sched_switch | wc -l`
> +if [ $count -eq 0 ]; then
> +    fail "sched_switch events are not recorded"
> +fi
> +
> +do_reset
> +
> +echo 1 > events/sched/sched_switch/enable
> +usleep 1
> +
> +count=`cat trace | grep sched_switch | wc -l`
> +if [ $count -eq 0 ]; then
> +    fail "sched_switch events are not recorded"
> +fi
> +
> +do_reset
> +
> +echo 0 > events/sched/sched_switch/enable
> +usleep 1
> +
> +count=`cat trace | grep sched_switch | wc -l`
> +if [ $count -ne 0 ]; then
> +    fail "sched_switch events should not be recorded"
> +fi
> +
> +do_reset
> +
> +exit 0
> diff --git a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
> new file mode 100644
> index 000000000000..655c415b6e7f
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
> @@ -0,0 +1,53 @@
> +#!/bin/sh
> +# description: event tracing - enable/disable with subsystem level files
> +
> +do_reset() {
> +    echo > set_event
> +    clear_trace
> +}
> +
> +fail() { #msg
> +    do_reset
> +    echo $1
> +    exit -1
> +}
> +
> +if [ ! -f set_event -o ! -d events/sched ]; then
> +    echo "event tracing is not supported"
> +    exit_unsupported
> +fi
> +
> +reset_tracer
> +do_reset
> +
> +echo 'sched:*' > set_event
> +usleep 1
> +
> +count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
> +if [ $count -lt 3 ]; then
> +    fail "at least fork, exec and exit events should be recorded"
> +fi
> +
> +do_reset
> +
> +echo 1 > events/sched/enable
> +usleep 1
> +
> +count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
> +if [ $count -lt 3 ]; then
> +    fail "at least fork, exec and exit events should be recorded"
> +fi
> +
> +do_reset
> +
> +echo 0 > events/sched/enable
> +usleep 1
> +
> +count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
> +if [ $count -ne 0 ]; then
> +    fail "any of scheduler events should not be recorded"
> +fi
> +
> +do_reset
> +
> +exit 0
> diff --git a/tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc b/tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc
> new file mode 100644
> index 000000000000..480845774007
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/event/toplevel-enable.tc
> @@ -0,0 +1,47 @@
> +#!/bin/sh
> +# description: event tracing - enable/disable with top level files
> +
> +do_reset() {
> +    echo > set_event
> +    clear_trace
> +}
> +
> +fail() { #msg
> +    do_reset
> +    echo $1
> +    exit -1
> +}
> +
> +if [ ! -f available_events -o ! -f set_event -o ! -d events ]; then
> +    echo "event tracing is not supported"
> +    exit_unsupported
> +fi
> +
> +reset_tracer
> +do_reset
> +
> +echo '*:*' > set_event
> +count=`cat trace | grep -v ^# | wc -l`
> +if [ $count -eq 0 ]; then
> +    fail "none of events are recorded"
> +fi
> +
> +do_reset
> +
> +echo 1 > events/enable
> +count=`cat trace | grep -v ^# | wc -l`
> +if [ $count -eq 0 ]; then
> +    fail "none of events are recorded"
> +fi
> +
> +do_reset
> +
> +echo 0 > events/enable
> +count=`cat trace | grep -v ^# | wc -l`
> +if [ $count -ne 0 ]; then
> +    fail "any of events should not be recorded"
> +fi
> +
> +do_reset
> +
> +exit 0
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


