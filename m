Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3A1MLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:11:05 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56370 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3A1MLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:11:03 -0500
Date: Mon, 28 Jan 2013 17:39:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes: Fully initialize uprobe_trace_consumer
 before uprobe_register()
Message-ID: <20130128120926.GC29865@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130127194814.GA25377@redhat.com>
 <20130127194837.GA25402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130127194837.GA25402@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012812-7014-0000-0000-000002859430
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-27 20:48:37]:

> probe_event_enable() does uprobe_register() and only after that sets
> utc->tu and tu->consumer/flags. This can race with uprobe_dispatcher()
> which can miss these assignments or see them out of order. Nothing
> really bad can happen, but this doesn't look clean/safe.
> 
> And this does not allow to use uprobe_consumer->filter() we are going
> to add, it is called by uprobe_register() and it needs utc->tu.
> 
> Change this code to initialize everything before uprobe_register(), and
> reset tu->consumer/flags if it fails. We can't race with event_disable(),
> the caller holds event_mutex, and if we could the code would be wrong
> anyway.
> 
> In fact I think uprobe_trace_consumer should die, it buys nothing but
> complicate the code. We can simply add uprobe_consumer into trace_uprobe.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 53afabe..94d4ea2 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -552,17 +552,18 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
>  		return -EINTR;
> 
>  	utc->cons.handler = uprobe_dispatcher;
> +	utc->tu = tu;
> +	tu->consumer = utc;
> +	tu->flags |= flag;
> +
>  	ret = uprobe_register(tu->inode, tu->offset, &utc->cons);
>  	if (ret) {
> +		tu->consumer = NULL;
> +		tu->flags &= ~flag;
>  		kfree(utc);
> -		return ret;
>  	}
> 
> -	tu->flags |= flag;
> -	utc->tu = tu;
> -	tu->consumer = utc;
> -
> -	return 0;
> +	return ret;
>  }
> 
>  static void probe_event_disable(struct trace_uprobe *tu, int flag)
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

