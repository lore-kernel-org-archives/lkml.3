Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3KELVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:21:37 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53699 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3KELVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:21:35 -0500
Date: Tue, 5 Nov 2013 03:21:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Do not trace rcu_is_watching() functions
Message-ID: <20131105112130.GC3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131104202736.72dd8e45@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104202736.72dd8e45@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110511-6688-0000-0000-0000032F0AAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:27:36PM -0500, Steven Rostedt wrote:
> 
> Paul,
> 
> As I added the rcu_is_watching() to the ftrace code to prevent perf
> from tracing functions where RCU is not watching, I noticed that the
> rcu_is_watching() functions can themselves be traced. I would say this
> is a helper function and not something that we need to trace, as it can
> cause a slowdown in function tracing (any recursion is detected, so it
> only affects performance).
> 
> I marked the functions with notrace. You can take this patch and push
> it for 3.13 or I can take it if you give me an "Acked-by". As it only
> affects performance and does not crash the code it's not a must have in
> my tree.
> 
> If you take it, I can write up a better change log too.
> 
> -- Steve
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Given an improved commit log:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 0fa061d..590c8a8 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -179,7 +179,7 @@ EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  /*
>   * Test whether RCU thinks that the current CPU is idle.
>   */
> -bool __rcu_is_watching(void)
> +bool notrace __rcu_is_watching(void)
>  {
>  	return rcu_dynticks_nesting;
>  }
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 981d0c1..499bb2b 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -662,7 +662,7 @@ void rcu_nmi_exit(void)
>   * rcu_is_watching(), the caller of __rcu_is_watching() must have at
>   * least disabled preemption.
>   */
> -bool __rcu_is_watching(void)
> +bool notrace __rcu_is_watching(void)
>  {
>  	return atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
>  }
> @@ -673,7 +673,7 @@ bool __rcu_is_watching(void)
>   * If the current CPU is in its idle loop and is neither in an interrupt
>   * or NMI handler, return true.
>   */
> -bool rcu_is_watching(void)
> +bool notrace rcu_is_watching(void)
>  {
>  	int ret;
> 
> 

