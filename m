Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaCLOfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:35:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaCLOe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:34:59 -0400
Date: Wed, 12 Mar 2014 15:34:56 +0100
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312143456.GB28695@quack.suse.cz>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
 <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
 <20140312064645.GJ30956@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312064645.GJ30956@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-03-14 07:46:45, Peter Zijlstra wrote:
> On Tue, Mar 11, 2014 at 10:32:26PM +0100, Thomas Gleixner wrote:
> > > Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
> > > already have something like this? Any other ideas here?
> > 
> > I was thinking about something like that for RT as on RT printk is a
> > complete nightmare. It's simple to implement that, but as we know from
> > the RT experience it can lead to painful loss of debug output.
> > 
> > Assume you printk inside such a region, which just fills the dmesg
> > buffer and schedules the delayed output. Now in that same region you
> > run into a deadlock which causes the whole machine to freeze. Then you
> > won't see the debug output, which might actually give you the hint why
> > the system deadlocked ....
> 
> Ok so I started writing a rant that I don't give a crap about klogd and
> that deferring that wakeup would be perfectly fine; then I looked at the
> code and found that we in fact do this already.
> 
> wake_up_klogd() schedules a lazy irqwork to go wake up, so that's out.
> 
> That leaves the console sem wakeup; but I suppose we could redo this
> patch:
> 
>   lkml.kernel.org/r/20110621153806.286257129@chello.nl
> 
> to get rid of that one.
  I don't know if you've noticed but there's also the following patch:
https://lkml.org/lkml/2013/12/23/310
  which would make it pretty easy to just add messages to printk buffer in
timer code and schedule printing later using irq work.

  Regarding your referenced patch - the way it is written, it would make
all printk users spin on console_sem->lock all the time while we are
flushing buffer to console. I don't think we want that - we trylock the
console_sem exactly so that other printk users can proceed while one poor
guy is pushing stuff to console.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
