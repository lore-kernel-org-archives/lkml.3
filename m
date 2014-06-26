Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbaFZRjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:39:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28832 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932445AbaFZRjm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:39:42 -0400
Date: Thu, 26 Jun 2014 13:39:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFA][PATCH 24/27] Blackfin: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626133941.174fdb2e@gandalf.local.home>
In-Reply-To: <20140626165853.211937817@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165853.211937817@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:45 -0400
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
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/blackfin/Kconfig               |  1 -
>  arch/blackfin/kernel/ftrace-entry.S | 18 ------------------
>  2 files changed, 19 deletions(-)
> 
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index f81e7b989fff..ed30699cc635 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -18,7 +18,6 @@ config BLACKFIN
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_IDE
>  	select HAVE_KERNEL_GZIP if RAMKERNEL
>  	select HAVE_KERNEL_BZIP2 if RAMKERNEL
> diff --git a/arch/blackfin/kernel/ftrace-entry.S b/arch/blackfin/kernel/ftrace-entry.S
> index 7eed00bbd26d..28d059540424 100644
> --- a/arch/blackfin/kernel/ftrace-entry.S
> +++ b/arch/blackfin/kernel/ftrace-entry.S
> @@ -33,15 +33,6 @@ ENDPROC(__mcount)
>   * function will be waiting there.  mmmm pie.
>   */
>  ENTRY(_ftrace_caller)
> -# ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> -	/* optional micro optimization: return if stopped */
> -	p1.l = _function_trace_stop;
> -	p1.h = _function_trace_stop;
> -	r3 = [p1];
> -	cc = r3 == 0;
> -	if ! cc jump _ftrace_stub (bp);
> -# endif
> -
>  	/* save first/second/third function arg and the return register */
>  	[--sp] = r2;
>  	[--sp] = r0;
> @@ -83,15 +74,6 @@ ENDPROC(_ftrace_caller)
>  
>  /* See documentation for _ftrace_caller */
>  ENTRY(__mcount)
> -# ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> -	/* optional micro optimization: return if stopped */
> -	p1.l = _function_trace_stop;
> -	p1.h = _function_trace_stop;
> -	r3 = [p1];
> -	cc = r3 == 0;
> -	if ! cc jump _ftrace_stub (bp);
> -# endif
> -
>  	/* save third function arg early so we can do testing below */
>  	[--sp] = r2;
>  

