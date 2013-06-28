Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3F1K72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:59:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:46406 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab3F1K7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:59:25 -0400
Message-ID: <51CD6C78.5000108@huawei.com>
Date: Fri, 28 Jun 2013 18:59:04 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file base
 multibuffer
References: <51C90ECC.9030303@huawei.com> <20130627121231.GB8362@linux.vnet.ibm.com>
In-Reply-To: <20130627121231.GB8362@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/27 20:12, Srikar Dronamraju wrote:
> * zhangwei(Jovi) <jovi.zhangwei@huawei.com> [2013-06-25 11:30:20]:
> 
>> Support multi-buffer on uprobe-based dynamic events by
>> using ftrace_event_file.
>>
>> This patch is based kprobe-based dynamic events multibuffer
>> support work initially, commited by Masami(commit 41a7dd420c),
>> but revised as below:
>>
>> Oleg changed the kprobe-based multibuffer design from
>> array-pointers of ftrace_event_file into simple list,
>> so this patch also change to the list degisn.
>>
>> rcu_read_lock/unlock added into uprobe_trace_func/uretprobe_trace_func,
>> to synchronize with ftrace_event_file list add and delete.
>>
>> Even though we allow multi-uprobes instances now,
>> but TP_FLAG_PROFILE/TP_FLAG_TRACE are still mutually exclusive
>> in probe_event_enable currently, this means we cannot allow
>> one user is using uprobe-tracer, and another user is using
>> perf-probe on same uprobe concurrently.
>> (Perhaps this will be fix in future, kprobe dont't have this
>> limitation now)
>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> ---
>>  kernel/trace/trace_uprobe.c |  118 +++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 97 insertions(+), 21 deletions(-)
>>
>> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
>> index 32494fb0..dbbb4a9 100644
>> --- a/kernel/trace/trace_uprobe.c
>> +++ b/kernel/trace/trace_uprobe.c
>> @@ -53,6 +53,7 @@ struct trace_uprobe {
>>  	struct list_head		list;
>>  	struct ftrace_event_class	class;
>>  	struct ftrace_event_call	call;
>> +	struct list_head		files;
>>  	struct trace_uprobe_filter	filter;
>>  	struct uprobe_consumer		consumer;
>>  	struct inode			*inode;
>> @@ -65,6 +66,11 @@ struct trace_uprobe {
>>  	struct probe_arg		args[];
>>  };
>>
>> +struct event_file_link {
>> +	struct ftrace_event_file	*file;
>> +	struct list_head		list;
>> +};
>> +
>>  #define SIZEOF_TRACE_UPROBE(n)			\
>>  	(offsetof(struct trace_uprobe, args) +	\
>>  	(sizeof(struct probe_arg) * (n)))
>> @@ -124,6 +130,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>>  		goto error;
>>
>>  	INIT_LIST_HEAD(&tu->list);
>> +	INIT_LIST_HEAD(&tu->files);
>>  	tu->consumer.handler = uprobe_dispatcher;
>>  	if (is_ret)
>>  		tu->consumer.ret_handler = uretprobe_dispatcher;
>> @@ -511,7 +518,8 @@ static const struct file_operations uprobe_profile_ops = {
>>  };
>>
>>  static void uprobe_trace_print(struct trace_uprobe *tu,
>> -				unsigned long func, struct pt_regs *regs)
>> +				unsigned long func, struct pt_regs *regs,
>> +				struct ftrace_event_file *ftrace_file)
>>  {
>>  	struct uprobe_trace_entry_head *entry;
>>  	struct ring_buffer_event *event;
>> @@ -520,9 +528,12 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>>  	int size, i;
>>  	struct ftrace_event_call *call = &tu->call;
>>
>> +	WARN_ON(call != ftrace_file->event_call);
>> +
>>  	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
>> -	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>> -						  size + tu->size, 0, 0);
>> +	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
>> +						call->event.type,
>> +						size + tu->size, 0, 0);
>>  	if (!event)
>>  		return;
>>
>> @@ -546,15 +557,28 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>>  /* uprobe handler */
>>  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>>  {
>> -	if (!is_ret_probe(tu))
>> -		uprobe_trace_print(tu, 0, regs);
>> +	struct event_file_link *link;
>> +
>> +	if (is_ret_probe(tu))
>> +		return 0;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry(link, &tu->files, list)
>> +		uprobe_trace_print(tu, 0, regs, link->file);
>> +	rcu_read_unlock();
>> +
>>  	return 0;
>>  }
>>
>>  static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
>>  				struct pt_regs *regs)
>>  {
>> -	uprobe_trace_print(tu, func, regs);
>> +	struct event_file_link *link;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry(link, &tu->files, list)
>> +		uprobe_trace_print(tu, func, regs, link->file);
>> +	rcu_read_unlock();
>>  }
>>
>>  /* Event entry printers */
>> @@ -605,33 +629,84 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
>>  				struct mm_struct *mm);
>>
>>  static int
>> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
>> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
>> +		   filter_func_t filter)
>>  {
>> +	int enabled = 0;
>>  	int ret = 0;
>>
>> +	/* we cannot call uprobe_register twice for same tu */
>>  	if (is_trace_uprobe_enabled(tu))
>> -		return -EINTR;
>> +		enabled = 1;
>> +
>> +	if (file) {
>> +		struct event_file_link *link;
>> +
>> +		if (tu->flags & TP_FLAG_PROFILE)
>> +			return -EINTR;
>> +
>> +		link = kmalloc(sizeof(*link), GFP_KERNEL);
>> +		if (!link)
>> +			return -ENOMEM;
>> +
>> +		link->file = file;
>> +		list_add_rcu(&link->list, &tu->files);
>> +
>> +		tu->flags |= TP_FLAG_TRACE;
>> +	} else {
>> +		if (tu->flags & TP_FLAG_TRACE)
>> +			return -EINTR;
>> +
>> +		tu->flags |= TP_FLAG_PROFILE;
>> +	}
>>
>>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>>
>> -	tu->flags |= flag;
>> -	tu->consumer.filter = filter;
>> -	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
>> -	if (ret)
>> -		tu->flags &= ~flag;
>> +	if (!enabled) {
>> +		tu->consumer.filter = filter;
>> +		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
>> +		if (ret)
>> +			tu->flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
> 
> Dont we need to free link here? or where does the link that got
> allocated freed?
> 
> Think the list of files also needs to be cleaned up. No?
> 
Thanks for review, I will update it in next series.

jovi




