Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaF3Ltf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:49:35 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33135 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaF3Lt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:49:29 -0400
Message-ID: <53B14EC2.9000508@hitachi.com>
Date: Mon, 30 Jun 2014 20:49:22 +0900
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
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of uprobe_buffer_enable()
 in probe_event_enable()
References: <20140627170146.GA18332@redhat.com>
In-Reply-To: <20140627170146.GA18332@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/28 2:01), Oleg Nesterov wrote:
> The usage of uprobe_buffer_enable() added by dcad1a20 is very wrong,
> 
> 1. uprobe_buffer_enable() and uprobe_buffer_disable() are not balanced,
>    _enable() should be called only if !enabled.
> 
> 2. If uprobe_buffer_enable() fails probe_event_enable() should clear
>    tp.flags and free event_file_link.
> 
> 3. If uprobe_register() fails it should do uprobe_buffer_disable().

Looks good to me ;)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks,

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
>  
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


