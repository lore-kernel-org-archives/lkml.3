Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3ILPBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:01:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:59140 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3ILPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:01:38 -0400
Date: Thu, 12 Sep 2013 17:01:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Kent Overstreet <kmo@daterainc.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: PREEMPT_RT vs bcache
In-Reply-To: <20130808121154.GA5180@infradead.org>
Message-ID: <alpine.DEB.2.02.1309121653110.4089@ionos.tec.linutronix.de>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk> <20130808072623.GA3509@infradead.org> <20130808074326.GA15409@kmo-pixel> <20130808121154.GA5180@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013, Christoph Hellwig wrote:

> On Thu, Aug 08, 2013 at 12:43:26AM -0700, Kent Overstreet wrote:
> > I seem to recall from looking at the logs that you just removed them
> > because all the old users could be and were converted to something
> > saner, for what they were doing (using them as completions, I want to
> > say?)
> 
> We explicitly converted them away so that we could kill it.  This was
> a joint project with Thomas.
> 
> > Bcache isn't using the rw sem as a completion though, it really is a
> > read/write lock that protects a specific data structure, and  where
> > we're taking a read lock for the duration of write IOs - and since bios
> > are asynchronous, that's why we need the non_owner() bit.
> 
> Part of this commit was to make the rw_semaphore behaviour similar to
> plain mutex, that is making sure there is exactly one owner and not
> different processes locking/unlocking it.  This is useful for PI (that's
> why the rt folks care), lock debugging and kinds of other use cases.

Right. We had to implement an anon_rw_semaphore version, which caused
more headache than it was worth the trouble.

The solution for one of the non owner use cases was something like the
below:

      read_lock(x->lock);
      atomic_inc(x->io_active);
      launch_io();
      read_unlock(x->lock);

On the writer side:

      write_lock(x->lock);
      while (atomic_read(x->io_active) {
      	    write_unlock(x->lock);
      	    wait_event(x->wait_for_io, !atomic_read(x->io_active));
	    write_lock(x->io_active);
      }
      ....

On the io side:

       complete_io()
         if (atomic_dec_and_test(x->io_active) &&
             waitqueue_active(x->wait_for_io))
                wake_up(x->wait_for_io);


That would fit into the bcache use case afacit.

Thanks,

	tglx
