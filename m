Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3IFMWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:22:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43425 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3IFMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:22:18 -0400
Message-ID: <5229C8F7.7060000@hitachi.com>
Date: Fri, 06 Sep 2013 21:22:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 01/10] tracing: Add support for SOFT_DISABLE to syscall
 events
References: <cover.1378176577.git.tom.zanussi@linux.intel.com> <ecf9ba5f924d48eb6517c27d5e64044f827dd9d2.1378176577.git.tom.zanussi@linux.intel.com> <20130905120111.4900aa60@gandalf.local.home>
In-Reply-To: <20130905120111.4900aa60@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/06 1:01), Steven Rostedt wrote:
> On Mon,  2 Sep 2013 22:52:17 -0500
> 
>> @@ -415,10 +429,15 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
>>  		return;
>>  	mutex_lock(&syscall_trace_lock);
>>  	tr->sys_refcount_enter--;
>> -	clear_bit(num, tr->enabled_enter_syscalls);
>> +	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
>>  	if (!tr->sys_refcount_enter)
>>  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
>>  	mutex_unlock(&syscall_trace_lock);
>> +	/*
>> +	 * Callers expect the event to be completely disabled on
>> +	 * return, so wait for current handlers to finish.
>> +	 */
>> +	synchronize_sched();
> 
> We only have to wait for rcu, not preemption correct? Then we need to
> do  synchronize_rcu() instead.

Hmm, the reason why trace_kprobe.c uses synchronize_sched() in unreg
function, is to avoid touching freeing event_file in running kprobe
handlers which run under preemption disabled.

And AFAICS, the tracepoint (on which the syscall tracer based)
call-site uses rcu_read_lock_sched_notrace() instead of rcu_read_lock(),
in that case, I think we should use synchronize_sched(). is that wrong?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


