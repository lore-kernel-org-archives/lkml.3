Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3APRCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:02:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60175 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757505Ab3APRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:01:54 -0500
Date: Wed, 16 Jan 2013 12:01:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <20130116161224.GO2668@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1301161132470.1704-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013, Tejun Heo wrote:

> Hello, Alan.
> 
> On Tue, Jan 15, 2013 at 11:01:15PM -0500, Alan Stern wrote:
> > > The current domain implementation is somewhere inbetween.  It's not
> > > completely simplistic system and at the same time not developed enough
> > > to do properly stacked flushing.
> > 
> > I like your idea of chronological synchronization: Insist that anybody
> > who wants to flush async jobs must get a cookie, and then only allow
> > them to wait for async jobs started after the cookie was issued.
> > 
> > I don't know if this is possible with the current implementation.  It 
> > would require changing every call to async_synchronize_*(), and in a 
> > nontrivial way.  But it might provide a proper solution to all these 
> > problems.
> 
> The problem here is that "flush everything which comes before me" is
> used to order async jobs.  e.g. after async jobs probe the hardware
> they order themselves by flushing before registering them, so unless

I don't fully understand this example.  What is the point -- to make 
sure that asynchronously probed devices are registered in the order of 
their discovery?

If so, here's how to do it safely: Start up the async jobs in reverse
order of discovery.  Have each job acquire a cookie when it starts.  
Then each job needs to wait only for tasks that started after its
cookie was issued.

> we build accurate flushing dependencies, those dependencies will reach
> beyond the time window we're interested in and bring in deadlocks.

The flushing-dependency principle can be very simple: No async task
should ever have to wait for another async task that started before it.  
The "cookie" approach satisfies this requirement (unless an earlier 
task passes its cookie to a later task or subverts the mechanism in 
another way).

> And, as Linus pointed it out, tracking dependency through
> request_module() is tricky no matter what we do.  I think it can be
> done by matching the ones calling request_module() and the ones
> actually loading modules but it's gonna be nasty.

This shouldn't matter.  Dependencies don't need to be tracked
explicitly, because we know that any async work done by
request_module() must start _after_ request_module() is called.  Thus,
if async task A calls request_module(), which starts up async task B,
then we know that A can safely wait for B and B cannot safely wait for
A.

> There aren't too many which use async anyway so changing stuff
> shouldn't be too difficult but I think the simpicity or dumbness is
> one of major attractions of async, so it'd be nice to keep things that
> way and the PF_USED_ASYNC hack seems to be able to hold things
> together for now.

Nesting won't matter for the chronological approach.  I really think 
you should consider it more fully.  It's not a hack, and it doesn't 
need to be complicated.

Alan Stern

