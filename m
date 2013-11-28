Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab3K1QB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:01:29 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42296 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab3K1QB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:01:27 -0500
Message-ID: <529768D3.1000507@gmail.com>
Date: Thu, 28 Nov 2013 09:01:23 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com> <1384806771-2945-7-git-send-email-dsahern@gmail.com> <CAM9d7cg4t_HD-225GawXnUHXG1D-f91ZDS_xsfy19baHSM624w@mail.gmail.com>
In-Reply-To: <CAM9d7cg4t_HD-225GawXnUHXG1D-f91ZDS_xsfy19baHSM624w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 8:38 AM, Namhyung Kim wrote:
> On Tue, Nov 19, 2013 at 5:32 AM, David Ahern <dsahern@gmail.com> wrote:
>
> [SNIP]
>> +static bool is_idle_sample(struct perf_sample *sample,
>> +                          struct perf_evsel *evsel,
>> +                          struct machine *machine)
>> +{
>> +       struct thread *thread;
>> +       struct callchain_cursor *cursor = &callchain_cursor;
>> +       struct callchain_cursor_node *node;
>> +       struct addr_location al;
>> +       int iter = 5;
>
> Shouldn't it be sched->max_stack somehow?

max_stack is used to dump callstack to the user. In this case we are 
walking the stack looking for an idle symbol.

>
>> +
>> +       /* pid 0 == swapper == idle task */
>> +       if (sample->pid == 0)
>> +               return true;
>> +
>> +       /* want main thread for process - has maps */
>> +       thread = machine__findnew_thread(machine, sample->pid, sample->pid);
>> +       if (thread == NULL) {
>> +               pr_debug("Failed to get thread for pid %d.\n", sample->pid);
>> +               return false;
>> +       }
>> +
>> +       if (!symbol_conf.use_callchain || sample->callchain == NULL)
>> +               return false;
>> +
>> +       if (machine__resolve_callchain(machine, evsel, thread,
>> +                                       sample, NULL, &al, PERF_MAX_STACK_DEPTH) != 0) {
>> +               if (verbose)
>> +                       error("Failed to resolve callchain. Skipping\n");
>> +
>> +               return false;
>> +       }
>
> I think this callchain resolving logic should be moved to the
> beginning of perf_hist__process_sample() like other commands do.  It's
> not for idle threads only.

I'll see what can be done.

>
> And it also needs to pass sched->max_stack.

Per above, max_stack has a different purpose

>
>
>> +       callchain_cursor_commit(cursor);
>> +
>> +       /* idle symbol should be early in the stack */
>> +       while (iter) {
>> +               node = callchain_cursor_current(cursor);
>> +               if (!node)
>> +                       break;
>> +
>> +               if (symbol__is_idle(node->sym))
>> +                       return true;
>> +
>> +               callchain_cursor_advance(cursor);
>> +
>> +               iter--;
>> +       }
>> +
>> +       return false;
>> +}
>
> [SNIP]
>> +       /* show wakeups if requested */
>> +       if (sched->show_wakeups && !sched->summary_only)
>
> Hmm.. maybe we can emit a warning if -w and -s options are given at
> the same time.

ok.

>
>
>> +               timehist_print_wakeup_event(sched, sample, machine, thread);
>> +
>> +       return 0;
>> +}
>
> [SNIP]
>> +static int parse_target_str(struct perf_sched *sched)
>> +{
>> +       if (sched->target.pid) {
>> +               sched->pid = intlist__new(sched->target.pid);
>> +               if (sched->pid == NULL) {
>> +                       pr_err("Error parsing process id string\n");
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +
>> +       if (sched->target.tid) {
>> +               sched->tid = intlist__new(sched->target.tid);
>> +               if (sched->tid == NULL) {
>> +                       pr_err("Error parsing thread id string\n");
>
>
> Need to call intlist__delete(sched->pid) here?

indeed. thanks.


>> +       const struct option timehist_options[] = {
>> +       OPT_STRING('i', "input", &input_name, "file",
>> +                   "input file name"),
>> +       OPT_INCR('v', "verbose", &verbose,
>> +                   "be more verbose (show symbol address, etc)"),
>> +       OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
>> +                  "file", "vmlinux pathname"),
>> +       OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
>> +                  "file", "kallsyms pathname"),
>> +       OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
>> +                  "only display events for these comms"),
>> +       OPT_STRING('p', "pid", &sched.target.pid, "pid",
>> +                  "analyze events only for given process id(s)"),
>> +       OPT_STRING('t', "tid", &sched.target.tid, "tid",
>> +                   "analyze events only for given thread id(s)"),
>> +       OPT_BOOLEAN('g', "call-graph", &sched.show_callchain,
>> +                   "Display call chains if present (default on)"),
>> +       OPT_UINTEGER(0, "max-stack", &sched.max_stack,
>> +                  "Maximum number of functions to display backtrace."),
>> +       OPT_STRING('x', "excl", &excl_sym_list_str, "sym[,sym...]",
>
> Why not renaming long option name to --exclude or --exclude-symbols?

ok.

David
