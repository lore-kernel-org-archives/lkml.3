Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaEFNNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:13:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34265 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbaEFNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:13:04 -0400
Date: Tue, 6 May 2014 14:12:34 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jan Kara <jack@suse.cz>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140506131234.GD30234@arm.com>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
 <20140506120648.GA30234@arm.com>
 <20140506122958.GG9291@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506122958.GG9291@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 01:29:58PM +0100, Jan Kara wrote:
> On Tue 06-05-14 13:06:48, Will Deacon wrote:
> > On Fri, May 02, 2014 at 11:46:51PM +0100, Jan Kara wrote:
> > >   I really dislike this patch. It goes completely against my efforts of
> > > lowering irq latency caused by printing to console (which are the
> > > problems I have observed ;).
> > 
> > Hmmm, what makes you think that? Interrupts only remain disabled whilst we
> > process the backlog, which in the usual case should be pretty small. We also
> > hold the logbuf_lock during this time, so we can't get stuck in an unbounded
> > loop.
> >
> > Can you elaborate a bit more on the problems you've observed, please?
>   Well, with serial console the backlog can get actually pretty big. During
> boot on large machines I've seen CPUs stuck in that very loop in
> console_unlock() for tens of seconds. Obviously that causes problems - e.g.
> watchdog fires, RCU lockup detector fires, when interrupts are disabled,
> some hardware gives up because its interrupts weren't served for too long.
> All in all the machine just dies.

Right, so there's the usual compromise here between throughput and latency.
I hoped that pegging the amount of irq-disabled work using console_end_seq
would give us the best of both worlds, but you're saying that it can still
lead to issues on large machines (in the worst case, the whole buffer fills
up while we're printing the last lot, so the irq-disabled work amounts to
draining logbuf, right?).

That said, printing one message each time seems to go too far in the
opposite direction for my liking, so the best bet is likely to limit the
work to some fixed number of messages. Do you have any feeling for such a
limit?

> And the backlog builds up because while one cpu is doing the printing in
> console_unlock() all the other cpus are busily adding new messages to the
> buffer faster than they can be printed...

Understood, but that's also the situation without this patch (and not one
that I think you can fix without hurting latency).

> > > My opinion is that when you are printing from each and every interrupt
> > > which happens so often, then you have a problem and disabling IRQs in
> > > printk so that your interrupt doesn't happen that often seems like a poor
> > > solution to me. You could as well just ratelimit your debug messages,
> > > couldn't you?
> > 
> > My use-case was basically using printk as a debug trace during early boot
> > when bringing up Linux on a new CPU core. I don't think ratelimiting would
> > be the right thing there, since I really did want as many messages to
> > reach the console as possible (which is also why I wrote this patch, not
> > just the other one in the series).
>   OK, I understand. It just seems wrong to me to throttle all interrupts on
> the cpu while doing printing just because someone might be doing debug
> printing from the interrupt. Sure it's fine as a debug hack but on a
> production machine that seems rather counterproductive.

Perhaps, but the one time I *really* want printk to be reliable is when I'm
using it to debug a problem.

Will
