Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbaFZRiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:38:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59985 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757295AbaFZRiV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:38:21 -0400
Date: Thu, 26 Jun 2014 13:38:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 22/27] microblaze: ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626133813.5eeed38f@gandalf.local.home>
In-Reply-To: <20140626165852.891982463@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165852.891982463@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:43 -0400
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
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/microblaze/Kconfig         | 1 -
>  arch/microblaze/kernel/mcount.S | 5 -----
>  2 files changed, 6 deletions(-)
> 
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index 9ae08541e30d..40e1c1dd0e24 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -22,7 +22,6 @@ config MICROBLAZE
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_GRAPH_TRACER
> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_MEMBLOCK
>  	select HAVE_MEMBLOCK_NODE_MAP
> diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
> index fc1e1322ce4c..fed9da5de8c4 100644
> --- a/arch/microblaze/kernel/mcount.S
> +++ b/arch/microblaze/kernel/mcount.S
> @@ -91,11 +91,6 @@ ENTRY(ftrace_caller)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  	SAVE_REGS
>  	swi	r15, r1, 0;
> -	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST begin of checking */
> -	lwi	r5, r0, function_trace_stop;
> -	bneid	r5, end;
> -	nop;
> -	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  #ifndef CONFIG_DYNAMIC_FTRACE
>  	lwi	r5, r0, ftrace_graph_return;

