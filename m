Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3BFPTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:19:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab3BFPTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:19:37 -0500
Date: Wed, 6 Feb 2013 15:23:46 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
Message-ID: <20130206142346.GF6330@quack.suse.cz>
References: <1360016230-26696-1-git-send-email-jack@suse.cz>
 <20130205123838.146a5371.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205123838.146a5371.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-02-13 12:38:38, Andrew Morton wrote:
> On Mon,  4 Feb 2013 23:17:10 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > A CPU can be caught in console_unlock() for a long time (tens of seconds are
> > reported by our customers) when other CPUs are using printk heavily and serial
> > console makes printing slow. Despite serial console drivers are calling
> > touch_nmi_watchdog() this triggers softlockup warnings because
> > interrupts are disabled for the whole time console_unlock() runs (e.g.
> > vprintk() calls console_unlock() with interrupts disabled). Thus IPIs
> > cannot be processed and other CPUs get stuck spinning in calls like
> > smp_call_function_many(). Also RCU eventually starts reporting lockups.
> > 
> > In my artifical testing I also managed to trigger a situation when disk
> > disappeared from the system apparently because commands to / from it
> > could not be delivered for long enough. This is why just silencing
> > watchdogs isn't a reliable solution to the problem and we simply have to
> > avoid spending too long in console_unlock().
> > 
> > We fix the issue by limiting the time we spend in console_unlock() to
> > watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
> > happening). The rest of the buffer will be printed either by further
> > callers to printk() or by a queued work.
> 
> I still hate the patch :(
> 
> > ...
> >
> > +void console_unlock(void)
> > +{
> > +	if (__console_unlock()) {
> > +		/* Let worker do the rest of printing */
> > +		schedule_work(&printk_work);
> > +	}
> >  }
> 
> This creates another place from where we cannot call printk(): anywhere
> where worker_pool.lock is held.
> 
> And as schedule_work() can do a wakeup it creates a third reason why
> the sched code cannot call printk (along with rq->lock taken by
> wake_up(klogd) and rq->lock taken by up(&console_sem).  Hence
> printk_sched().  See the lkml thread "[GIT PULL] printk: Support for
> full dynticks mode".
> 
> We already have machinery for doing async tickling in printk: the
> printk_pending stuff.  Did you consider adding another
> PRINTK_PENDING_foo in some fashion?
  Yes, I noticed that thread just yesterday and also though that using
similar trick might be viable. I'll experiment if we could use the same
method for handling lockup problems I hit. Steven seems to have already
tweaked PRINTK_PENDING stuff to be usable more easily...

								Honza

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
