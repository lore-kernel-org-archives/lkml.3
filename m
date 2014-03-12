Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaCLGq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:46:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48118 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaCLGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:46:54 -0400
Date: Wed, 12 Mar 2014 07:46:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, Jiri Bohac <jbohac@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312064645.GJ30956@twins.programming.kicks-ass.net>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
 <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 10:32:26PM +0100, Thomas Gleixner wrote:
> > Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
> > already have something like this? Any other ideas here?
> 
> I was thinking about something like that for RT as on RT printk is a
> complete nightmare. It's simple to implement that, but as we know from
> the RT experience it can lead to painful loss of debug output.
> 
> Assume you printk inside such a region, which just fills the dmesg
> buffer and schedules the delayed output. Now in that same region you
> run into a deadlock which causes the whole machine to freeze. Then you
> won't see the debug output, which might actually give you the hint why
> the system deadlocked ....

Ok so I started writing a rant that I don't give a crap about klogd and
that deferring that wakeup would be perfectly fine; then I looked at the
code and found that we in fact do this already.

wake_up_klogd() schedules a lazy irqwork to go wake up, so that's out.

That leaves the console sem wakeup; but I suppose we could redo this
patch:

  lkml.kernel.org/r/20110621153806.286257129@chello.nl

to get rid of that one.

However, at that point we run into the fact that many console drivers do
wakeups themselves. I did fix 8250, because that is in fact the only
console I really care about, but in general Linus said to give up and
deal with the fact that console drivers suck already (or something along
those lines).

And while I was looking at all that; I got reminded that I really need
to respin this one:

  lkml.kernel.org/r/20111221111143.511565321@chello.nl

Since that whole printk recursion + zap_locks thing is terminally
broken.


