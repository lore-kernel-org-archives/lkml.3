Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaF3Lw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:52:29 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33595 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaF3Lw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:52:28 -0400
Message-ID: <53B14F75.2040307@hitachi.com>
Date: Mon, 30 Jun 2014 20:52:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] tracing/uprobes: Revert "Support mix of ftrace and
 perf"
References: <20140627170136.GA18319@redhat.com>
In-Reply-To: <20140627170136.GA18319@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/28 2:01), Oleg Nesterov wrote:
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
> 
> This would be easy to fix, but there are other reasons why it is not
> simple to mix ftrace and perf. If nothing else, they can't share the
> same ->consumer.filter. This is fixable too, but probably we need to
> fix the poorly designed uprobe_register() interface first. At least
> "register" and "apply" should be clearly separated.

Hm, it should be a uprobes original issue. it's different from kprobes.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> Cc: stable@vger.kernel.org # v3.14
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


