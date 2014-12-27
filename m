Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaL0HDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 02:03:22 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43635 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaL0HDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 02:03:20 -0500
From: SeongJae Park <sj38.park@gmail.com>
X-Google-Original-From: SeongJae Park <sjpark@hxeon>
Date: Sat, 27 Dec 2014 16:04:04 +0900 (KST)
To: "Stefan I. Strogin" <s.strogin@partner.samsung.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 1/3] stacktrace: add seq_print_stack_trace()
In-Reply-To: <00bfb81bf8749f3be738d20dd263b81490693309.1419602920.git.s.strogin@partner.samsung.com>
Message-ID: <alpine.DEB.2.10.1412271602580.1819@hxeon>
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <00bfb81bf8749f3be738d20dd263b81490693309.1419602920.git.s.strogin@partner.samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Dec 2014, Stefan I. Strogin wrote:

> Add a function seq_print_stack_trace() which prints stacktraces to seq_files.
>
> Signed-off-by: Stefan I. Strogin <s.strogin@partner.samsung.com>

Reviewed-by: SeongJae Park <sj38.park@gmail.com>

> ---
> include/linux/stacktrace.h |  4 ++++
> kernel/stacktrace.c        | 17 +++++++++++++++++
> 2 files changed, 21 insertions(+)
>
> diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
> index 669045a..6d62484 100644
> --- a/include/linux/stacktrace.h
> +++ b/include/linux/stacktrace.h
> @@ -2,6 +2,7 @@
> #define __LINUX_STACKTRACE_H
>
> #include <linux/types.h>
> +#include <linux/seq_file.h>
>
> struct task_struct;
> struct pt_regs;
> @@ -24,6 +25,8 @@ extern void save_stack_trace_tsk(struct task_struct *tsk,
> extern void print_stack_trace(struct stack_trace *trace, int spaces);
> extern int snprint_stack_trace(char *buf, size_t size,
> 			struct stack_trace *trace, int spaces);
> +extern void seq_print_stack_trace(struct seq_file *m,
> +			struct stack_trace *trace, int spaces);
>
> #ifdef CONFIG_USER_STACKTRACE_SUPPORT
> extern void save_stack_trace_user(struct stack_trace *trace);
> @@ -37,6 +40,7 @@ extern void save_stack_trace_user(struct stack_trace *trace);
> # define save_stack_trace_user(trace)			do { } while (0)
> # define print_stack_trace(trace, spaces)		do { } while (0)
> # define snprint_stack_trace(buf, size, trace, spaces)	do { } while (0)
> +# define seq_print_stack_trace(m, trace, spaces)	do { } while (0)
> #endif
>
> #endif
> diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
> index b6e4c16..66ef6f4 100644
> --- a/kernel/stacktrace.c
> +++ b/kernel/stacktrace.c
> @@ -57,6 +57,23 @@ int snprint_stack_trace(char *buf, size_t size,
> }
> EXPORT_SYMBOL_GPL(snprint_stack_trace);
>
> +void seq_print_stack_trace(struct seq_file *m, struct stack_trace *trace,
> +			int spaces)
> +{
> +	int i;
> +
> +	if (WARN_ON(!trace->entries))
> +		return;
> +
> +	for (i = 0; i < trace->nr_entries; i++) {
> +		unsigned long ip = trace->entries[i];
> +
> +		seq_printf(m, "%*c[<%p>] %pS\n", 1 + spaces, ' ',
> +				(void *) ip, (void *) ip);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(seq_print_stack_trace);
> +
> /*
>  * Architectures that do not implement save_stack_trace_tsk or
>  * save_stack_trace_regs get this weak alias and a once-per-bootup warning
> -- 
> 2.1.0
>
>
