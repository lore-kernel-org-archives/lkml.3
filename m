Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab3K1Pim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:38:42 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33816 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3K1Pij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:38:39 -0500
MIME-Version: 1.0
In-Reply-To: <1384806771-2945-7-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com> <1384806771-2945-7-git-send-email-dsahern@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 29 Nov 2013 00:38:18 +0900
X-Google-Sender-Auth: 7rX2UL9XAKlUHwFjgDtOVd5EwxI
Message-ID: <CAM9d7cg4t_HD-225GawXnUHXG1D-f91ZDS_xsfy19baHSM624w@mail.gmail.com>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 5:32 AM, David Ahern <dsahern@gmail.com> wrote:

[SNIP]
> +static bool is_idle_sample(struct perf_sample *sample,
> +                          struct perf_evsel *evsel,
> +                          struct machine *machine)
> +{
> +       struct thread *thread;
> +       struct callchain_cursor *cursor = &callchain_cursor;
> +       struct callchain_cursor_node *node;
> +       struct addr_location al;
> +       int iter = 5;

Shouldn't it be sched->max_stack somehow?

> +
> +       /* pid 0 == swapper == idle task */
> +       if (sample->pid == 0)
> +               return true;
> +
> +       /* want main thread for process - has maps */
> +       thread = machine__findnew_thread(machine, sample->pid, sample->pid);
> +       if (thread == NULL) {
> +               pr_debug("Failed to get thread for pid %d.\n", sample->pid);
> +               return false;
> +       }
> +
> +       if (!symbol_conf.use_callchain || sample->callchain == NULL)
> +               return false;
> +
> +       if (machine__resolve_callchain(machine, evsel, thread,
> +                                       sample, NULL, &al, PERF_MAX_STACK_DEPTH) != 0) {
> +               if (verbose)
> +                       error("Failed to resolve callchain. Skipping\n");
> +
> +               return false;
> +       }

I think this callchain resolving logic should be moved to the
beginning of perf_hist__process_sample() like other commands do.  It's
not for idle threads only.

And it also needs to pass sched->max_stack.


> +       callchain_cursor_commit(cursor);
> +
> +       /* idle symbol should be early in the stack */
> +       while (iter) {
> +               node = callchain_cursor_current(cursor);
> +               if (!node)
> +                       break;
> +
> +               if (symbol__is_idle(node->sym))
> +                       return true;
> +
> +               callchain_cursor_advance(cursor);
> +
> +               iter--;
> +       }
> +
> +       return false;
> +}

[SNIP]
> +       /* show wakeups if requested */
> +       if (sched->show_wakeups && !sched->summary_only)

Hmm.. maybe we can emit a warning if -w and -s options are given at
the same time.


> +               timehist_print_wakeup_event(sched, sample, machine, thread);
> +
> +       return 0;
> +}

[SNIP]
> +static int parse_target_str(struct perf_sched *sched)
> +{
> +       if (sched->target.pid) {
> +               sched->pid = intlist__new(sched->target.pid);
> +               if (sched->pid == NULL) {
> +                       pr_err("Error parsing process id string\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       if (sched->target.tid) {
> +               sched->tid = intlist__new(sched->target.tid);
> +               if (sched->tid == NULL) {
> +                       pr_err("Error parsing thread id string\n");


Need to call intlist__delete(sched->pid) here?


> +                       return -EINVAL;
> +               }
> +       }
> +
> +       return 0;
> +}

[SNIP]
> +       const struct option timehist_options[] = {
> +       OPT_STRING('i', "input", &input_name, "file",
> +                   "input file name"),
> +       OPT_INCR('v', "verbose", &verbose,
> +                   "be more verbose (show symbol address, etc)"),
> +       OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
> +                  "file", "vmlinux pathname"),
> +       OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
> +                  "file", "kallsyms pathname"),
> +       OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
> +                  "only display events for these comms"),
> +       OPT_STRING('p', "pid", &sched.target.pid, "pid",
> +                  "analyze events only for given process id(s)"),
> +       OPT_STRING('t', "tid", &sched.target.tid, "tid",
> +                   "analyze events only for given thread id(s)"),
> +       OPT_BOOLEAN('g', "call-graph", &sched.show_callchain,
> +                   "Display call chains if present (default on)"),
> +       OPT_UINTEGER(0, "max-stack", &sched.max_stack,
> +                  "Maximum number of functions to display backtrace."),
> +       OPT_STRING('x', "excl", &excl_sym_list_str, "sym[,sym...]",

Why not renaming long option name to --exclude or --exclude-symbols?

Thanks,
Namhyung


> +                  "symbols to skip in backtrace"),
> +       OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
> +                   "Look for files with symbols relative to this directory"),
> +       OPT_BOOLEAN('s', "summary", &sched.summary_only,
> +                   "Show only syscall summary with statistics"),
> +       OPT_BOOLEAN('S', "with-summary", &sched.summary,
> +                   "Show all syscalls and summary with statistics"),
> +       OPT_BOOLEAN('w', "wakeups", &sched.show_wakeups, "Show wakeup events"),
> +       OPT_BOOLEAN('V', "cpu-visual", &sched.show_cpu_visual, "Add CPU visual"),
> +       OPT_END()
> +       };
> +       const char * const timehist_usage[] = {
> +               "perf sched timehist [<options>]",
> +               NULL
> +       };
> +
