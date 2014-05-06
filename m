Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbaEFMHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:07:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757426AbaEFMHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:07:19 -0400
Date: Tue, 6 May 2014 13:06:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jan Kara <jack@suse.cz>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Message-ID: <20140506120648.GA30234@arm.com>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
 <20140502224651.GG23636@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502224651.GG23636@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 02, 2014 at 11:46:51PM +0100, Jan Kara wrote:
> On Fri 02-05-14 14:22:20, Andrew Morton wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > Subject: printk: print initial logbuf contents before re-enabling interrupts
> > 
> > When running on a hideously slow system (~10Mhz FPGA) with a bunch of
> > debug printk invocations on the timer interrupt path, we end up filling
> > the log buffer faster than we can drain it.
> > 
> > The reason is that console_unlock (which is responsible for moving
> > messages out of logbuf to hand over to the console driver) removes one
> > message at a time, briefly re-enabling interrupts between each of them. 
> > If the interrupt path prints more than a single message, then we can
> > easily generate more messages than we can print for a regular, recurring
> > interrupt (e.g.  a 1khz timer).  This results in messages getting silently
> > dropped, leading to counter-intuitive, incomplete printk traces on the
> > console.
> > 
> > Rather than run the console_unlock loop with interrupts disabled (which
> > has obvious latency problems), this patch records the sequence number of
> > the last message in the log buffer after taking the logbuf_lock.  We can
> > then print this fixed amount of work before re-enabling interrupts again,
> > making sure we keep up with ourself.  Other CPUs could still potentially
> > flood the buffer, but there's little that we can do to protect against
> > that.
>   I really dislike this patch. It goes completely against my efforts of
> lowering irq latency caused by printing to console (which are the
> problems I have observed ;).

Hmmm, what makes you think that? Interrupts only remain disabled whilst we
process the backlog, which in the usual case should be pretty small. We also
hold the logbuf_lock during this time, so we can't get stuck in an unbounded
loop.

Can you elaborate a bit more on the problems you've observed, please?

> My opinion is that when you are printing from each and every interrupt
> which happens so often, then you have a problem and disabling IRQs in
> printk so that your interrupt doesn't happen that often seems like a poor
> solution to me. You could as well just ratelimit your debug messages,
> couldn't you?

My use-case was basically using printk as a debug trace during early boot
when bringing up Linux on a new CPU core. I don't think ratelimiting would
be the right thing there, since I really did want as many messages to
reach the console as possible (which is also why I wrote this patch, not
just the other one in the series).

Cheers,

Will
