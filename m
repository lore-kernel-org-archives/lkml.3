Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935003AbaKNDrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:47:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934249AbaKNDrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:47:45 -0500
Date: Thu, 13 Nov 2014 22:47:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>,
        Jan Kara <jack@suse.cz>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Alex Elder <elder@linaro.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org (open list), paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile
 type
Message-ID: <20141113224733.79747593@gandalf.local.home>
In-Reply-To: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 22:21:21 -0500
Pranith Kumar <bobby.prani@gmail.com> wrote:

> Remove volatile type qualifier and use ACCESS_ONCE() in its place for each
> access. Using volatile is not recommended as documented in
> Documentation/volatile-considered-harmful.txt.
> 
> Here logbuf_cpu is a local variable and it is not clear how it is being accessed
> concurrently. We should remove volatile accesses entirely here, but for now make
> a safer change of using ACCESS_ONCE().

I'm a little confused by the above paragraph about it's not clear how
it is being accessed concurrently. Do you mean the code is unclear, or
your understanding of it is unclear?

Regardless of your answer, this patch is correct. logbuf_cpu is used to
determine if printk has recursed on itself before it takes the
logbuf_lock and deadlocks. Your ACCESS_ONCE keeps the compiler from
optimizing out the logbuf_cpu as it will see that this function is the
only one that can touch it and may try to do weird things to it.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/printk/printk.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index e748971..4790191 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1624,7 +1624,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	int printed_len = 0;
>  	bool in_sched = false;
>  	/* cpu currently holding logbuf_lock in this function */
> -	static volatile unsigned int logbuf_cpu = UINT_MAX;
> +	static unsigned int logbuf_cpu = UINT_MAX;
>  
>  	if (level == LOGLEVEL_SCHED) {
>  		level = LOGLEVEL_DEFAULT;
> @@ -1641,7 +1641,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	/*
>  	 * Ouch, printk recursed into itself!
>  	 */
> -	if (unlikely(logbuf_cpu == this_cpu)) {
> +	if (unlikely(ACCESS_ONCE(logbuf_cpu) == this_cpu)) {
>  		/*
>  		 * If a crash is occurring during printk() on this CPU,
>  		 * then try to get the crash message out but make sure
> @@ -1659,7 +1659,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  
>  	lockdep_off();
>  	raw_spin_lock(&logbuf_lock);
> -	logbuf_cpu = this_cpu;
> +	ACCESS_ONCE(logbuf_cpu) = this_cpu;
>  
>  	if (unlikely(recursion_bug)) {
>  		static const char recursion_msg[] =
> @@ -1754,7 +1754,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  						 dict, dictlen, text, text_len);
>  	}
>  
> -	logbuf_cpu = UINT_MAX;
> +	ACCESS_ONCE(logbuf_cpu) = UINT_MAX;
>  	raw_spin_unlock(&logbuf_lock);
>  	lockdep_on();
>  	local_irq_restore(flags);

