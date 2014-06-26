Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbaFZRiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:38:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:57508 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757295AbaFZRiu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:38:50 -0400
Date: Thu, 26 Jun 2014 13:38:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFA][PATCH 23/27] metag: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626133848.0567e365@gandalf.local.home>
In-Reply-To: <20140626165853.049120840@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165853.049120840@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:44 -0400
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
> Cc: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/metag/Kconfig              |  1 -
>  arch/metag/kernel/ftrace_stub.S | 14 --------------
>  2 files changed, 15 deletions(-)
> 
> diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
> index 499b7610eaaf..0b389a81c43a 100644
> --- a/arch/metag/Kconfig
> +++ b/arch/metag/Kconfig
> @@ -13,7 +13,6 @@ config METAG
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_KERNEL_BZIP2
>  	select HAVE_KERNEL_GZIP
>  	select HAVE_KERNEL_LZO
> diff --git a/arch/metag/kernel/ftrace_stub.S b/arch/metag/kernel/ftrace_stub.S
> index e70bff745bdd..3acc288217c0 100644
> --- a/arch/metag/kernel/ftrace_stub.S
> +++ b/arch/metag/kernel/ftrace_stub.S
> @@ -16,13 +16,6 @@ _mcount_wrapper:
>  	.global _ftrace_caller
>  	.type	_ftrace_caller,function
>  _ftrace_caller:
> -	MOVT    D0Re0,#HI(_function_trace_stop)
> -	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
> -	GETD	D0Re0,[D0Re0]
> -	CMP	D0Re0,#0
> -	BEQ	$Lcall_stub
> -	MOV	PC,D0.4
> -$Lcall_stub:
>  	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
>  	MOV     D1Ar1, D0.4
>  	MOV     D0Ar2, D1RtP
> @@ -42,13 +35,6 @@ _ftrace_call:
>  	.global	_mcount_wrapper
>  	.type	_mcount_wrapper,function
>  _mcount_wrapper:
> -	MOVT    D0Re0,#HI(_function_trace_stop)
> -	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
> -	GETD	D0Re0,[D0Re0]
> -	CMP	D0Re0,#0
> -	BEQ	$Lcall_mcount
> -	MOV	PC,D0.4
> -$Lcall_mcount:
>  	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
>  	MOV     D1Ar1, D0.4
>  	MOV     D0Ar2, D1RtP

