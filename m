Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaF3GEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:04:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42700 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaF3GEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:04:35 -0400
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
Subject: Re: [PATCH 1/4] tracing/uprobes: Revert "Support mix of ftrace and perf"
References: <20140627170116.GA18298@redhat.com>
	<20140627170136.GA18319@redhat.com>
Date: Mon, 30 Jun 2014 14:49:33 +0900
In-Reply-To: <20140627170136.GA18319@redhat.com> (Oleg Nesterov's message of
	"Fri, 27 Jun 2014 19:01:36 +0200")
Message-ID: <87k37z54lu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Fri, 27 Jun 2014 19:01:36 +0200, Oleg Nesterov wrote:
> This reverts commit 43fe98913c9f67e3b523615ee3316f9520a623e0.
>
> This patch is very wrong. Firstly, this change leads to unbalanced
> uprobe_unregister(). Just for example,
>
> 	# perf probe -x /lib/libc.so.6 syscall
> 	# echo 1 >> /sys/kernel/debug/tracing/events/probe_libc/enable
> 	# perf record -e probe_libc:syscall whatever
>
> after that uprobe is dead (unregistered) but the user of ftrace/perf
> can't know this, and it looks as if nobody hits this probe.

Nah, I missed to check the unregister path.. :-/

>
> This would be easy to fix, but there are other reasons why it is not
> simple to mix ftrace and perf. If nothing else, they can't share the
> same ->consumer.filter. This is fixable too, but probably we need to
> fix the poorly designed uprobe_register() interface first. At least
> "register" and "apply" should be clearly separated.

Hmm.. right.  It seems the current filter logic only cares about the
perf.  If ftrace comes after perf, it might not see some events due to
the filter, right?

>
> Cc: stable@vger.kernel.org # v3.14
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  kernel/trace/trace_uprobe.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 04fdb5d..08e7970 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -893,6 +893,9 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
>  	int ret;
>  
>  	if (file) {
> +		if (tu->tp.flags & TP_FLAG_PROFILE)
> +			return -EINTR;
> +
>  		link = kmalloc(sizeof(*link), GFP_KERNEL);
>  		if (!link)
>  			return -ENOMEM;
> @@ -901,8 +904,12 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
>  		list_add_tail_rcu(&link->list, &tu->tp.files);
>  
>  		tu->tp.flags |= TP_FLAG_TRACE;
> -	} else
> +	} else {
> +		if (tu->tp.flags & TP_FLAG_TRACE)
> +			return -EINTR;
> +
>  		tu->tp.flags |= TP_FLAG_PROFILE;
> +	}
>  
>  	ret = uprobe_buffer_enable();
>  	if (ret < 0)
