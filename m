Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaEFPBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:01:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40292 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbaEFPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:01:07 -0400
Date: Tue, 6 May 2014 16:00:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jan Kara <jack@suse.cz>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140506150036.GJ30234@arm.com>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
 <20140506120648.GA30234@arm.com>
 <20140506122958.GG9291@quack.suse.cz>
 <20140506131234.GD30234@arm.com>
 <20140506140032.GA22739@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506140032.GA22739@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 03:00:32PM +0100, Jan Kara wrote:
> On Tue 06-05-14 14:12:34, Will Deacon wrote:
> > On Tue, May 06, 2014 at 01:29:58PM +0100, Jan Kara wrote:
> > >   Well, with serial console the backlog can get actually pretty big. During
> > > boot on large machines I've seen CPUs stuck in that very loop in
> > > console_unlock() for tens of seconds. Obviously that causes problems - e.g.
> > > watchdog fires, RCU lockup detector fires, when interrupts are disabled,
> > > some hardware gives up because its interrupts weren't served for too long.
> > > All in all the machine just dies.
> > 
> > Right, so there's the usual compromise here between throughput and latency.
>   I'd see that compromise if enabling & disabling interrupts would be
> taking considerable amount of time. I don't think that was your concern,
> was it? Maybe I just misunderstood you...

Well, that isn't the quickest operation on ARM (since it's
self-synchronising), but I was actually referring to the ability to drain
the log buffer (with interrupts disabled) vs the ability to service
interrupts quickly. The moment we re-enable interrupts, we can start adding
more messages to the buffer from the IRQ path (I didn't attempt to solve the
multi-CPU case, as I mentioned before).

> > That said, printing one message each time seems to go too far in the
> > opposite direction for my liking, so the best bet is likely to limit the
> > work to some fixed number of messages. Do you have any feeling for such a
> > limit?
>   If you really are concerned about enabling and disabling of interrupts
> taking significant time (and it may be, I just don't know), then printing
> couple of messages without enabling them makes sense. How many is a tricky
> question since it depends on the console speed. I had a similar problem
> when I was deciding in my patch when we should ask another CPU to take over
> printing from the current CPU (to avoid the issues I've described in the
> previous email). I was experimenting with various stuff but in the end I
> restorted to a stupid "after X characters are printed".

Yeah, so you also end up with the same problem of tuning your heuristics.
Peter's suggestion of X == 42 is as good as any arbitrary constant I can
suggest, hence my snapshotting of log_next_seq originally.

> > > And the backlog builds up because while one cpu is doing the printing in
> > > console_unlock() all the other cpus are busily adding new messages to the
> > > buffer faster than they can be printed...
> > 
> > Understood, but that's also the situation without this patch (and not one
> > that I think you can fix without hurting latency).
>   Sure. I have a patch which transitions printing to another CPU once in a
> while so single CPU isn't hogged for too long and that solves the issues I
> have observed. But Alan didn't like this solution so the issue is unfixed
> for now.

Interesting. Do you have a pointer to the thread?

Will
