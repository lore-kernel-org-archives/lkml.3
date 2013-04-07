Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab3DGOVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:21:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56580 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781Ab3DGOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:21:31 -0400
Date: Sun, 7 Apr 2013 19:45:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes/tracing: Make seq_printf() code
 uretprobe-friendly
Message-ID: <20130407141547.GD8672@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130401160827.GA19206@redhat.com>
 <20130401160857.GA19586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130401160857.GA19586@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040714-4834-0000-0000-0000058832B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-04-01 18:08:57]:

> Change probes_seq_show() and print_uprobe_event() to check
> is_ret_probe() and print the correct data.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index f75e52d..1b3622a 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -434,9 +434,10 @@ static void probes_seq_stop(struct seq_file *m, void *v)
>  static int probes_seq_show(struct seq_file *m, void *v)
>  {
>  	struct trace_uprobe *tu = v;
> +	char c = is_ret_probe(tu) ? 'r' : 'p';
>  	int i;
> 
> -	seq_printf(m, "p:%s/%s", tu->call.class->system, tu->call.name);
> +	seq_printf(m, "%c:%s/%s", c, tu->call.class->system, tu->call.name);
>  	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
> 
>  	for (i = 0; i < tu->nr_args; i++)
> @@ -569,10 +570,18 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
>  	entry = (struct uprobe_trace_entry_head *)iter->ent;
>  	tu = container_of(event, struct trace_uprobe, call.event);
> 
> -	if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name, entry->vaddr[0]))
> -		goto partial;
> +	if (is_ret_probe(tu)) {
> +		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->call.name,
> +					entry->vaddr[1], entry->vaddr[0]))
> +			goto partial;
> +		data = DATAOF_TRACE_ENTRY(entry, 2);
> +	} else {
> +		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name,
> +					entry->vaddr[0]))
> +			goto partial;
> +		data = DATAOF_TRACE_ENTRY(entry, 1);
> +	}
> 
> -	data = DATAOF_TRACE_ENTRY(entry, 1);
>  	for (i = 0; i < tu->nr_args; i++) {
>  		if (!tu->args[i].type->print(s, tu->args[i].name,
>  					     data + tu->args[i].offset, entry))
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

