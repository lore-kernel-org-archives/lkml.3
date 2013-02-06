Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3BFPJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:09:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab3BFPJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:09:40 -0500
Date: Wed, 6 Feb 2013 15:32:01 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        jslaby@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH] printk: Remove separate printk_sched buffers and
 use printk buf instead
Message-ID: <20130206143201.GG6330@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360112748.2621.25.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-02-13 20:05:48, Steven Rostedt wrote:
> [ I sent this in a reply to another thread, but wanted a bit more attention to it ]
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
> In order to remove this, the printk_sched() can instead use the printk
> buffer instead, and delay the console_trylock()/console_unlock() to the
> tick.
> 
> Because printk_sched() would then be taking the logbuf_lock, the
> logbuf_lock must not be held while doing anything that may call into the
> scheduler functions, which includes wake ups. Unfortunately, printk()
> also has a console_sem that it uses, and on release, the
> up(&console_sem) may do a wake up of any pending waiters. This must be
> avoided while holding the logbuf_lock.
> 
> Luckily, there's not many places that do the unlock, or hold the
> logbuf_lock. By moving things around a little, the console_sem can be
> released without ever holding the logbuf_lock, and we can safely have
> printk_sched() use the printk buffer directly.
  I like this! It looks better than what I did with workqueue. I'll
experiment how things behave if I use PRINTK_PENDING_OUTPUT instead of my
workqueue solution. Thanks for the patch. BTW the patch looks OK to me but
I don't feel like an expert in that code so take that with a grain of salt.

								Honza
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 357f714..ed630fa 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -219,6 +219,9 @@ struct log {
>  /*
>   * The logbuf_lock protects kmsg buffer, indices, counters. It is also
>   * used in interesting ways to provide interlocking in console_unlock();
> + * This can be taken within the scheduler's rq lock. It must be released
> + * before calling console_unlock() or anything else that might wake up
> + * a process.
>   */
>  static DEFINE_RAW_SPINLOCK(logbuf_lock);
>  
> @@ -1343,30 +1346,46 @@ static inline int can_use_console(unsigned int cpu)
>   * interrupts disabled. It should return with 'lockbuf_lock'
>   * released but interrupts still disabled.
>   */
> -static int console_trylock_for_printk(unsigned int cpu)
> +static int console_trylock_for_printk(unsigned int cpu, bool in_sched)
>  	__releases(&logbuf_lock)
>  {
>  	int retval = 0, wake = 0;
>  
> -	if (console_trylock()) {
> -		retval = 1;
> +	/* if called from the scheduler, we can not call up() */
> +	if (in_sched)
> +		goto out;
>  
> -		/*
> -		 * If we can't use the console, we need to release
> -		 * the console semaphore by hand to avoid flushing
> -		 * the buffer. We need to hold the console semaphore
> -		 * in order to do this test safely.
> -		 */
> -		if (!can_use_console(cpu)) {
> -			console_locked = 0;
> -			wake = 1;
> -			retval = 0;
> -		}
> +	if (down_trylock(&console_sem))
> +		goto out;
> +
> +	/*
> +	 * If we can't use the console, we need to release
> +	 * the console semaphore by hand to avoid flushing
> +	 * the buffer. We need to hold the console semaphore
> +	 * in order to do this test safely.
> +	 */
> +	if (console_suspended || !can_use_console(cpu)) {
> +		wake = 1;
> +		goto out;
>  	}
> +
> +	/* console is now locked */
> +
> +	console_locked = 1;
> +	console_may_schedule = 0;
> +	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
> +
> +	retval = 1;
> +
> +out:
>  	logbuf_cpu = UINT_MAX;
> +	/*
> +	 * The logbuf_lock must not be held when doing a wake up,
> +	 * which the up(&console_sem) can do.
> +	 */
> +	raw_spin_unlock(&logbuf_lock);
>  	if (wake)
>  		up(&console_sem);
> -	raw_spin_unlock(&logbuf_lock);
>  	return retval;
>  }
>  
> @@ -1495,11 +1514,17 @@ asmlinkage int vprintk_emit(int facility, int level,
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
> +
> +	if (level == -2) {
> +		level = -1;
> +		in_sched = true;
> +	}
>  
>  	boot_delay_msec(level);
>  	printk_delay();
> @@ -1545,7 +1570,12 @@ asmlinkage int vprintk_emit(int facility, int level,
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
> @@ -1620,7 +1650,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	 * The console_trylock_for_printk() function will release 'logbuf_lock'
>  	 * regardless of whether it actually gets the console semaphore or not.
>  	 */
> -	if (console_trylock_for_printk(this_cpu))
> +	if (console_trylock_for_printk(this_cpu, in_sched))
>  		console_unlock();
>  
>  	lockdep_on();
> @@ -1962,18 +1992,20 @@ int is_console_locked(void)
>  #define PRINTK_BUF_SIZE		512
>  
>  #define PRINTK_PENDING_WAKEUP	0x01
> -#define PRINTK_PENDING_SCHED	0x02
> +#define PRINTK_PENDING_OUTPUT	0x02
>  
>  static DEFINE_PER_CPU(int, printk_pending);
> -static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
>  
>  void printk_tick(void)
>  {
>  	if (__this_cpu_read(printk_pending)) {
>  		int pending = __this_cpu_xchg(printk_pending, 0);
> -		if (pending & PRINTK_PENDING_SCHED) {
> -			char *buf = __get_cpu_var(printk_sched_buf);
> -			printk(KERN_WARNING "[sched_delayed] %s", buf);
> +		if (pending & PRINTK_PENDING_OUTPUT) {
> +			if (console_trylock())
> +				console_unlock();
> +			else
> +				/* Try again later */
> +				__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
>  		}
>  		if (pending & PRINTK_PENDING_WAKEUP)
>  			wake_up_interruptible(&log_wait);
> @@ -2458,20 +2490,14 @@ late_initcall(printk_late_init);
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
> +	r = vprintk_emit(0, -2, NULL, 0, fmt, args);
>  	va_end(args);
>  
> -	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
> -	local_irq_restore(flags);
> +	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
>  
>  	return r;
>  }
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
