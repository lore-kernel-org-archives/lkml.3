Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbaFZRdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:33:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:12318 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756110AbaFZRdL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:33:11 -0400
Date: Thu, 26 Jun 2014 13:33:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 17/27] tile: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626133308.627842d0@gandalf.local.home>
In-Reply-To: <20140626165852.012558348@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.012558348@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:38 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> [ Please test this on your arch ]

>From the cover letter (you were not Cc'd on)

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
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/tile/Kconfig            |  1 -
>  arch/tile/kernel/mcount_64.S | 18 ------------------
>  2 files changed, 19 deletions(-)
> 
> diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
> index 4f3006b600e3..7fcd492adbfc 100644
> --- a/arch/tile/Kconfig
> +++ b/arch/tile/Kconfig
> @@ -128,7 +128,6 @@ config TILEGX
>  	select SPARSE_IRQ
>  	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
>  	select HAVE_FUNCTION_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
> diff --git a/arch/tile/kernel/mcount_64.S b/arch/tile/kernel/mcount_64.S
> index 70d7bb0c4d8f..3c2b8d5e1d1a 100644
> --- a/arch/tile/kernel/mcount_64.S
> +++ b/arch/tile/kernel/mcount_64.S
> @@ -77,15 +77,6 @@ STD_ENDPROC(__mcount)
>  
>  	.align	64
>  STD_ENTRY(ftrace_caller)
> -	moveli	r11, hw2_last(function_trace_stop)
> -	{ shl16insli	r11, r11, hw1(function_trace_stop); move r12, lr }
> -	{ shl16insli	r11, r11, hw0(function_trace_stop); move lr, r10 }
> -	ld	r11, r11
> -	beqz	r11, 1f
> -	jrp	r12
> -
> -1:
> -	{ move	r10, lr; move	lr, r12 }
>  	MCOUNT_SAVE_REGS
>  
>  	/* arg1: self return address */
> @@ -119,15 +110,6 @@ STD_ENDPROC(ftrace_caller)
>  
>  	.align	64
>  STD_ENTRY(__mcount)
> -	moveli	r11, hw2_last(function_trace_stop)
> -	{ shl16insli	r11, r11, hw1(function_trace_stop); move r12, lr }
> -	{ shl16insli	r11, r11, hw0(function_trace_stop); move lr, r10 }
> -	ld	r11, r11
> -	beqz	r11, 1f
> -	jrp	r12
> -
> -1:
> -	{ move	r10, lr; move	lr, r12 }
>  	{
>  	 moveli	r11, hw2_last(ftrace_trace_function)
>  	 moveli	r13, hw2_last(ftrace_stub)

