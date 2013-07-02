Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3GBGyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:54:38 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:48961 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GBGyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:54:37 -0400
Message-ID: <51D27869.9090707@huawei.com>
Date: Tue, 2 Jul 2013 14:51:21 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] tracing/uprobes: Support ftrace_event_file base multibuffer
References: <51CE920C.5020001@huawei.com> <20130701202722.GA413@redhat.com>
In-Reply-To: <20130701202722.GA413@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/2 4:27, Oleg Nesterov wrote:
> On 06/29, zhangwei(Jovi) wrote:
>>
>> [v3->v4]:
> 
> I am wondering how much you will hate me if I suggest to make v5 ;)
> 
Feel free to do that :)

> But look, imho probe_event_enable() looks a bit more confusing than
> it needs.
> 
>> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
>> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
>> +		   filter_func_t filter)
>>  {
>> +	bool enabled = is_trace_uprobe_enabled(tu);
>> +	struct event_file_link *link;
>>  	int ret = 0;
> 
> Unnecessary initialization.
> 
>> -	if (is_trace_uprobe_enabled(tu))
>> -		return -EINTR;
>> +	if (file) {
>> +		if (tu->flags & TP_FLAG_PROFILE)
>> +			return -EINTR;
>> +
>> +		link = kmalloc(sizeof(*link), GFP_KERNEL);
>> +		if (!link)
>> +			return -ENOMEM;
>> +
>> +		link->file = file;
>> +		list_add_tail_rcu(&link->list, &tu->files);
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
>> +	/* we cannot call uprobe_register twice for same tu */
> 
> The comment is confusing, I'd suggest to simply remove it.
> 
> Yes, we can't do uprobe_register() twice as we already discussed.
> But it is not that we "can't", we simply do not need this if uprobe
> was already created.
> 
>> +	if (!enabled) {
>> +		tu->consumer.filter = filter;
>> +		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
>> +	}
>> +
>> +	if (ret) {
>> +		if (file) {
>> +			list_del_rcu(&link->list);
> 
> I won't insist, but _rcu is not needed in this case. Again, this looks
> a bit confusing, as if we expect that some rcu reader can ever see this
> entry. But this is not true and we are going to just kfree it without
> synchronize_rcu().
> 
Yes, _rcu is not needed in there.

>> +			kfree(link);
>> +			tu->flags &= ~TP_FLAG_TRACE;
>> +		} else
>> +			tu->flags &= ~TP_FLAG_PROFILE;
>> +	}
> 
> This is correct, but again, this is not immediately obvious.
> 
> Why it is correct to correct to clear TP_FLAG_TRACE? Because we know
> that "enabled" was false and thus we remove the single list entry.
> 
> So, perhaps,
> 
> 	if (enabled)
> 		return 0;
> 
> 	ret = uprobe_register();
> 	if (ret) {
> 		...;
> 	}
> 
> 	return ret;
> 
> will be a bit more clean.
> 
I will change it in v5 patch.

> Oleg.
> 
> 
> .
> 


