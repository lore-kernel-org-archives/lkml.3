Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaEEShg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:37:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:44709 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751752AbaEEShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:37:34 -0400
Date: Mon, 5 May 2014 14:37:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 4/8] printk: Remove separate printk_sched buffers and
 use printk buf instead
Message-ID: <20140505143732.20853481@gandalf.local.home>
In-Reply-To: <1395770101-24534-5-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
	<1395770101-24534-5-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has this patch made it anywhere? It's actually a separate fix from the
patch series, and should not be controversial.

Perhaps this should be merged now while we still get everything else
figured out?

-- Steve


On Tue, 25 Mar 2014 18:54:57 +0100
Jan Kara <jack@suse.cz> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> To prevent deadlocks with doing a printk inside the scheduler,
> printk_sched() was created. The issue is that printk has a console_sem
> that it can grab and release. The release does a wake up if there's a
> task pending on the sem, and this wake up grabs the rq locks that is
> held in the scheduler. This leads to a possible deadlock if the wake up
> uses the same rq as the one with the rq lock held already.
> 
> What printk_sched() does is to save the printk write in a per cpu buffer
> and sets the PRINTK_PENDING_SCHED flag. On a timer tick, if this flag is
> set, the printk() is done against the buffer.
> 
> There's a couple of issues with this approach.
> 
> 1) If two printk_sched()s are called before the tick, the second one
> will overwrite the first one.
> 
> 2) The temporary buffer is 512 bytes and is per cpu. This is a quite a
> bit of space wasted for something that is seldom used.
> 
> In order to remove this, the printk_sched() can use the printk buffer
> instead, and delay the console_trylock()/console_unlock() to the queued
> work.
> 
> Because printk_sched() would then be taking the logbuf_lock, the
> logbuf_lock must not be held while doing anything that may call into the
> scheduler functions, which includes wake ups. Unfortunately, printk()
> also has a console_sem that it uses, and on release, the
> up(&console_sem) may do a wake up of any pending waiters. This must be
> avoided while holding the logbuf_lock.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  kernel/printk/printk.c | 47 +++++++++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 56649edfae9c..91c554e027c5 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -68,6 +68,9 @@ int console_printk[4] = {
>  	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
>  };
>  
> +/* Deferred messaged from sched code are marked by this special level */
> +#define SCHED_MESSAGE_LOGLEVEL -2
> +
>  /*
>   * Low level drivers may need that to know if they can schedule in
>   * their unblank() callback or not. So let's export it.
> @@ -206,7 +209,9 @@ struct printk_log {
>  };
>  
>  /*
> - * The logbuf_lock protects kmsg buffer, indices, counters.
> + * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
> + * within the scheduler's rq lock. It must be released before calling
> + * console_unlock() or anything else that might wake up a process.
>   */
>  static DEFINE_RAW_SPINLOCK(logbuf_lock);
>  
> @@ -1473,14 +1478,19 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	static int recursion_bug;
>  	static char textbuf[LOG_LINE_MAX];
>  	char *text = textbuf;
> -	size_t text_len;
> +	size_t text_len = 0;
>  	enum log_flags lflags = 0;
>  	unsigned long flags;
>  	int this_cpu;
>  	int printed_len = 0;
> +	bool in_sched = false;
>  	/* cpu currently holding logbuf_lock in this function */
>  	static volatile unsigned int logbuf_cpu = UINT_MAX;
>  
> +	if (level == SCHED_MESSAGE_LOGLEVEL) {
> +		level = -1;
> +		in_sched = true;
> +	}
>  
>  	boot_delay_msec(level);
>  	printk_delay();
> @@ -1527,7 +1537,12 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	 * The printf needs to come first; we need the syslog
>  	 * prefix which might be passed-in as a parameter.
>  	 */
> -	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
> +	if (in_sched)
> +		text_len = scnprintf(text, sizeof(textbuf),
> +				     KERN_WARNING "[sched_delayed] ");
> +
> +	text_len += vscnprintf(text + text_len,
> +			       sizeof(textbuf) - text_len, fmt, args);
>  
>  	/* mark and strip a trailing newline */
>  	if (text_len && text[text_len-1] == '\n') {
> @@ -1602,6 +1617,10 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	lockdep_on();
>  	local_irq_restore(flags);
>  
> +	/* If called from the scheduler, we can not call up(). */
> +	if (in_sched)
> +		return printed_len;
> +
>  	/*
>  	 * Disable preemption to avoid being preempted while holding
>  	 * console_sem which would prevent anyone from printing to console
> @@ -2423,21 +2442,19 @@ late_initcall(printk_late_init);
>  /*
>   * Delayed printk version, for scheduler-internal messages:
>   */
> -#define PRINTK_BUF_SIZE		512
> -
>  #define PRINTK_PENDING_WAKEUP	0x01
> -#define PRINTK_PENDING_SCHED	0x02
> +#define PRINTK_PENDING_OUTPUT	0x02
>  
>  static DEFINE_PER_CPU(int, printk_pending);
> -static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
>  
>  static void wake_up_klogd_work_func(struct irq_work *irq_work)
>  {
>  	int pending = __this_cpu_xchg(printk_pending, 0);
>  
> -	if (pending & PRINTK_PENDING_SCHED) {
> -		char *buf = __get_cpu_var(printk_sched_buf);
> -		pr_warn("[sched_delayed] %s", buf);
> +	if (pending & PRINTK_PENDING_OUTPUT) {
> +		/* If trylock fails, someone else is doing the printing */
> +		if (console_trylock())
> +			console_unlock();
>  	}
>  
>  	if (pending & PRINTK_PENDING_WAKEUP)
> @@ -2461,21 +2478,15 @@ void wake_up_klogd(void)
>  
>  int printk_sched(const char *fmt, ...)
>  {
> -	unsigned long flags;
>  	va_list args;
> -	char *buf;
>  	int r;
>  
> -	local_irq_save(flags);
> -	buf = __get_cpu_var(printk_sched_buf);
> -
>  	va_start(args, fmt);
> -	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
> +	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
>  	va_end(args);
>  
> -	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
> +	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
>  	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
> -	local_irq_restore(flags);
>  
>  	return r;
>  }

