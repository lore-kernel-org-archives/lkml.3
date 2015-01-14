Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbbANANR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:13:17 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:53628 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbANANQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:13:16 -0500
Message-ID: <54B5B478.1020401@huawei.com>
Date: Wed, 14 Jan 2015 08:12:40 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>,
        <mathieu.desnoyers@efficios.com>,
        xiakaixu 00238161 <xiakaixu@huawei.com>
Subject: Re: [PATCH 1/2] tracing: Move enabling tracepoints to just after
 rcu_init()
References: <E1Y9QLr-0000h7-Qw@feisty.vs19.net> <54AF53BD.5070303@huawei.com>
In-Reply-To: <54AF53BD.5070303@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54B5B48B.00C0,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 29a38bc1690dc2ec4f8c64daf7367b02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

On 2015/1/9 12:06, Wang Nan wrote:
> Hi Steven Rostedt,
> 
> During studying your code we find a problem, please see below.
> 
>>
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> Enabling tracepoints at boot up can be very useful. The tracepoint
>> can be initialized right after RCU has been. There's no need to
>> wait for the early_initcall() to be called. That's too late for some
>> things that can use tracepoints for debugging. Move the logic to
>> enable tracepoints out of the initcalls and into init/main.c to
>> right after rcu_init().
>>
>> This also allows trace_printk() to be used early too.
>>
>> Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos
>> Link: http://lkml.kernel.org/r/20141214164104.307127356@goodmis.org
>>
>> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Tested-by: Thomas Gleixner <tglx@linutronix.de>
>> Acked-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> [...]
> 
>> +void __init trace_init(void)
>> +{
>> +	tracer_alloc_buffers();
>> +	init_ftrace_syscalls();
>> +	trace_event_init();	
>> +}
>> +
> 
> [...]
> 
>> +
>> +void __init trace_event_init(void)
>> +{
>> +	event_trace_memsetup();
>> +	init_ftrace_syscalls();
>> +	event_trace_enable();
>> +}
>> +
> 
> init_ftrace_syscalls() get called twice by trace_init() and trace_event_init(), some resources are wasted.
> At lease one of them can be removed.
> 
> In addition, could you please have a look at my early kprobe patch series?
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/313835.html
> 
> Which enables kprobe very early, even before memory initialized. I think it is possible to combine these
> early tracing facilities together.
> 
> Thank you!
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


