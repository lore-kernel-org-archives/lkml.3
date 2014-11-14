Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbaKNEsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:48:36 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65390 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbaKNEsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:48:35 -0500
Message-ID: <546589A1.9040100@linaro.org>
Date: Thu, 13 Nov 2014 22:48:33 -0600
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Jan Kara <jack@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>
CC: paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile type
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
In-Reply-To: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 09:21 PM, Pranith Kumar wrote:
> Remove volatile type qualifier and use ACCESS_ONCE() in its place for each
> access. Using volatile is not recommended as documented in
> Documentation/volatile-considered-harmful.txt.
> 
> Here logbuf_cpu is a local variable and it is not clear how it is being accessed
> concurrently. We should remove volatile accesses entirely here, but for now make
> a safer change of using ACCESS_ONCE().

Although logbuf_cpu is declared locally, it has static scope and
hence its value is persistent across calls to the function,
including concurrent calls on different CPUs.

This is a very interesting bit of code.  I have a
question, below.

					-Alex

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

If this is not volatile, can the compiler assume that it
can't change before the first access?  Put another way,
does this assignment need to be done more like this?

	static unsigned int ACCESS_ONCE(logbuf_cpu) = UINT_MAX;

(I haven't checked, but I don't believe that expands to valid code.)

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
> 

