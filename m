Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3BRQbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:31:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab3BRQbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:31:41 -0500
Date: Mon, 18 Feb 2013 17:31:35 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 3/3] printk: Avoid softlockups in console_unlock()
Message-ID: <20130218163135.GE12679@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
 <20130206230220.GA18329@quack.suse.cz>
 <20130215165710.GB12734@quack.suse.cz>
 <20130215142219.01915825.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215142219.01915825.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-02-13 14:22:19, Andrew Morton wrote:
> On Fri, 15 Feb 2013 17:57:10 +0100
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
> > callers to printk() or during next timer tick.
> > 
> 
> It still gives me tummy ache :(
  But it's better than it used to be, isn't it? At least I like this
version more than the one with postponing to worker thread since we only
depend on timer ticks to occur...

> The patch adds additional tests of oops_in_progress.  Some description
> of your thinking on that matter would be appropriate?
  Good point, I'll add that. My thinking was that when we are oopsing, all
bets are off and we want to get the messages to console as reliably as
possible and we don't care about soflockups anymore as we have bigger
trouble anyway.

> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -1990,17 +1990,31 @@ int is_console_locked(void)
> >  #define PRINTK_PENDING_OUTPUT	2
> >  
> >  static unsigned long printk_pending;
> > +static int last_printing_cpu = -1;
> > +
> > +static bool __console_unlock(void);
> >  
> >  void printk_tick(void)
> 
> printk_tick() no longer exists in linux-next.
  Thanks for notice, I'll rebase and fix this up.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
