Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3KRXmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:42:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KRXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:42:30 -0500
Date: Tue, 19 Nov 2013 00:42:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131118234209.GO16796@laptop.programming.kicks-ass.net>
References: <20131117080603.2a0d3b6d@notabene.brown>
 <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:27:46PM -0800, Andrew Morton wrote:
> On Sun, 17 Nov 2013 08:06:03 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > It would be reasonable to assume that
> > 
> >       wait_for_completion_timeout(&wm8350->auxadc_done, msecs_to_jiffies(5));
> > 
> > would wait at least 5 msecs for the auxadc_done to complete.  But it does not.
> > With a HZ of 200 or less, msecs_to_jiffies(5) has value '1', and so this
> > will only wait until the next "timer tick", which could happen immediately.
> > 
> > This can lead to incorrect results - and has done so in out-of-tree patches
> > for drivers/misc/bmp085.c which uses a very similar construct to enable interrupt
> > based result collection.
> > 
> > The documentation for several *_timeout* functions claim they will wait for
> > "timeout jiffies" to have elapsed where this is not the case.  They will
> > actually wait for "timeout" jiffies to have started implying an elapsed time
> > between (timeout-1) and (timeout).
> > 
> > This patch corrects some of this documentation, and adds a collection of
> >   wait_for_completion*_msecs()
> > interfaces which wait at least the given number of milliseconds for the
> > completion (or a signal).
> 
> Mutter.  wait_for_x(..., 5ms) should wait for a minimum of 5ms, no matter
> what.
> 
> So I'd suggest we make that happen, rather than adding some new interfaces?

Yeah, also the completion interface is just one of many that's buggered
this way.

I briefly talked to Thomas about this earlier today and we need to fix
this at a lower level -- the quick 'n dirty solution is to add 1 jiffy
down in the timer-wheel when we enqueue these things.

And yes, we very much don't want to create new interfaces with similar
but slightly different semantics, that's just asking for trouble.
