Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3KNEHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 23:07:46 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54468 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3KNEHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 23:07:38 -0500
Message-ID: <52844C87.1040908@hitachi.com>
Date: Thu, 14 Nov 2013 13:07:35 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace/x86: Load ftrace_ops in parameter not the
 variable holding it
References: <20131113152004.459787f9@gandalf.local.home>
In-Reply-To: <20131113152004.459787f9@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/14 5:20), Steven Rostedt wrote:
> 
> Function tracing callbacks expect to have the ftrace_ops that registered it
> passed to them, not the address of the variable that holds the ftrace_ops
> that registered it.
> 
> Use a mov instead of a lea to store the ftrace_ops into the parameter
> of the function tracing callback.

I see, function_trace_op is just a pointer to an actual ftrace_ops. :)
And I have ensured this change doesn't affect ftrace-kprobes since
it doesn't use this parameter.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  arch/x86/kernel/entry_32.S | 4 ++--
>  arch/x86/kernel/entry_64.S | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index f0dcb0c..15a569a 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1085,7 +1085,7 @@ ENTRY(ftrace_caller)
>  	pushl $0	/* Pass NULL as regs pointer */
>  	movl 4*4(%esp), %eax
>  	movl 0x4(%ebp), %edx
> -	leal function_trace_op, %ecx
> +	movl function_trace_op, %ecx
>  	subl $MCOUNT_INSN_SIZE, %eax
>  
>  .globl ftrace_call
> @@ -1143,7 +1143,7 @@ ENTRY(ftrace_regs_caller)
>  	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
>  	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
>  	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
> -	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
> +	movl function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
>  	pushl %esp		/* Save pt_regs as 4th parameter */
>  
>  GLOBAL(ftrace_regs_call)
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b077f4c..9ce2567 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -88,7 +88,7 @@ END(function_hook)
>  	MCOUNT_SAVE_FRAME \skip
>  
>  	/* Load the ftrace_ops into the 3rd parameter */
> -	leaq function_trace_op, %rdx
> +	movq function_trace_op(%rip), %rdx
>  
>  	/* Load ip into the first parameter */
>  	movq RIP(%rsp), %rdi
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


