Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3BDRBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:01:49 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35381 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3BDRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:01:47 -0500
Date: Mon, 4 Feb 2013 22:29:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes/tracing: Kill uprobe_trace_consumer, embed
 uprobe_consumer into trace_uprobe
Message-ID: <20130204165945.GB4246@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130131191752.GA30410@redhat.com>
 <20130131191829.GA30454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130131191829.GA30454@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020416-5490-0000-0000-000002EAAF25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:29]:

> trace_uprobe->consumer and "struct uprobe_trace_consumer" add the
> unnecessary indirection and complicate the code for no reason.
> 
> This patch simply embeds uprobe_consumer into "struct trace_uprobe",
> all other changes only fix the compilation errors.
> 

I know this patch doesnt change the current behaviour.

We dont handle two concurrent perf record sessions for the same user
space probe. Since both sessons share the same trace_uprobe and hence
share the same consumer. Initially I had thought of having a chain in
uprobe_trace_consumer. However we dont get have enough information at
the probe_event_disable() time to detect which consumer to delete Hence
I dropped the idea of having a list of consumers attached to the
trace_uprobe.

However with allowing prefiltering, we need to have ability to
distinguish consumers. The idea of embedding uprobe_consumer within
trace_uprobe, may make the problem even more tougher to solve.

Should we document this as a TODO?


> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_uprobe.c |   35 ++++++-----------------------------
>  1 files changed, 6 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 947379a..55cdc14 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -31,17 +31,11 @@
>  /*
>   * uprobe event core functions
>   */
> -struct trace_uprobe;
> -struct uprobe_trace_consumer {
> -	struct uprobe_consumer		cons;
> -	struct trace_uprobe		*tu;
> -};
> -
>  struct trace_uprobe {
>  	struct list_head		list;
>  	struct ftrace_event_class	class;
>  	struct ftrace_event_call	call;
> -	struct uprobe_trace_consumer	*consumer;
> +	struct uprobe_consumer		consumer;
>  	struct inode			*inode;
>  	char				*filename;
>  	unsigned long			offset;
> @@ -92,6 +86,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs)
>  		goto error;
> 
>  	INIT_LIST_HEAD(&tu->list);
> +	tu->consumer.handler = uprobe_dispatcher;
>  	return tu;
> 
>  error:
> @@ -543,27 +538,15 @@ static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
> 
>  static int probe_event_enable(struct trace_uprobe *tu, int flag)
>  {
> -	struct uprobe_trace_consumer *utc;
>  	int ret = 0;
> 
>  	if (is_trace_uprobe_enabled(tu))
>  		return -EINTR;
> 
> -	utc = kzalloc(sizeof(struct uprobe_trace_consumer), GFP_KERNEL);
> -	if (!utc)
> -		return -EINTR;
> -
> -	utc->cons.handler = uprobe_dispatcher;
> -	utc->tu = tu;
> -	tu->consumer = utc;
>  	tu->flags |= flag;
> -
> -	ret = uprobe_register(tu->inode, tu->offset, &utc->cons);
> -	if (ret) {
> -		tu->consumer = NULL;
> +	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> +	if (ret)
>  		tu->flags &= ~flag;
> -		kfree(utc);
> -	}
> 
>  	return ret;
>  }
> @@ -573,10 +556,8 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
>  	if (!is_trace_uprobe_enabled(tu))
>  		return;
> 
> -	uprobe_unregister(tu->inode, tu->offset, &tu->consumer->cons);
> +	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
>  	tu->flags &= ~flag;
> -	kfree(tu->consumer);
> -	tu->consumer = NULL;
>  }
> 
>  static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
> @@ -714,13 +695,9 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
> 
>  static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
>  {
> -	struct uprobe_trace_consumer *utc;
>  	struct trace_uprobe *tu;
> 
> -	utc = container_of(con, struct uprobe_trace_consumer, cons);
> -	tu = utc->tu;
> -	if (!tu || tu->consumer != utc)
> -		return 0;
> +	tu = container_of(con, struct trace_uprobe, consumer);
> 
>  	if (tu->flags & TP_FLAG_TRACE)
>  		uprobe_trace_func(tu, regs);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

