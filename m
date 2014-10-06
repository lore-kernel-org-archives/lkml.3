Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaJFWeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:34:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:26246 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaJFWeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:34:06 -0400
Date: Mon, 6 Oct 2014 18:33:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/for-next ] tracing/kprobes: Replace startup test
 with selftest script
Message-ID: <20141006183349.60998821@gandalf.local.home>
In-Reply-To: <20141006114806.2573.63966.stgit@kbuild-f20.novalocal>
References: <20141006114806.2573.63966.stgit@kbuild-f20.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2014 11:48:06 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Replace the kprobe_tracer's startup test with two selftest scripts.
> These test cases are testing that the kprobe_event can accept a
> kprobe event with $stack related arguments and a kretprobe event
> with $retval argument.

Can't we keep both? I have boxes I run my own tests with and enables
these start up tests in the kernel. I don't plan on testing on all
theses boxes using the scripts in the kernel.

Having a self test in the kernel itself can be useful too.

-- Steve

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  kernel/trace/trace_kprobe.c                        |  142 --------------------
>  .../selftests/ftrace/test.d/kprobe/kprobe_args.tc  |   16 ++
>  .../ftrace/test.d/kprobe/kretprobe_args.tc         |   15 ++
>  3 files changed, 31 insertions(+), 142 deletions(-)
>  create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
>  create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 282f6e4..1018f77 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1352,145 +1352,3 @@ static __init int init_kprobe_trace(void)
>  }
>  fs_initcall(init_kprobe_trace);
>  
> -
> -#ifdef CONFIG_FTRACE_STARTUP_TEST
> -
> -/*
> - * The "__used" keeps gcc from removing the function symbol
> - * from the kallsyms table.
> - */
> -static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
> -					       int a4, int a5, int a6)
> -{
> -	return a1 + a2 + a3 + a4 + a5 + a6;
> -}
> -
> -static struct ftrace_event_file *
> -find_trace_probe_file(struct trace_kprobe *tk, struct trace_array *tr)
> -{
> -	struct ftrace_event_file *file;
> -
> -	list_for_each_entry(file, &tr->events, list)
> -		if (file->event_call == &tk->tp.call)
> -			return file;
> -
> -	return NULL;
> -}
> -
> -/*
> - * Nobody but us can call enable_trace_kprobe/disable_trace_kprobe at this
> - * stage, we can do this lockless.
> - */
> -static __init int kprobe_trace_self_tests_init(void)
> -{
> -	int ret, warn = 0;
> -	int (*target)(int, int, int, int, int, int);
> -	struct trace_kprobe *tk;
> -	struct ftrace_event_file *file;
> -
> -	if (tracing_is_disabled())
> -		return -ENODEV;
> -
> -	target = kprobe_trace_selftest_target;
> -
> -	pr_info("Testing kprobe tracing: ");
> -
> -	ret = traceprobe_command("p:testprobe kprobe_trace_selftest_target "
> -				  "$stack $stack0 +0($stack)",
> -				  create_trace_kprobe);
> -	if (WARN_ON_ONCE(ret)) {
> -		pr_warn("error on probing function entry.\n");
> -		warn++;
> -	} else {
> -		/* Enable trace point */
> -		tk = find_trace_kprobe("testprobe", KPROBE_EVENT_SYSTEM);
> -		if (WARN_ON_ONCE(tk == NULL)) {
> -			pr_warn("error on getting new probe.\n");
> -			warn++;
> -		} else {
> -			file = find_trace_probe_file(tk, top_trace_array());
> -			if (WARN_ON_ONCE(file == NULL)) {
> -				pr_warn("error on getting probe file.\n");
> -				warn++;
> -			} else
> -				enable_trace_kprobe(tk, file);
> -		}
> -	}
> -
> -	ret = traceprobe_command("r:testprobe2 kprobe_trace_selftest_target "
> -				  "$retval", create_trace_kprobe);
> -	if (WARN_ON_ONCE(ret)) {
> -		pr_warn("error on probing function return.\n");
> -		warn++;
> -	} else {
> -		/* Enable trace point */
> -		tk = find_trace_kprobe("testprobe2", KPROBE_EVENT_SYSTEM);
> -		if (WARN_ON_ONCE(tk == NULL)) {
> -			pr_warn("error on getting 2nd new probe.\n");
> -			warn++;
> -		} else {
> -			file = find_trace_probe_file(tk, top_trace_array());
> -			if (WARN_ON_ONCE(file == NULL)) {
> -				pr_warn("error on getting probe file.\n");
> -				warn++;
> -			} else
> -				enable_trace_kprobe(tk, file);
> -		}
> -	}
> -
> -	if (warn)
> -		goto end;
> -
> -	ret = target(1, 2, 3, 4, 5, 6);
> -
> -	/* Disable trace points before removing it */
> -	tk = find_trace_kprobe("testprobe", KPROBE_EVENT_SYSTEM);
> -	if (WARN_ON_ONCE(tk == NULL)) {
> -		pr_warn("error on getting test probe.\n");
> -		warn++;
> -	} else {
> -		file = find_trace_probe_file(tk, top_trace_array());
> -		if (WARN_ON_ONCE(file == NULL)) {
> -			pr_warn("error on getting probe file.\n");
> -			warn++;
> -		} else
> -			disable_trace_kprobe(tk, file);
> -	}
> -
> -	tk = find_trace_kprobe("testprobe2", KPROBE_EVENT_SYSTEM);
> -	if (WARN_ON_ONCE(tk == NULL)) {
> -		pr_warn("error on getting 2nd test probe.\n");
> -		warn++;
> -	} else {
> -		file = find_trace_probe_file(tk, top_trace_array());
> -		if (WARN_ON_ONCE(file == NULL)) {
> -			pr_warn("error on getting probe file.\n");
> -			warn++;
> -		} else
> -			disable_trace_kprobe(tk, file);
> -	}
> -
> -	ret = traceprobe_command("-:testprobe", create_trace_kprobe);
> -	if (WARN_ON_ONCE(ret)) {
> -		pr_warn("error on deleting a probe.\n");
> -		warn++;
> -	}
> -
> -	ret = traceprobe_command("-:testprobe2", create_trace_kprobe);
> -	if (WARN_ON_ONCE(ret)) {
> -		pr_warn("error on deleting a probe.\n");
> -		warn++;
> -	}
> -
> -end:
> -	release_all_trace_kprobes();
> -	if (warn)
> -		pr_cont("NG: Some tests are failed. Please check them.\n");
> -	else
> -		pr_cont("OK\n");
> -	return 0;
> -}
> -
> -late_initcall(kprobe_trace_self_tests_init);
> -
> -#endif
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
> new file mode 100644
> index 0000000..a603d3f
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
> @@ -0,0 +1,16 @@
> +#!/bin/sh
> +# description: Kprobe dynamic event with arguments
> +
> +[ -f kprobe_events ] || exit_unsupported # this is configurable
> +
> +echo 0 > events/enable
> +echo > kprobe_events
> +echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
> +grep testprobe kprobe_events
> +test -d events/kprobes/testprobe
> +echo 1 > events/kprobes/testprobe/enable
> +( echo "forked")
> +echo 0 > events/kprobes/testprobe/enable
> +echo "-:testprobe" >> kprobe_events
> +test -d events/kprobes/testprobe && exit 1 || exit 0
> +
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> new file mode 100644
> index 0000000..283c29e
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
> @@ -0,0 +1,15 @@
> +#!/bin/sh
> +# description: Kretprobe dynamic event with arguments
> +
> +[ -f kprobe_events ] || exit_unsupported # this is configurable
> +
> +echo 0 > events/enable
> +echo > kprobe_events
> +echo 'r:testprobe2 do_fork $retval' > kprobe_events
> +grep testprobe2 kprobe_events
> +test -d events/kprobes/testprobe2
> +echo 1 > events/kprobes/testprobe2/enable
> +( echo "forked")
> +echo 0 > events/kprobes/testprobe2/enable
> +echo '-:testprobe2' >> kprobe_events
> +test -d events/kprobes/testprobe2 && exit 1 || exit 0
> 

