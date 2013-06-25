Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3FYU2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3FYU2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:28:36 -0400
Date: Tue, 25 Jun 2013 22:24:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130625202405.GA16143@redhat.com>
References: <51C90ECC.9030303@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C90ECC.9030303@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry again, didn't have time to review, will try tomorrow.

Looks good but a couple of minor nits, and perhaps we should
fix the bugs with unregister_trace_uprobe first... in kprobes
too _if_ I am right. I'll return tomorrow.

On 06/25, zhangwei(Jovi) wrote:
>
> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
> +		   filter_func_t filter)
>  {
> +	int enabled = 0;
>  	int ret = 0;
> 
> +	/* we cannot call uprobe_register twice for same tu */
>  	if (is_trace_uprobe_enabled(tu))
> -		return -EINTR;
> +		enabled = 1;

Cosmetic again, "int enabled = 0" and then "if (is_trace_uprobe_enabled)"
looks a bit strange,

	enabled = is_trace_uprobe_enabled();

looks a bit more clean.

> +	if (file) {
> +		struct event_file_link *link;
> +
> +		if (tu->flags & TP_FLAG_PROFILE)
> +			return -EINTR;
> +
> +		link = kmalloc(sizeof(*link), GFP_KERNEL);
> +		if (!link)
> +			return -ENOMEM;
> +
> +		link->file = file;
> +		list_add_rcu(&link->list, &tu->files);

I agree with Masami, list_add_rcu_tail() looks better even if this
doesn't really matter.

Oleg.

