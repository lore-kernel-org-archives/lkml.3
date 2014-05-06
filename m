Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866AbaEFLEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:04:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:30368 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934579AbaEFLEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:04:50 -0400
Date: Tue, 6 May 2014 07:04:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, pmladek@suse.cz,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] printk: Remove separate printk_sched buffers and use
 printk buf instead
Message-ID: <20140506070446.33bde17c@gandalf.local.home>
In-Reply-To: <20140506094557.GA9291@quack.suse.cz>
References: <20140505191846.35aa6f9b@gandalf.local.home>
	<20140506094557.GA9291@quack.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 11:45:57 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 05-05-14 19:18:46, Steven Rostedt wrote:
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
>   Andrew already has this patch in -mm tree AFAIK...

Ah, and somebody told me that it wasn't in linux-next. But looking at
it now, it seems to be.

Thanks!

-- Steve
