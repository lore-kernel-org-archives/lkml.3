Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbaFZRk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:40:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:25284 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758119AbaFZRkY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:40:24 -0400
Date: Thu, 26 Jun 2014 13:40:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 25/27] arm64, ftrace: Remove check of obsolete
 variable function_trace_stop
Message-ID: <20140626134022.540c536e@gandalf.local.home>
In-Reply-To: <20140626165853.482575534@goodmis.org>
References: <20140626165221.736847419@goodmis.org>
	<20140626165853.482575534@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 12:52:46 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> arm64 was broken anyway, as it had an ifdef testing
>  CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST which is only set if
> the arch supports the code (which it obviously did not), and
> it was testing a non existent ftrace_trace_stop instead of
> function_trace_stop.

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
> Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/arm64/kernel/entry-ftrace.S | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index b051871f2965..1b1e330e6849 100644
> --- a/arch/arm64/kernel/entry-ftrace.S
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -96,11 +96,6 @@
>   *     - ftrace_graph_caller to set up an exit hook
>   */
>  ENTRY(_mcount)
> -#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> -	ldr	x0, =ftrace_trace_stop
> -	ldr	x0, [x0]		// if ftrace_trace_stop
> -	ret				//   return;
> -#endif
>  	mcount_enter
>  
>  	ldr	x0, =ftrace_trace_function

