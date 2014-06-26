Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbaFZRlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:41:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:29348 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757085AbaFZRln convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:41:43 -0400
Date: Thu, 26 Jun 2014 13:41:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 26/27] s390/ftrace: remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626134141.18d92f1d@gandalf.local.home>
In-Reply-To: <20140626165853.685458770@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165853.685458770@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:47 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Remove check of obsolete variable function_trace_stop as requested by
> Steven Rostedt.

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
---

I know you wrote this patch, but you may want to test it out with
the ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST patch
applied too.

-- Steve

> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/s390/Kconfig           |  1 -
>  arch/s390/kernel/mcount.S   | 10 +++-------
>  arch/s390/kernel/mcount64.S |  3 ---
>  3 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index bb63499fc5d3..f5af5f6ef0f4 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -116,7 +116,6 @@ config S390
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_FUTEX_CMPXCHG if FUTEX
>  	select HAVE_KERNEL_BZIP2
>  	select HAVE_KERNEL_GZIP
> diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
> index 08dcf21cb8df..433c6dbfa442 100644
> --- a/arch/s390/kernel/mcount.S
> +++ b/arch/s390/kernel/mcount.S
> @@ -21,13 +21,9 @@ ENTRY(_mcount)
>  ENTRY(ftrace_caller)
>  #endif
>  	stm	%r2,%r5,16(%r15)
> -	bras	%r1,2f
> +	bras	%r1,1f
>  0:	.long	ftrace_trace_function
> -1:	.long	function_trace_stop
> -2:	l	%r2,1b-0b(%r1)
> -	icm	%r2,0xf,0(%r2)
> -	jnz	3f
> -	st	%r14,56(%r15)
> +1:	st	%r14,56(%r15)
>  	lr	%r0,%r15
>  	ahi	%r15,-96
>  	l	%r3,100(%r15)
> @@ -50,7 +46,7 @@ ENTRY(ftrace_graph_caller)
>  #endif
>  	ahi	%r15,96
>  	l	%r14,56(%r15)
> -3:	lm	%r2,%r5,16(%r15)
> +	lm	%r2,%r5,16(%r15)
>  	br	%r14
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
> index 1c52eae3396a..c67a8bf0fd9a 100644
> --- a/arch/s390/kernel/mcount64.S
> +++ b/arch/s390/kernel/mcount64.S
> @@ -20,9 +20,6 @@ ENTRY(_mcount)
>  
>  ENTRY(ftrace_caller)
>  #endif
> -	larl	%r1,function_trace_stop
> -	icm	%r1,0xf,0(%r1)
> -	bnzr	%r14
>  	stmg	%r2,%r5,32(%r15)
>  	stg	%r14,112(%r15)
>  	lgr	%r1,%r15

