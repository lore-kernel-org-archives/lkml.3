Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaACHtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 02:49:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaACHti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 02:49:38 -0500
Date: Fri, 3 Jan 2014 08:49:34 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        pmladek@suse.cz, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] printk: Release lockbuf_lock before calling
 console_trylock_for_printk()
Message-ID: <20140103074934.GC31086@quack.suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-7-git-send-email-jack@suse.cz>
 <20140102205305.3c607926@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102205305.3c607926@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-01-14 20:53:05, Steven Rostedt wrote:
> On Mon, 23 Dec 2013 21:39:27 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > There's no reason to hold lockbuf_lock when entering
> > console_trylock_for_printk(). The first thing this function does is
> > calling down_trylock(console_sem) and if that fails it immediately
> > unlocks lockbuf_lock. So lockbuf_lock isn't needed for that branch.
> > When down_trylock() succeeds, the rest of console_trylock() is OK
> > without lockbuf_lock (it is called without it from other places), and
> > the only remaining thing in console_trylock_for_printk() is
> > can_use_console() call. For that call console_sem is enough (it
> > iterates all consoles and checks CON_ANYTIME flag).
> > 
> > So we drop logbuf_lock before entering console_trylock_for_printk()
> > which simplifies the code.
> 
> I'm very nervous about this change. The interlocking between console
> lock and logbuf_lock seems to be very subtle. Especially the comment
> where logbuf_lock is defined:
> 
> /*
>  * The logbuf_lock protects kmsg buffer, indices, counters. It is also
>  * used in interesting ways to provide interlocking in console_unlock();
>  */
> 
> Unfortunately, it does not specify what those "interesting ways" are.
  Hum, yes. So I was digging in history and the comment was added by Andrew
Morton in early 2002 when converting console_lock to console_sem +
logbuf_lock. I'm sure he remembers all the details ;) It is part of commit
a880f45a48be2956d2c78a839c472287d54435c1 in linux-history.git.

Looking into that commit I think the comment refers to the following trick:
printk()
	/* This stops the holder of console_sem just where we want him */
	spin_lock_irqsave(&logbuf_lock, flags);
	...
	if (!down_trylock(&console_sem)) {
		/*
		 * We own the drivers.  We can drop the spinlock and let
		 * release_console_sem() print the text
		 */
		spin_unlock_irqrestore(&logbuf_lock, flags);
		...
	} else {
		/*
		 * Someone else owns the drivers.  We drop the spinlock, which
		 * allows the semaphore holder to proceed and to call the
		 * console drivers with the output which we just produced.
		 */
		spin_unlock_irqrestore(&logbuf_lock, flags);
	}

release_console_sem() (equivalent of today's console_unlock()):
	for ( ; ; ) {
		spin_lock_irqsave(&logbuf_lock, flags);
...
		if (con_start == log_end)
			break;                  /* Nothing to print */
...
		spin_unlock_irqrestore(&logbuf_lock, flags);
		call_console_drivers(_con_start, _log_end);
	}
	up(&console_sem);
	spin_unlock_irqrestore(&logbuf_lock, flags);

This interesting combination of console_sem and logbuf_lock locking makes
sure we cannot exit the loop in release_console_sem() before printk()
decides whether it should do printing or not. So the appended message gets
reliably printed either by current holder of console_sem or by CPU in
printk(). Apparently this trick got broken sometime later and then fixed up
again by rechecking 'console_seq != log_next_seq' after releasing
console_sem. So I think the comment isn't valid anymore.

> Now what I think this does is to make sure whoever wrote to the logbuf
> first, does the flushing. With your change we now have:
> 
> 	CPU 0				CPU 1
> 	-----				-----
>    printk("blah");
>    lock(logbuf_lock);
> 
> 				printk("bazinga!");
> 				lock(logbuf_lock);
> 				<blocked>
> 
>    unlock(logbuf_lock);
>    < NMI comes in delays CPU>
> 
> 				<get logbuf_lock>
> 				unlock(logbuf_lock)
> 				console_trylock_for_printk()
> 				console_unlock();
> 				< dumps output >
> 
>   
> Now is this a bad thing? I don't know. But the current locking will
> make sure that the first writer into logbuf_lock gets to do the
> dumping, and all the others will just add onto that writer.
> 
> Your change now lets the second or third or whatever writer into printk
> be the one that dumps the log.
  I agree and I admit I didn't think about this. But given how printk
buffering works this doesn't seem to be any problem at all. But I can
comment about this in the changelog.

> Again, this may not be a big deal, but as printk is such a core part of
> the Linux kernel, and this is a very subtle change, I rather be very
> cautious here and try to think what can go wrong when this happens.
  Sure. Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
