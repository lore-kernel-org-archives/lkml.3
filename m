Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3FQCzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 22:55:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50972 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3FQCzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:55:03 -0400
Message-ID: <51BE7A83.9060802@hitachi.com>
Date: Mon, 17 Jun 2013 11:54:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base multibuffer
References: <51BA7578.4080108@huawei.com> <51BB18EB.9080307@hitachi.com> <1371223918.9844.324.camel@gandalf.local.home> <20130614162112.GO5146@linux.vnet.ibm.com> <1371227607.9844.335.camel@gandalf.local.home> <20130614172516.GP5146@linux.vnet.ibm.com>
In-Reply-To: <20130614172516.GP5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/15 2:25), Paul E. McKenney wrote:
> On Fri, Jun 14, 2013 at 12:33:27PM -0400, Steven Rostedt wrote:
>> On Fri, 2013-06-14 at 09:21 -0700, Paul E. McKenney wrote:
>>
>>>>>> @@ -548,15 +556,35 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>>>>>>  /* uprobe handler */
>>>>>>  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>>>>>>  {
>>>>>> -	if (!is_ret_probe(tu))
>>>>>> -		uprobe_trace_print(tu, 0, regs);
>>>>>> +	struct ftrace_event_file **file;
>>>>>> +
>>>>>> +	if (is_ret_probe(tu))
>>>>>> +		return 0;
>>>>>> +
>>>>>> +	file = rcu_dereference_raw(tu->files);
>>>>
>>>> Why are you using rcu_dereference_raw() and not rcu_dereference(). The
>>>> _raw() is a bit special, and unless you know what you are doing with RCU
>>>> here, don't use it.
>>>>
>>>> As I see you using rcu_dereference_raw() all over this patch, along with
>>>> mutexes, I believe that you are not using RCU correctly here.
>>>
>>> If irqs and preempt are disabled, I suggest using rcu_dereference_sched().
>>> That is what it is there for.  ;-)
>>
>> I believe this just copied what kprobes did, where irqs and preemption
>> is disabled. I don't believe that these probes have that same luxury.
>>
>> But that begs the question. Should we convert the rcu_dereference_raw()
>> in the kprobe code to rcu_dereference_sched()?
> 
> It makes a lot of sense to me, at least assuming no issues with the
> interrupts being disabled, but the checks not spotting this.  Here
> is the check:
> 
> 	preempt_count() != 0 || irqs_disabled()
> 
> (With additional elaboration for if lockdep is enabled.)

OK, I see. So I'll convert all the rcu_dereference_raw() to
rcu_dereference_sched() except kprobe handler, because in the
kprobe handler above check always be true. :)

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


