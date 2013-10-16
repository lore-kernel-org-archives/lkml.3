Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556Ab3JPJwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:52:31 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44800 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286Ab3JPJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:52:30 -0400
Message-ID: <525E61D9.10204@suse.cz>
Date: Wed, 16 Oct 2013 11:52:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>
CC: x86@kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] dumpstack: fix printk_address for direct addresses
References: <1381608817-3507-1-git-send-email-jslaby@suse.cz> <1381613710.8864.27.camel@joe-AO722>
In-Reply-To: <1381613710.8864.27.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 11:35 PM, Joe Perches wrote:
> On Sat, 2013-10-12 at 22:13 +0200, Jiri Slaby wrote:
> []
>> To fix that, we use %pS only for stack addresses printouts (via newly
>> added printk_stack_address) and %pB for regs->ip (via printk_address).
>> I.e. we revert to the old behaviour for all except call stacks. And
>> since from all those reliable is 1, we remove that parameter from
>> printk_address.
> 
> I'm still waiting for you to apply this:
> 
> https://lkml.org/lkml/2013/7/22/701
> https://lkml.org/lkml/2013/7/22/700
> 
> Oh wait, wrong Jiri... ;-)
> 
> Anyway, I'd rather your specific changes be done inline
> so it's less possible to have interleaved messages.

Why you are putting this here?

>> diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
> []
>> @@ -21,7 +21,7 @@ enum die_val {
>>  	DIE_NMIUNKNOWN,
>>  };
>>  
>> -extern void printk_address(unsigned long address, int reliable);
>> +extern void printk_address(unsigned long address);
> 
> I think this can be removed.

I'm waiting for an x86's guys input as to what do they prefer to be done?

>> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> []
>> @@ -25,12 +25,17 @@ unsigned int code_bytes = 64;
>>  int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
>>  static int die_counter;
>>  
>> -void printk_address(unsigned long address, int reliable)
>> +static void printk_stack_address(unsigned long address, int reliable)
>>  {
>>  	pr_cont(" [<%p>] %s%pB\n",
>>  		(void *)address, reliable ? "" : "? ", (void *)address);
>>  }
> 
> This is now used only once and could/should be done
> at the single use site.
> 
>> +void printk_address(unsigned long address)
>> +{
>> +	pr_cont(" [<%p>] %pS\n", (void *)address, (void *)address);
>> +}
>> +
> 
> And this could/should be done inline in the few
> places it's used.
> 
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>  static void
>>  print_ftrace_graph_addr(unsigned long addr, void *data,
>> @@ -151,7 +156,7 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
>>  {
>>  	touch_nmi_watchdog();
>>  	printk(data);
>> -	printk_address(addr, reliable);
>> +	printk_stack_address(addr, reliable);
> 
> 	printk("%s [<%p>] %s%pB\n",
> 	       data, (void *)addr, reliable ? "" : "? ", (void *)addr);
> 
>> @@ -281,7 +286,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>>  #else
>>  	/* Executive summary in case the oops scrolled away */
>>  	printk(KERN_ALERT "RIP ");
>> -	printk_address(regs->ip, 1);
>> +	printk_address(regs->ip);
> 
> 	printk(KERN_ALERT "RIP [<%p>] %pS\n",
> 	       (void *)regs->ip, (void *)regs->ip);
> 
>> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> []
>> @@ -63,7 +63,7 @@ void __show_regs(struct pt_regs *regs, int all)
>>  	unsigned int ds, cs, es;
>>  
>>  	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
>> -	printk_address(regs->ip, 1);
>> +	printk_address(regs->ip);
> 
> 	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] [<%p>] %pS\n",
> 	       regs->cs & 0xffff, regs->ip,
> 	       (void *)regs->ip, (void *)regs->ip);
> 
> This one looks ugly to me.
> It emits the address twice.
> 
>>  	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
>>  			regs->sp, regs->flags);
>>  	printk(KERN_DEFAULT "RAX: %016lx RBX: %016lx RCX: %016lx\n",
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index 3aaeffc..18feeb3 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -596,7 +596,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>>  
>>  	printk(KERN_CONT " at %p\n", (void *) address);
>>  	printk(KERN_ALERT "IP:");
>> -	printk_address(regs->ip, 1);
>> +	printk_address(regs->ip);
> 
> 	printk(KERN_ALERT "IP: [<%p>] %pS\n",
> 	       (void *)regs->ip, (void *)regs->ip);
>  
>>  	dump_pagetable(address);
>>  }
>> diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
>> index 9126dfb..019b6ec 100644
>> --- a/arch/x86/platform/uv/uv_nmi.c
>> +++ b/arch/x86/platform/uv/uv_nmi.c
>> @@ -402,7 +402,7 @@ static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
>>  	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
>>  		cpu, current->pid, current->comm);
>>  
>> -	printk_address(regs->ip, 1);
>> +	printk_address(regs->ip);
> 
> 	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s [<%p>] %pS\n",
> 	       cpu, current->pid, current->comm,
> 	       (void *)regs->ip, (void *)regs->ip);
> 
> 


-- 
js
suse labs
