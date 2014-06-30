Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaF3GDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:03:33 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38029 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaF3GDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:03:32 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tracing/uprobes: Kill the bogus UPROBE_HANDLER_REMOVE code in uprobe_dispatcher()
References: <20140627170116.GA18298@redhat.com>
	<20140627170143.GA18329@redhat.com>
Date: Mon, 30 Jun 2014 15:03:29 +0900
In-Reply-To: <20140627170143.GA18329@redhat.com> (Oleg Nesterov's message of
	"Fri, 27 Jun 2014 19:01:43 +0200")
Message-ID: <87bntb53ym.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 19:01:43 +0200, Oleg Nesterov wrote:
> I do not know why dd9fa555d7bb "tracing/uprobes: Move argument fetching
> to uprobe_dispatcher()" added the UPROBE_HANDLER_REMOVE, but it looks
> wrong.
>
> OK, perhaps it makes sense to avoid store_trace_args() if the tracee is
> nacked by uprobe_perf_filter(). But then we should kill the same code
> in uprobe_perf_func() and unify the TRACE/PROFILE filtering (we need to
> do this anyway to mix perf/ftrace). Until then this code actually adds
> the pessimization because uprobe_perf_filter() will be called twice and
> return T in likely case.

Right, I wanted to avoid to call the store_trace_args() which might be
costly if possible.  But it seems not necessary since it doesn't get
called once handler returns UPROBE_HANDLER_REMOVE.  And we need to fix
the filtering first..

So I'm okay with removing this "pessimization". :)

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_uprobe.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 08e7970..c4cf0ab 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -1208,12 +1208,6 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
>  
>  	current->utask->vaddr = (unsigned long) &udd;
>  
> -#ifdef CONFIG_PERF_EVENTS
> -	if ((tu->tp.flags & TP_FLAG_TRACE) == 0 &&
> -	    !uprobe_perf_filter(&tu->consumer, 0, current->mm))
> -		return UPROBE_HANDLER_REMOVE;
> -#endif
> -
>  	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
>  		return 0;
