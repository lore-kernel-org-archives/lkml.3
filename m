Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaF3GSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:18:51 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:58642 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaF3GSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:18:50 -0400
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
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of uprobe_buffer_enable() in probe_event_enable()
References: <20140627170116.GA18298@redhat.com>
	<20140627170146.GA18332@redhat.com>
Date: Mon, 30 Jun 2014 15:18:47 +0900
In-Reply-To: <20140627170146.GA18332@redhat.com> (Oleg Nesterov's message of
	"Fri, 27 Jun 2014 19:01:46 +0200")
Message-ID: <877g3y6htk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 19:01:46 +0200, Oleg Nesterov wrote:
> The usage of uprobe_buffer_enable() added by dcad1a20 is very wrong,
>
> 1. uprobe_buffer_enable() and uprobe_buffer_disable() are not balanced,
>    _enable() should be called only if !enabled.
>
> 2. If uprobe_buffer_enable() fails probe_event_enable() should clear
>    tp.flags and free event_file_link.
>
> 3. If uprobe_register() fails it should do uprobe_buffer_disable().
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks for the fix.

Acked-by: Namhyung Kim <namhyung@kernel.org>


> ---
>  kernel/trace/trace_uprobe.c |   31 +++++++++++++++++++------------
>  1 files changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index c4cf0ab..3c9b97e 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -911,26 +911,33 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
>  		tu->tp.flags |= TP_FLAG_PROFILE;
>  	}
>  
> -	ret = uprobe_buffer_enable();
> -	if (ret < 0)
> -		return ret;
> -
>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>  
>  	if (enabled)
>  		return 0;
>  
> +	ret = uprobe_buffer_enable();
> +	if (ret)
> +		goto err_flags;
> +
>  	tu->consumer.filter = filter;
>  	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> -	if (ret) {
> -		if (file) {
> -			list_del(&link->list);
> -			kfree(link);
> -			tu->tp.flags &= ~TP_FLAG_TRACE;
> -		} else
> -			tu->tp.flags &= ~TP_FLAG_PROFILE;
> -	}
> +	if (ret)
> +		goto err_buffer;
>  
> +	return 0;
> +
> + err_buffer:
> +	uprobe_buffer_disable();
> +
> + err_flags:
> +	if (file) {
> +		list_del(&link->list);
> +		kfree(link);
> +		tu->tp.flags &= ~TP_FLAG_TRACE;
> +	} else {
> +		tu->tp.flags &= ~TP_FLAG_PROFILE;
> +	}
>  	return ret;
>  }
