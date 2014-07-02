Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaGBFct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:32:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:34926 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaGBFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:32:47 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 11/14] tracing: allow eBPF programs to be attached to events
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
	<1403913966-4927-12-git-send-email-ast@plumgrid.com>
Date: Wed, 02 Jul 2014 14:32:45 +0900
In-Reply-To: <1403913966-4927-12-git-send-email-ast@plumgrid.com> (Alexei
	Starovoitov's message of "Fri, 27 Jun 2014 17:06:03 -0700")
Message-ID: <87tx70496q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 17:06:03 -0700, Alexei Starovoitov wrote:
> User interface:
> cat bpf_123 > /sys/kernel/debug/tracing/__event__/filter
>
> where 123 is an id of the eBPF program priorly loaded.
> __event__ is static tracepoint event.
> (kprobe events will be supported in the future patches)
>
> eBPF programs can call in-kernel helper functions to:
> - lookup/update/delete elements in maps
> - memcmp
> - trace_printk

ISTR Steve doesn't like to use trace_printk() (at least for production
kernels) anymore.  And I'm not sure it'd work if there's no existing
trace_printk() on a system.

> - load_pointer
> - dump_stack


[SNIP]
> @@ -634,6 +635,15 @@ ftrace_raw_event_##call(void *__data, proto)				\
>  	if (ftrace_trigger_soft_disabled(ftrace_file))			\
>  		return;							\
>  									\
> +	if (unlikely(ftrace_file->flags & FTRACE_EVENT_FL_FILTERED) &&	\
> +	    unlikely(ftrace_file->event_call->flags & TRACE_EVENT_FL_BPF)) { \
> +		struct bpf_context __ctx;				\
> +									\
> +		populate_bpf_context(&__ctx, args, 0, 0, 0, 0, 0);	\
> +		trace_filter_call_bpf(ftrace_file->filter, &__ctx);	\
> +		return;							\
> +	}								\
> +									\

Hmm..  But it seems the eBPF prog is not a filter - it'd always drop the
event.  And I think it's better to use a recorded entry rather then args
as a bpf_context so that tools like perf can manipulate it at compile
time based on the event format.

Thanks,
Namhyung


>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>  									\
>  	entry = ftrace_event_buffer_reserve(&fbuffer, ftrace_file,	\
