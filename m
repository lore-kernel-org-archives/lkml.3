Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3HFTCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 15:02:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3HFTCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 15:02:48 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=o9wxAiQGZFUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lPGdCojwBkAA:10 a=NufY4J3AAAAA:8 a=1CUOjiPO31Ic4UWOk0sA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=re9sYKne76oA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375815765.25420.45.camel@gandalf.local.home>
Subject: Re: x86: use this_cpu for debug_stack_usage
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Tue, 06 Aug 2013 15:02:45 -0400
In-Reply-To: <0000014054fd1db5-e6fbcc32-2e6c-49b1-83d4-399791ee6829-000000@email.amazonses.com>
References: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com>
	 <1375811455.25420.39.camel@gandalf.local.home>
	 <0000014054fd1db5-e6fbcc32-2e6c-49b1-83d4-399791ee6829-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 18:56 +0000, Christoph Lameter wrote:
> > Might as well change is_debug_stack() to use __this_cpu_read() instead
> > of __get_cpu_var().

I just noticed that you didn't include the x86 maintainers.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> 
> 
> 
> 
> Subject: x86: use this_cpu for debug_stack_usage
> 
> Reduces overhead a bit and frees up a couple of registers.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/arch/x86/include/asm/debugreg.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/debugreg.h	2013-08-06 13:52:23.740092873 -0500
> +++ linux/arch/x86/include/asm/debugreg.h	2013-08-06 13:52:23.740092873 -0500
> @@ -97,11 +97,11 @@ extern void hw_breakpoint_restore(void);
>  DECLARE_PER_CPU(int, debug_stack_usage);
>  static inline void debug_stack_usage_inc(void)
>  {
> -	__get_cpu_var(debug_stack_usage)++;
> +	__this_cpu_inc(debug_stack_usage);
>  }
>  static inline void debug_stack_usage_dec(void)
>  {
> -	__get_cpu_var(debug_stack_usage)--;
> +	__this_cpu_dec(debug_stack_usage);
>  }
>  int is_debug_stack(unsigned long addr);
>  void debug_stack_set_zero(void);
> Index: linux/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/common.c	2013-07-19 09:06:36.850047837 -0500
> +++ linux/arch/x86/kernel/cpu/common.c	2013-08-06 13:54:36.426384889 -0500
> @@ -1144,9 +1144,9 @@ DEFINE_PER_CPU(int, debug_stack_usage);
> 
>  int is_debug_stack(unsigned long addr)
>  {
> -	return __get_cpu_var(debug_stack_usage) ||
> -		(addr <= __get_cpu_var(debug_stack_addr) &&
> -		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
> +	return __this_cpu_read(debug_stack_usage) ||
> +		(addr <= __this_cpu_read(debug_stack_addr) &&
> +		 addr > (__this_cpu_read(debug_stack_addr) - DEBUG_STKSZ));
>  }
> 
>  DEFINE_PER_CPU(u32, debug_idt_ctr);


