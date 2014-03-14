Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaCNPNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:13:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaCNPNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:13:17 -0400
Date: Fri, 14 Mar 2014 16:13:14 +0100
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Jiri Bohac <jbohac@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140314151314.GA5361@quack.suse.cz>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
 <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
 <20140312064645.GJ30956@twins.programming.kicks-ass.net>
 <20140312143456.GB28695@quack.suse.cz>
 <20140312150617.GE27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312150617.GE27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-03-14 16:06:17, Peter Zijlstra wrote:
> On Wed, Mar 12, 2014 at 03:34:56PM +0100, Jan Kara wrote:
> > On Wed 12-03-14 07:46:45, Peter Zijlstra wrote:
> > > On Tue, Mar 11, 2014 at 10:32:26PM +0100, Thomas Gleixner wrote:
> > > > > Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
> > > > > already have something like this? Any other ideas here?
> > > > 
> > > > I was thinking about something like that for RT as on RT printk is a
> > > > complete nightmare. It's simple to implement that, but as we know from
> > > > the RT experience it can lead to painful loss of debug output.
> > > > 
> > > > Assume you printk inside such a region, which just fills the dmesg
> > > > buffer and schedules the delayed output. Now in that same region you
> > > > run into a deadlock which causes the whole machine to freeze. Then you
> > > > won't see the debug output, which might actually give you the hint why
> > > > the system deadlocked ....
> > > 
> > > Ok so I started writing a rant that I don't give a crap about klogd and
> > > that deferring that wakeup would be perfectly fine; then I looked at the
> > > code and found that we in fact do this already.
> > > 
> > > wake_up_klogd() schedules a lazy irqwork to go wake up, so that's out.
> > > 
> > > That leaves the console sem wakeup; but I suppose we could redo this
> > > patch:
> > > 
> > >   lkml.kernel.org/r/20110621153806.286257129@chello.nl
> > > 
> > > to get rid of that one.
> >   I don't know if you've noticed but there's also the following patch:
> > https://lkml.org/lkml/2013/12/23/310
> >   which would make it pretty easy to just add messages to printk buffer in
> > timer code and schedule printing later using irq work.
> 
> Yeah; I suppose that one is prettier.
  JFYI, that patch has been just added to -mm tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
