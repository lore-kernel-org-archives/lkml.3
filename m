Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaEGOUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:20:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbaEGOUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:20:51 -0400
Date: Wed, 7 May 2014 16:20:47 +0200
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, pmladek@suse.cz,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] printk: Remove separate printk_sched buffers and use
 printk buf instead
Message-ID: <20140507142047.GC12433@quack.suse.cz>
References: <20140505191846.35aa6f9b@gandalf.local.home>
 <20140506094557.GA9291@quack.suse.cz>
 <20140506070446.33bde17c@gandalf.local.home>
 <20140506163714.058937e8d6ec17caca406fb7@linux-foundation.org>
 <20140506200519.69cd9112@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506200519.69cd9112@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-05-14 20:05:19, Steven Rostedt wrote:
> On Tue, 6 May 2014 16:37:14 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> 
> > What I have in -next is very different from this version of the patch. 
> > What's happening?
> 
> Hmm, it looks massaged from what I originally sent in order to be
> placed after the other patches in the series. A quick review of the
> patch seems to be mostly the same logic, but it is a bit different.
> 
> Jan, did you update my patch?
  Yes, I was carrying it for quite long and with each rebase and rewrite of
the patch set it got massaged a bit. So in the end it's probably somewhat
different from what you originally submitted.

> > From: Steven Rostedt <rostedt@goodmis.org>
> > Subject: printk: remove separate printk_sched buffers and use printk buf instead
> > 
> > To prevent deadlocks with doing a printk inside the scheduler,
> > printk_sched() was created.  The issue is that printk has a console_sem
> > that it can grab and release.  The release does a wake up if there's a
> > task pending on the sem, and this wake up grabs the rq locks that is held
> > in the scheduler.  This leads to a possible deadlock if the wake up uses
> > the same rq as the one with the rq lock held already.
> > 
> > What printk_sched() does is to save the printk write in a per cpu buffer
> > and sets the PRINTK_PENDING_SCHED flag.  On a timer tick, if this flag is
> > set, the printk() is done against the buffer.
> > 
> > There's a couple of issues with this approach.
> > 
> > 1) If two printk_sched()s are called before the tick, the second one
> >    will overwrite the first one.
> > 
> > 2) The temporary buffer is 512 bytes and is per cpu.  This is a quite a
> >    bit of space wasted for something that is seldom used.
> > 
> > In order to remove this, the printk_sched() can use the printk buffer
> > instead, and delay the console_trylock()/console_unlock() to the queued
> > work.
> > 
> > Because printk_sched() would then be taking the logbuf_lock, the
> > logbuf_lock must not be held while doing anything that may call into the
> > scheduler functions, which includes wake ups.  Unfortunately, printk()
> > also has a console_sem that it uses, and on release, the up(&console_sem)
> > may do a wake up of any pending waiters.  This must be avoided while
> > holding the logbuf_lock.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Jan, if you did massage my patch, you should add here what you did.
> Usually in [brackets]. Otherwise it puts the blame on me if something
> breaks, or adds confusion if I happen to send out another patch like I
> just did.
  Yeah, sorry for that. I should have been updating the changelog with what
I did...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
