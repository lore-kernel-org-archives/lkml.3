Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161350Ab3DEDrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 23:47:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45669 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab3DEDrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 23:47:08 -0400
Message-ID: <515E4938.6090809@hitachi.com>
Date: Fri, 05 Apr 2013 12:47:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless local_save_flags/preempt_count
 calls
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com>
In-Reply-To: <20130404142522.GC8986@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/04 23:25), Srikar Dronamraju wrote:
> * Oleg Nesterov <oleg@redhat.com> [2013-03-29 19:15:45]:
> 
>> uprobe_trace_func() is never called with irqs or preemption
>> disabled, no need to ask preempt_count() or local_save_flags().
>>
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Adding Masami in the Cc.

Thanks :), since the running context of uprobe handler is
different from kprobe one, this change is only needed for uprobe.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
>> ---
>>  kernel/trace/trace_uprobe.c |   10 +++-------
>>  1 files changed, 3 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
>> index 8e00901..43d258d 100644
>> --- a/kernel/trace/trace_uprobe.c
>> +++ b/kernel/trace/trace_uprobe.c
>> @@ -492,17 +492,13 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>>  	struct ring_buffer_event *event;
>>  	struct ring_buffer *buffer;
>>  	u8 *data;
>> -	int size, i, pc;
>> -	unsigned long irq_flags;
>> +	int size, i;
>>  	struct ftrace_event_call *call = &tu->call;
>>
>> -	local_save_flags(irq_flags);
>> -	pc = preempt_count();
>> -
>>  	size = sizeof(*entry) + tu->size;
>>
>>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>> -						  size, irq_flags, pc);
>> +						  size, 0, 0);
>>  	if (!event)
>>  		return 0;
>>
>> @@ -513,7 +509,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
>>
>>  	if (!filter_current_check_discard(buffer, call, entry, event))
>> -		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
>> +		trace_buffer_unlock_commit(buffer, event, 0, 0);
>>
>>  	return 0;
>>  }
>> -- 
>> 1.5.5.1
>>
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


