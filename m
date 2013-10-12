Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3JLVfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 17:35:15 -0400
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:34890 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125Ab3JLVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 17:35:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7652:8660:9025:9038:10004:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13148:13230:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MS
X-HE-Tag: spy83_676c93c4f3800
X-Filterd-Recvd-Size: 5312
Message-ID: <1381613710.8864.27.camel@joe-AO722>
Subject: Re: [PATCH 1/1] dumpstack: fix printk_address for direct addresses
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <trivial@kernel.org>
Cc: x86@kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 12 Oct 2013 14:35:10 -0700
In-Reply-To: <1381608817-3507-1-git-send-email-jslaby@suse.cz>
References: <1381608817-3507-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-12 at 22:13 +0200, Jiri Slaby wrote:
[]
> To fix that, we use %pS only for stack addresses printouts (via newly
> added printk_stack_address) and %pB for regs->ip (via printk_address).
> I.e. we revert to the old behaviour for all except call stacks. And
> since from all those reliable is 1, we remove that parameter from
> printk_address.

I'm still waiting for you to apply this:

https://lkml.org/lkml/2013/7/22/701
https://lkml.org/lkml/2013/7/22/700

Oh wait, wrong Jiri... ;-)

Anyway, I'd rather your specific changes be done inline
so it's less possible to have interleaved messages.


> diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
[]
> @@ -21,7 +21,7 @@ enum die_val {
>  	DIE_NMIUNKNOWN,
>  };
>  
> -extern void printk_address(unsigned long address, int reliable);
> +extern void printk_address(unsigned long address);

I think this can be removed.

> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
[]
> @@ -25,12 +25,17 @@ unsigned int code_bytes = 64;
>  int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
>  static int die_counter;
>  
> -void printk_address(unsigned long address, int reliable)
> +static void printk_stack_address(unsigned long address, int reliable)
>  {
>  	pr_cont(" [<%p>] %s%pB\n",
>  		(void *)address, reliable ? "" : "? ", (void *)address);
>  }

This is now used only once and could/should be done
at the single use site.

> +void printk_address(unsigned long address)
> +{
> +	pr_cont(" [<%p>] %pS\n", (void *)address, (void *)address);
> +}
> +

And this could/should be done inline in the few
places it's used.

>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  static void
>  print_ftrace_graph_addr(unsigned long addr, void *data,
> @@ -151,7 +156,7 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
>  {
>  	touch_nmi_watchdog();
>  	printk(data);
> -	printk_address(addr, reliable);
> +	printk_stack_address(addr, reliable);

	printk("%s [<%p>] %s%pB\n",
	       data, (void *)addr, reliable ? "" : "? ", (void *)addr);

> @@ -281,7 +286,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  #else
>  	/* Executive summary in case the oops scrolled away */
>  	printk(KERN_ALERT "RIP ");
> -	printk_address(regs->ip, 1);
> +	printk_address(regs->ip);

	printk(KERN_ALERT "RIP [<%p>] %pS\n",
	       (void *)regs->ip, (void *)regs->ip);

> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
[]
> @@ -63,7 +63,7 @@ void __show_regs(struct pt_regs *regs, int all)
>  	unsigned int ds, cs, es;
>  
>  	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
> -	printk_address(regs->ip, 1);
> +	printk_address(regs->ip);

	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] [<%p>] %pS\n",
	       regs->cs & 0xffff, regs->ip,
	       (void *)regs->ip, (void *)regs->ip);

This one looks ugly to me.
It emits the address twice.

>  	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
>  			regs->sp, regs->flags);
>  	printk(KERN_DEFAULT "RAX: %016lx RBX: %016lx RCX: %016lx\n",
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 3aaeffc..18feeb3 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -596,7 +596,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  
>  	printk(KERN_CONT " at %p\n", (void *) address);
>  	printk(KERN_ALERT "IP:");
> -	printk_address(regs->ip, 1);
> +	printk_address(regs->ip);

	printk(KERN_ALERT "IP: [<%p>] %pS\n",
	       (void *)regs->ip, (void *)regs->ip);
 
>  	dump_pagetable(address);
>  }
> diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
> index 9126dfb..019b6ec 100644
> --- a/arch/x86/platform/uv/uv_nmi.c
> +++ b/arch/x86/platform/uv/uv_nmi.c
> @@ -402,7 +402,7 @@ static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
>  	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
>  		cpu, current->pid, current->comm);
>  
> -	printk_address(regs->ip, 1);
> +	printk_address(regs->ip);

	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s [<%p>] %pS\n",
	       cpu, current->pid, current->comm,
	       (void *)regs->ip, (void *)regs->ip);


