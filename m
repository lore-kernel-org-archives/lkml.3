Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaFZRfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:35:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:25108 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757824AbaFZRfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:35:16 -0400
Date: Thu, 26 Jun 2014 13:35:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matt Fleming <matt@console-pimps.org>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 19/27] sh: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626133515.4c87c40d@gandalf.local.home>
In-Reply-To: <20140626165852.312670231@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.312670231@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:40 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> [ Please test this on your arch ]

>From the cover letter, you were not Cc'd on.

Anyway, as there is no more reason to set function_trace_stop it is time
to remove it. Unfortunately it's in several archs in assembly. Most of
the assembly looks rather straight forward and I removed them myself.
But I was only able to compile test them (for archs: arm64, metag, and
microblaze I do not have my cross tools set up for them and did not
even compile test it). But I would really love it if people can
download their patch and test it out. You only need the patches that go
against your arch and to really test it, also include the patch titled: 

 ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST

Otherwise your arch patch will call the list op that still does the
check. That is, if you want to test suspend and resume on your arch.

As you may see, there are patches to the ftrace infrastructure that
depend on the arch patches being implemented. I removed the
functionality from the infrastructure, then removed it from the archs,
and then finally removed the existence of the function_trace_stop
variable, which would cause the archs to fail to compile if that were
to go first.

If you can test your arch and give me your acked-by, I would appreciate
it. Otherwise, if you need this to go through your tree, I would ask you
to set up a dedicated branch that I can pull from to keep this order
intact.

-- Steve

> 
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/sh/Kconfig      |  1 -
>  arch/sh/lib/mcount.S | 24 ++----------------------
>  2 files changed, 2 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 834b67c4db5a..aa2df3eaeb29 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -57,7 +57,6 @@ config SUPERH32
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_DYNAMIC_FTRACE
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select HAVE_FUNCTION_GRAPH_TRACER
> diff --git a/arch/sh/lib/mcount.S b/arch/sh/lib/mcount.S
> index 52aa2011d753..7a8572f9d58b 100644
> --- a/arch/sh/lib/mcount.S
> +++ b/arch/sh/lib/mcount.S
> @@ -92,13 +92,6 @@ mcount:
>  	rts
>  	 nop
>  #else
> -#ifndef CONFIG_DYNAMIC_FTRACE
> -	mov.l	.Lfunction_trace_stop, r0
> -	mov.l	@r0, r0
> -	tst	r0, r0
> -	bf	ftrace_stub
> -#endif
> -
>  	MCOUNT_ENTER()
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -174,11 +167,6 @@ ftrace_graph_call:
>  
>  	.globl ftrace_caller
>  ftrace_caller:
> -	mov.l	.Lfunction_trace_stop, r0
> -	mov.l	@r0, r0
> -	tst	r0, r0
> -	bf	ftrace_stub
> -
>  	MCOUNT_ENTER()
>  
>  	.globl ftrace_call
> @@ -196,8 +184,6 @@ ftrace_call:
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  
>  	.align 2
> -.Lfunction_trace_stop:
> -	.long	function_trace_stop
>  
>  /*
>   * NOTE: From here on the locations of the .Lftrace_stub label and
> @@ -217,12 +203,7 @@ ftrace_stub:
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	.globl	ftrace_graph_caller
>  ftrace_graph_caller:
> -	mov.l	2f, r0
> -	mov.l	@r0, r0
> -	tst	r0, r0
> -	bt	1f
> -
> -	mov.l	3f, r1
> +	mov.l	2f, r1
>  	jmp	@r1
>  	 nop
>  1:
> @@ -242,8 +223,7 @@ ftrace_graph_caller:
>  	MCOUNT_LEAVE()
>  
>  	.align 2
> -2:	.long	function_trace_stop
> -3:	.long	skip_trace
> +2:	.long	skip_trace
>  .Lprepare_ftrace_return:
>  	.long	prepare_ftrace_return
>  

