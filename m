Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaKXCnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:43:12 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39285 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKXCnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:43:09 -0500
Message-ID: <54729B35.3040501@hitachi.com>
Date: Mon, 24 Nov 2014 11:43:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH ftrace/core v6 4/5] kprobes: Set IPMODIFY flag only if
 the probe can change regs->ip
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102530.11844.41626.stgit@localhost.localdomain> <20141121151548.7bd8bcd9@gandalf.local.home>
In-Reply-To: <20141121151548.7bd8bcd9@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/22 5:15), Steven Rostedt wrote:
> On Fri, 21 Nov 2014 05:25:30 -0500
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Set FTRACE_OPS_FL_IPMODIFY flag only for the probes which can change
>> regs->ip, which has kprobe->break_handler.
>> Currently we can not put jprobe and another ftrace handler which
>> changes regs->ip on the same function because all kprobes have
>> FTRACE_OPS_FL_IPMODIFY flag. This removes FTRACE_OPS_FL_IPMODIFY
>> flag from kprobes and only when the user uses jprobe (or the
>> kprobe.break_handler != NULL) we add additinal ftrace_ops with
>> FTRACE_OPS_FL_IPMODIFY on target function.
>>
>> Note about the implementation: This uses a dummy ftrace_ops to
>> reserve IPMODIFY flag on the given ftrace address, for the case
>> that we have a enabled kprobe on a function entry and a jprobe
>> is added on the same point. In that case, we already have a
>> ftrace_ops without IPMODIFY flag on the entry, and we have to
>> add another ftrace_ops with IPMODIFY on the same address.
>> If we put a same handler on both ftrace_ops, the handler can
>> be called twice on that entry until the first one is removed.
>> This means that the kprobe and the jprobe are called twice too,
>> and that will not what kprobes expected.
>> Thus I added a dummy ftrace_ops just for reserving IPMODIFY flag.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> ---
>> Changes in v4:
>>  - Increment refcounter after succeeded to register ftrace_ops.
>>
>> Changes in v3:
>>  - Update __ftrace_add/remove_filter_ip() according to
>>    Namhyng's comments (thanks!)
>>  - Split out regs->ip recovering code from this patch.
>> ---
>>  Documentation/kprobes.txt |   12 ++--
>>  kernel/kprobes.c          |  125 +++++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 114 insertions(+), 23 deletions(-)
>>
>> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
>> index 4227ec2..eb03efc 100644
>> --- a/Documentation/kprobes.txt
>> +++ b/Documentation/kprobes.txt
>> @@ -264,15 +264,13 @@ stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
>>  kernel.
>>  
>>  NOTE for geeks:
>> -The jump optimization changes the kprobe's pre_handler behavior.
>> -Without optimization, the pre_handler can change the kernel's execution
>> +The jump optimization (and ftrace-based kprobes) changes the kprobe's
>> +pre_handler behavior.
>> +Without optimizations, the pre_handler can change the kernel's execution
>>  path by changing regs->ip and returning 1.  However, when the probe
>>  is optimized, that modification is ignored.  Thus, if you want to
>> -tweak the kernel's execution path, you need to suppress optimization,
>> -using one of the following techniques:
>> -- Specify an empty function for the kprobe's post_handler or break_handler.
>> - or
>> -- Execute 'sysctl -w debug.kprobes_optimization=n'
>> +tweak the kernel's execution path, you need to suppress optimization or
>> +notify your handler will modify regs->ip by setting p->break_handler.
>>  
>>  1.5 Blacklist
>>  
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 831978c..4b4b7c5 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -915,10 +915,93 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>>  #ifdef CONFIG_KPROBES_ON_FTRACE
>>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
>>  	.func = kprobe_ftrace_handler,
>> -	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
>> +	.flags = FTRACE_OPS_FL_SAVE_REGS,
>>  };
>>  static int kprobe_ftrace_enabled;
>>  
>> +static void kprobe_ftrace_stub(unsigned long a0, unsigned long a1,
>> +			struct ftrace_ops *op, struct pt_regs *regs)
>> +{
>> +	/* Do nothing. This is just a dummy handler */
>> +}
> 
> Feel free to just use ftrace_stub instead. That's what it's there for.

Ah, I didn't know that. OK :)

>> +
>> +/* This is only for checking conflict with other ftrace users */
>> +static struct ftrace_ops kprobe_ipmod_ftrace_ops __read_mostly = {
>> +	.func = kprobe_ftrace_stub,
>> +	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
>> +};
>> +static int kprobe_ipmod_ftrace_enabled;
>> +
>> +static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>> +				  int *ref)
>> +{
>> +	int ret;
>> +
>> +	/* Try to set given ip to filter */
>> +	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (*ref == 0) {
>> +		ret = register_ftrace_function(ops);
>> +		if (ret < 0) {
>> +			/* Rollback the filter */
>> +			ftrace_set_filter_ip(ops, ip, 1, 0);
>> +			goto out;
> 
> Why the goto out, and not just return ret?
> 
>> +		}
>> +	}
>> +	(*ref)++;
>> +
>> +out:
>> +	return ret;
> 
> Probably could just return 0 here.

Agreed.

> 
> Rest looks fine.

Thank you!

> 
> -- Steve
> 
>> +}
>> +
>> +static int __ftrace_remove_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>> +				     int *ref)
>> +{
>> +	int ret;
>> +
>> +	if (*ref == 1) {
>> +		ret = unregister_ftrace_function(ops);
>> +		if (ret < 0)
>> +			return ret;
>> +		/*Ignore failure, because it is already unregistered */
>> +		ftrace_set_filter_ip(ops, ip, 1, 0);
>> +	} else {
>> +		/* Try to remove given ip to filter */
>> +		ret = ftrace_set_filter_ip(ops, ip, 1, 0);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	(*ref)--;
>> +
>> +	return 0;
>> +}
>> +
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


