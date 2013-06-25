Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3FYDZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:25:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59506 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3FYDZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:25:11 -0400
Message-ID: <51C90D55.4020805@huawei.com>
Date: Tue, 25 Jun 2013 11:24:05 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/uprobes: Support ftrace_event_file base multibuffer
References: <51C7ED2B.4040701@huawei.com> <20130624180547.GA2794@redhat.com>
In-Reply-To: <20130624180547.GA2794@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/25 2:05, Oleg Nesterov wrote:
> Hi Jovi,
> 
> I'll try to read this patch carefully tomorrow.
> 
> Looks fine at first glance, but some nits below.
> 
> On 06/24, zhangwei(Jovi) wrote:
>>
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
>> +
>> +	list_for_each_entry(link, &tu->files, list)
>> +		uprobe_trace_print(tu, 0, regs, link->file);
>> +
>> +	rcu_read_unlock();
> 
> Purely cosmetic and I won't argue, but why the empty lines around
> list_for_each_entry() ?
> 
>>  static int
>> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
>> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
>> +		   filter_func_t filter)
>>  {
>> +	int enabled = 0;
>>  	int ret = 0;
>>
>> -	if (is_trace_uprobe_enabled(tu))
>> +	/*
>> +	 * Currently TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually exclusive
>> +	 * for uprobe(filter argument issue), this need to fix in future.
>> +	 */
>> +	if ((file && (tu->flags & TP_FLAG_PROFILE)) ||
>> +	    (!file && (tu->flags & TP_FLAG_TRACE)))
>>  		return -EINTR;
> 
> Well, this looks confusing and overcomplicated, see below.
> 
>> +	/* Currently we cannot call uprobe_register twice for same tu */
>> +	if (is_trace_uprobe_enabled(tu))
>> +		enabled = 1;
> 
> The comment is wrong. It is not that we can't do this "Currently".
> 
> We must not do uprobe_register(..., consumer) twice, consumer/uprobe
> are linked together.
> 
>> +	if (file) {
>> +		struct event_file_link *link;
>> +
> 
> Just add
> 		if (TP_FLAG_PROFILE)
> 			return -EINTR;
> 
> here and kill the complicated check below. Same for the "else" branch.
> 
>> +static void
>> +probe_event_disable(struct trace_uprobe *tu, struct ftrace_event_file *file)
>> +{
>> +	if (file) {
>> +		struct event_file_link *link;
>> +
>> +		link = find_event_file_link(tu, file);
>> +		if (!link)
>> +			return;
>> +
>> +		list_del_rcu(&link->list);
>> +		/* synchronize with uprobe_trace_func/uretprobe_trace_func */
>> +		synchronize_sched();
>> +		kfree(link);
>> +
>> +		if (!list_empty(&tu->files))
>> +			return;
>> +
>> +		tu->flags &= ~TP_FLAG_TRACE;
>> +	} else
>> +		tu->flags &= ~TP_FLAG_PROFILE;
>> +
>>
>>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>>
>> -	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
>> -	tu->flags &= ~flag;
>> +	if (!is_trace_uprobe_enabled(tu))
>> +		uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
> 
> Well, this is not exactly right... Currently this is fine, but still.
> 
> It would be better to clear TP_FLAG_TRACE/TP_FLAG_PROFILE after
> uprobe_unregister(), when we can't race with the running handler
> which can check ->flags.
> 
> And I'd suggest you to send the soft-enable/disable change in a
> separate (and trivial) patch.
> 
> Oleg.
Thanks Oleg, you are right, please check v3 patch.

.jovi


