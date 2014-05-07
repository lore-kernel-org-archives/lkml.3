Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaEGOdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:33:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaEGOdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:33:23 -0400
Date: Wed, 7 May 2014 16:33:20 +0200
From: Jan Kara <jack@suse.cz>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] printk: Remove separate printk_sched buffers and use
 printk buf instead
Message-ID: <20140507143320.GD12433@quack.suse.cz>
References: <20140505191846.35aa6f9b@gandalf.local.home>
 <20140507091356.GE23108@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140507091356.GE23108@pathway.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-05-14 11:13:56, Petr Mládek wrote:
> On Mon 2014-05-05 19:18:46, Steven Rostedt wrote:
> > To prevent deadlocks with doing a printk inside the scheduler,
> > printk_sched() was created. The issue is that printk has a console_sem
> > that it can grab and release. The release does a wake up if there's a
> > task pending on the sem, and this wake up grabs the rq locks that is
> > held in the scheduler. This leads to a possible deadlock if the wake up
> > uses the same rq as the one with the rq lock held already.
> > 
> > What printk_sched() does is to save the printk write in a per cpu buffer
> > and sets the PRINTK_PENDING_SCHED flag. On a timer tick, if this flag is
> > set, the printk() is done against the buffer.
> > 
> > There's a couple of issues with this approach.
> > 
> > 1) If two printk_sched()s are called before the tick, the second one
> > will overwrite the first one.
> > 
> > 2) The temporary buffer is 512 bytes and is per cpu. This is a quite a
> > bit of space wasted for something that is seldom used.
> > 
> > In order to remove this, the printk_sched() can use the printk buffer
> > instead, and delay the console_trylock()/console_unlock() to the queued
> > work.
> > 
> > Because printk_sched() would then be taking the logbuf_lock, the
> > logbuf_lock must not be held while doing anything that may call into the
> > scheduler functions, which includes wake ups. Unfortunately, printk()
> > also has a console_sem that it uses, and on release, the
> > up(&console_sem) may do a wake up of any pending waiters. This must be
> > avoided while holding the logbuf_lock.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> > This version has been forward ported to the 3.15-rc releases.
> > ---
...
> > @@ -2440,18 +2470,20 @@
> >  #define PRINTK_BUF_SIZE		512
> >  
> >  #define PRINTK_PENDING_WAKEUP	0x01
> > -#define PRINTK_PENDING_SCHED	0x02
> > +#define PRINTK_PENDING_OUTPUT	0x02
> >  
> >  static DEFINE_PER_CPU(int, printk_pending);
> > -static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
> >  
> >  static void wake_up_klogd_work_func(struct irq_work *irq_work)
> >  {
> >  	int pending = __this_cpu_xchg(printk_pending, 0);
> >  
> > -	if (pending & PRINTK_PENDING_SCHED) {
> > -		char *buf = __get_cpu_var(printk_sched_buf);
> > -		pr_warn("[sched_delayed] %s", buf);
> > +	if (pending & PRINTK_PENDING_OUTPUT) {
> > +		if (console_trylock())
> > +			console_unlock();
> 
> I wonder if we should call here console_trylock_for_printk() which checks
> whether the console is really usable.
  So Stephen couldn't use console_trylock_for_printk() because that expects
logbuf_lock to be locked in vanilla kernel. Only after locking changes I
did it would be usable.
 
> The check for usable console was introduced in the commit
> 76a8ad293912cd2f (Make printk work for really early debugging).
> I think that this IRQ work could get called during early boot,
> so the check would make sense here as well. Or have I missed something?
  I'm not really sure if IRQ work can be run on CPU which is not online.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
