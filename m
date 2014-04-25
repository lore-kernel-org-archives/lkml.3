Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaDYOBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:01:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaDYOBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:01:25 -0400
Date: Fri, 25 Apr 2014 16:01:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 1/2] printk: print initial logbuf contents before
 re-enabling interrupts
Message-ID: <20140425140120.GG11096@twins.programming.kicks-ass.net>
References: <1397734570-12748-1-git-send-email-will.deacon@arm.com>
 <20140425132937.GB10484@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425132937.GB10484@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 02:29:37PM +0100, Will Deacon wrote:
> Hi all,
> 
> On Thu, Apr 17, 2014 at 12:36:09PM +0100, Will Deacon wrote:
> > When running on a hideously slow system (~10Mhz FPGA) with a bunch of

Hey, still faster then the 4.77 MHz 8088 chips I started with :-)

> > debug printk invocations on the timer interrupt path, we end up filling
> > the log buffer faster than we can drain it.
> > 
> > The reason is that console_unlock (which is responsible for moving
> > messages out of logbuf to hand over to the console driver) removes one
> > message at a time, briefly re-enabling interrupts between each of them.
> > If the interrupt path prints more than a single message, then we can
> > easily generate more messages than we can print for a regular, recurring
> > interrupt (e.g. a 1khz timer). This results in messages getting silently
> > dropped, leading to counter-intuitive, incomplete printk traces on the
> > console.
> > 
> > Rather than run the console_unlock loop with interrupts disabled (which
> > has obvious latency problems), this patch records the sequence number of
> > the last message in the log buffer after taking the logbuf_lock. We can
> > then print this fixed amount of work before re-enabling interrupts again,
> > making sure we keep up with ourself. Other CPUs could still potentially
> > flood the buffer, but there's little that we can do to protect against
> > that.
> 
> Any thoughts on these two patches? I can understand the reluctance to make
> changes to printk, but I had a horrible time debugging timers without these
> patches!

They look fine to me.
