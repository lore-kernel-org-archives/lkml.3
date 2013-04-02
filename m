Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab3DBI7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760790Ab3DBI7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:59:41 -0400
Date: Tue, 2 Apr 2013 10:59:32 +0200
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uprobes/tracing: generalize struct
 uprobe_trace_entry_head
Message-ID: <20130402085932.GE24889@bandura.brq.redhat.com>
References: <20130329181520.GA20670@redhat.com>
 <20130329181548.GA20700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329181548.GA20700@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 07:15:48PM +0100, Oleg Nesterov wrote:
> struct uprobe_trace_entry_head has a single member for reporting,
> "unsigned long ip". If we want to support uretprobes we need to
> create another struct which has "func" and "ret_ip" and duplicate
> a lot of functions, like trace_kprobe.c does.
> 
> To avoid this copy-and-paste horror we turn ->ip into ->vaddr[]
> and add couple of trivial helpers to calculate sizeof/data. This
> uglifies the code a bit, but this allows us to avoid a lot more
> complications later, when we add the support for ret-probes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace.h        |    5 ---
>  kernel/trace/trace_uprobe.c |   61 ++++++++++++++++++++++++------------------
>  2 files changed, 35 insertions(+), 31 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 57d7e53..6ca57cf 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -103,11 +103,6 @@ struct kretprobe_trace_entry_head {
>  	unsigned long		ret_ip;
>  };
>  
> -struct uprobe_trace_entry_head {
> -	struct trace_entry	ent;
> -	unsigned long		ip;
> -};
> -
>  /*
>   * trace_flag_type is an enumeration that holds different
>   * states when a trace occurs. These are:
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 43d258d..92a4b08 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -28,6 +28,17 @@
>  
>  #define UPROBE_EVENT_SYSTEM	"uprobes"
>  
> +struct uprobe_trace_entry_head {
> +	struct trace_entry	ent;
> +	unsigned long		vaddr[];
> +};
> +
> +#define SIZEOF_TRACE_ENTRY(nr)	\
> +	(sizeof(struct uprobe_trace_entry_head) + sizeof(unsigned long) * (nr))
> +
> +#define DATAOF_TRACE_ENTRY(entry, nr)	\
> +	((void*)&(entry)->vaddr[nr])
> +
>  struct trace_uprobe_filter {
>  	rwlock_t		rwlock;
>  	int			nr_systemwide;
> @@ -491,20 +502,19 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	struct uprobe_trace_entry_head *entry;
>  	struct ring_buffer_event *event;
>  	struct ring_buffer *buffer;
> -	u8 *data;
> +	void *data;
>  	int size, i;
>  	struct ftrace_event_call *call = &tu->call;
>  
> -	size = sizeof(*entry) + tu->size;
> -
> +	size = SIZEOF_TRACE_ENTRY(1) + tu->size;
>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>  						  size, 0, 0);
>  	if (!event)
>  		return 0;
>  
>  	entry = ring_buffer_event_data(event);
> -	entry->ip = instruction_pointer(regs);
> -	data = (u8 *)&entry[1];
> +	entry->vaddr[0] = instruction_pointer(regs);
> +	data = DATAOF_TRACE_ENTRY(entry, 1);
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
>  
> @@ -518,22 +528,22 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  static enum print_line_t
>  print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *event)
>  {
> -	struct uprobe_trace_entry_head *field;
> +	struct uprobe_trace_entry_head *entry;
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_uprobe *tu;
>  	u8 *data;
>  	int i;
>  
> -	field = (struct uprobe_trace_entry_head *)iter->ent;
> +	entry = (struct uprobe_trace_entry_head *)iter->ent;
>  	tu = container_of(event, struct trace_uprobe, call.event);
>  
> -	if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name, field->ip))
> +	if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name, entry->vaddr[0]))
>  		goto partial;
>  
> -	data = (u8 *)&field[1];
> +	data = DATAOF_TRACE_ENTRY(entry, 1);
>  	for (i = 0; i < tu->nr_args; i++) {
>  		if (!tu->args[i].type->print(s, tu->args[i].name,
> -					     data + tu->args[i].offset, field))
> +					     data + tu->args[i].offset, entry))
>  			goto partial;
>  	}
>  
> @@ -585,16 +595,17 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
>  
>  static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
>  {
> -	int ret, i;
> +	int ret, i, size;
>  	struct uprobe_trace_entry_head field;
> -	struct trace_uprobe *tu = (struct trace_uprobe *)event_call->data;
> +	struct trace_uprobe *tu = event_call->data;
>  
> -	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
> +	DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_IP, 0);
> +	size = SIZEOF_TRACE_ENTRY(1);
>  	/* Set argument names as fields */
>  	for (i = 0; i < tu->nr_args; i++) {
>  		ret = trace_define_field(event_call, tu->args[i].type->fmttype,
>  					 tu->args[i].name,
> -					 sizeof(field) + tu->args[i].offset,
> +					 size + tu->args[i].offset,
>  					 tu->args[i].type->size,
>  					 tu->args[i].type->is_signed,
>  					 FILTER_OTHER);
> @@ -748,33 +759,31 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	struct ftrace_event_call *call = &tu->call;
>  	struct uprobe_trace_entry_head *entry;
>  	struct hlist_head *head;
> -	u8 *data;
> -	int size, __size, i;
> -	int rctx;
> +	unsigned long ip;
> +	void *data;
> +	int size, rctx, i;
>  
>  	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
>  		return UPROBE_HANDLER_REMOVE;
>  
> -	__size = sizeof(*entry) + tu->size;
> -	size = ALIGN(__size + sizeof(u32), sizeof(u64));
> -	size -= sizeof(u32);
> +	size = SIZEOF_TRACE_ENTRY(1);
> +	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
>  	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
>  		return 0;
>  
>  	preempt_disable();
> -
>  	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
>  	if (!entry)
>  		goto out;
>  
> -	entry->ip = instruction_pointer(regs);
> -	data = (u8 *)&entry[1];
> +	ip = instruction_pointer(regs);
> +	entry->vaddr[0] = ip;
> +	data = DATAOF_TRACE_ENTRY(entry, 1);
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
>  
>  	head = this_cpu_ptr(call->perf_events);
> -	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head, NULL);
> -
> +	perf_trace_buf_submit(entry, size, rctx, ip, 1, regs, head, NULL);
>   out:
>  	preempt_enable();
>  	return 0;
> @@ -784,7 +793,7 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  static
>  int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type, void *data)
>  {
> -	struct trace_uprobe *tu = (struct trace_uprobe *)event->data;
> +	struct trace_uprobe *tu = event->data;
>  
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -- 
> 1.5.5.1
> 
Acked-by: Anton Arapov <anton@redhat.com>
