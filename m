Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaCVAt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 20:49:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:35714 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881AbaCVAtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 20:49:22 -0400
Date: Fri, 21 Mar 2014 20:49:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Wright <chrisw@sous-sol.org>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, fche@redhat.com,
        mingo@redhat.com, Rob Landley <rob@landley.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alok Kataria <akataria@vmware.com>, systemtap@sourceware.org
Subject: Re: [PATCH -tip v8 04/26] kprobes: Introduce NOKPROBE_SYMBOL()
 macro for blacklist
Message-ID: <20140321204917.636820fa@gandalf.local.home>
In-Reply-To: <20140305115911.22766.61140.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115911.22766.61140.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:11 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 0cfb00f..7062631 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -22,8 +22,9 @@ Appendix B: The kprobes sysctl interface
>  
>  Kprobes enables you to dynamically break into any kernel routine and
>  collect debugging and performance information non-disruptively. You
> -can trap at almost any kernel code address, specifying a handler
> +can trap at almost any kernel code address(*), specifying a handler
>  routine to be invoked when the breakpoint is hit.
> +(*: at some part of kernel code can not be trapped, see 1.5 Blacklist)

"*: some parts of the kernel code can not be trapped,"

>  
>  There are currently three types of probes: kprobes, jprobes, and
>  kretprobes (also called return probes).  A kprobe can be inserted
> @@ -273,6 +274,19 @@ using one of the following techniques:
>   or
>  - Execute 'sysctl -w debug.kprobes_optimization=n'
>  
> +1.5 Blacklist
> +
> +Kprobes can probe almost of the kernel except itself. This means

s/almost/most/

> +that there are some functions where kprobes cannot probe. Probing
> +(trapping) such functions can cause recursive trap (e.g. double

   cause a recursive trap

> +fault) or at least the nested probe handler never be called.

  "or the nested probe handler may never be called."

> +Kprobes manages such functions as a blacklist.
> +If you want to add a function into the blacklist, you just need
> +to (1) include linux/kprobes.h and (2) use NOKPROBE_SYMBOL() macro
> +to specify a blacklisted function.
> +Kprobes checks given probe address with the blacklist and reject

  "checks the given probe address against the black list and rejects"

> +registering if the given address is in the blacklist.

   registering it, if

> +
>  2. Architectures Supported
>  
>  Kprobes, jprobes, and return probes are implemented on the following
> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> index 4582e8e..7730c1c 100644
> --- a/arch/x86/include/asm/asm.h
> +++ b/arch/x86/include/asm/asm.h
> @@ -57,6 +57,12 @@
>  	.long (from) - . ;					\
>  	.long (to) - . + 0x7ffffff0 ;				\
>  	.popsection
> +
> +# define _ASM_NOKPROBE(entry)					\
> +	.pushsection "_kprobe_blacklist","aw" ;			\
> +	_ASM_ALIGN ;						\
> +	_ASM_PTR (entry);					\
> +	.popsection
>  #else
>  # define _ASM_EXTABLE(from,to)					\
>  	" .pushsection \"__ex_table\",\"a\"\n"			\
> @@ -71,6 +77,7 @@
>  	" .long (" #from ") - .\n"				\
>  	" .long (" #to ") - . + 0x7ffffff0\n"			\
>  	" .popsection\n"
> +/* For C file, we already have NOKPROBE_SYMBOL macro */
>  #endif
>  
>  #endif /* _ASM_X86_ASM_H */
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 1b10af8..4c785fd 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -23,6 +23,7 @@
>  #include <linux/efi.h>
>  #include <linux/bcd.h>
>  #include <linux/highmem.h>
> +#include <linux/kprobes.h>
>  
>  #include <asm/bug.h>
>  #include <asm/paravirt.h>
> @@ -389,6 +390,9 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
>  	.end_context_switch = paravirt_nop,
>  };
>  
> +/* At this point, native_get_debugreg has real function entry */

  "has a real"

-- Steve

> +NOKPROBE_SYMBOL(native_get_debugreg);
> +
>  struct pv_apic_ops pv_apic_ops = {
>  #ifdef CONFIG_X86_LOCAL_APIC
>  	.startup_ipi_hook = paravirt_nop,
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bc2121f..81d07d5 100644
> --- a/include/asm-generic/vmlinux.lds.h
