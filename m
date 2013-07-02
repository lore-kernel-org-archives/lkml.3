Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3GBL04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:26:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52404 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3GBL0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:26:55 -0400
Message-ID: <51D2B8FB.6060006@hitachi.com>
Date: Tue, 02 Jul 2013 20:26:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] tracing/uprobes: Support ftrace_event_file base
 multibuffer
References: <51CE920C.5020001@huawei.com>
In-Reply-To: <51CE920C.5020001@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A comment I just have is a cosmetic one.

(2013/06/29 16:51), zhangwei(Jovi) wrote:
> @@ -605,33 +629,87 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
>  				struct mm_struct *mm);
> 
>  static int
> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
> +		   filter_func_t filter)
>  {
> +	bool enabled = is_trace_uprobe_enabled(tu);
> +	struct event_file_link *link;
>  	int ret = 0;
> 
> -	if (is_trace_uprobe_enabled(tu))
> -		return -EINTR;
> +	if (file) {
> +		if (tu->flags & TP_FLAG_PROFILE)
> +			return -EINTR;
> +
> +		link = kmalloc(sizeof(*link), GFP_KERNEL);
> +		if (!link)
> +			return -ENOMEM;
> +
> +		link->file = file;
> +		list_add_tail_rcu(&link->list, &tu->files);
> +
> +		tu->flags |= TP_FLAG_TRACE;
> +	} else {
> +		if (tu->flags & TP_FLAG_TRACE)
> +			return -EINTR;
> +
> +		tu->flags |= TP_FLAG_PROFILE;
> +	}
> 
>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
> 
> -	tu->flags |= flag;
> -	tu->consumer.filter = filter;
> -	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> -	if (ret)
> -		tu->flags &= ~flag;
> +	/* we cannot call uprobe_register twice for same tu */
> +	if (!enabled) {
> +		tu->consumer.filter = filter;
> +		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> +	}
> +
> +	if (ret) {

Here, since the ret is only changed by uprobe_register, this block
would better be included in the above block. :)

> +		if (file) {
> +			list_del_rcu(&link->list);
> +			kfree(link);
> +			tu->flags &= ~TP_FLAG_TRACE;
> +		} else
> +			tu->flags &= ~TP_FLAG_PROFILE;
> +	}
> 
>  	return ret;
>  }

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


