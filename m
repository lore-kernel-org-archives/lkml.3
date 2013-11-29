Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3K2AtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:49:00 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58599 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3K2As4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:48:56 -0500
X-AuditID: 9c93017d-b7b24ae000002834-8c-5297e4713eba
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Melo <acme@ghostprotocols.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
	<1384806771-2945-7-git-send-email-dsahern@gmail.com>
	<CAM9d7cg4t_HD-225GawXnUHXG1D-f91ZDS_xsfy19baHSM624w@mail.gmail.com>
	<529768D3.1000507@gmail.com>
Date: Fri, 29 Nov 2013 09:48:49 +0900
In-Reply-To: <529768D3.1000507@gmail.com> (David Ahern's message of "Thu, 28
	Nov 2013 09:01:23 -0700")
Message-ID: <87k3fsowwe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 28 Nov 2013 09:01:23 -0700, David Ahern wrote:
> On 11/28/13, 8:38 AM, Namhyung Kim wrote:
>> On Tue, Nov 19, 2013 at 5:32 AM, David Ahern <dsahern@gmail.com> wrote:
>>
>> [SNIP]
>>> +static bool is_idle_sample(struct perf_sample *sample,
>>> +                          struct perf_evsel *evsel,
>>> +                          struct machine *machine)
>>> +{
>>> +       struct thread *thread;
>>> +       struct callchain_cursor *cursor = &callchain_cursor;
>>> +       struct callchain_cursor_node *node;
>>> +       struct addr_location al;
>>> +       int iter = 5;
>>
>> Shouldn't it be sched->max_stack somehow?
>
> max_stack is used to dump callstack to the user. In this case we are
> walking the stack looking for an idle symbol.

Do we really need to look up the callchain to find out an idle thread?

  $ perf sched script | grep swapper | head
         swapper     0 [001] 4294177.326996: sched:sched_switch: prev_comm=swapper/1 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=Xorg next_pid=1094 next_prio=120
         swapper     0 [010] 4294177.327019: sched:sched_switch: prev_comm=swapper/10 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=13902 next_prio=120
            perf 13901 [002] 4294177.327074: sched:sched_switch: prev_comm=perf prev_pid=13901 prev_prio=120 prev_state=S ==> next_comm=swapper/2 next_pid=0 next_prio=120
         swapper     0 [004] 4294177.327096: sched:sched_switch: prev_comm=swapper/4 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=synergys next_pid=1521 next_prio=120
         swapper     0 [000] 4294177.327102: sched:sched_switch: prev_comm=swapper/0 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=gnome-terminal next_pid=2392 next_prio=120
            Xorg  1094 [001] 4294177.327112: sched:sched_switch: prev_comm=Xorg prev_pid=1094 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=120
         swapper     0 [007] 4294177.327122: sched:sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=perf next_pid=13902 next_prio=120
    migration/10    58 [010] 4294177.327124: sched:sched_switch: prev_comm=migration/10 prev_pid=58 prev_prio=0 prev_state=S ==> next_comm=swapper/10 next_pid=0 next_prio=120
        synergys  1521 [004] 4294177.327144: sched:sched_switch: prev_comm=synergys prev_pid=1521 prev_prio=120 prev_state=S ==> next_comm=swapper/4 next_pid=0 next_prio=120
  gnome-terminal  2392 [000] 4294177.327286: sched:sched_switch: prev_comm=gnome-terminal prev_pid=2392 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120

It seems every idle/swapper thread for each cpu has a pid of 0.

>
>>
>>> +
>>> +       /* pid 0 == swapper == idle task */
>>> +       if (sample->pid == 0)
>>> +               return true;
>>> +
>>> +       /* want main thread for process - has maps */
>>> +       thread = machine__findnew_thread(machine, sample->pid, sample->pid);
>>> +       if (thread == NULL) {
>>> +               pr_debug("Failed to get thread for pid %d.\n", sample->pid);
>>> +               return false;
>>> +       }
>>> +
>>> +       if (!symbol_conf.use_callchain || sample->callchain == NULL)
>>> +               return false;
>>> +
>>> +       if (machine__resolve_callchain(machine, evsel, thread,
>>> +                                       sample, NULL, &al, PERF_MAX_STACK_DEPTH) != 0) {
>>> +               if (verbose)
>>> +                       error("Failed to resolve callchain. Skipping\n");
>>> +
>>> +               return false;
>>> +       }
>>
>> I think this callchain resolving logic should be moved to the
>> beginning of perf_hist__process_sample() like other commands do.  It's
>> not for idle threads only.
>
> I'll see what can be done.
>
>>
>> And it also needs to pass sched->max_stack.
>
> Per above, max_stack has a different purpose

Hmm.. anyway I don't think we need to pass PERF_MAX_STACK_DEPTH for
machine__resolve_callchain() as we'll only look up to max_stack entries.

Thanks,
Namhyung
