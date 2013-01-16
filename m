Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3APR6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:58:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60372 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755728Ab3APR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:58:08 -0500
Date: Wed, 16 Jan 2013 12:51:27 -0500 (EST)
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
In-Reply-To: <20130116173703.GR2668@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1301161249010.1704-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013, Tejun Heo wrote:

> Hello, Alan.
> 
> On Wed, Jan 16, 2013 at 12:01:53PM -0500, Alan Stern wrote:
> > > The problem here is that "flush everything which comes before me" is
> > > used to order async jobs.  e.g. after async jobs probe the hardware
> > > they order themselves by flushing before registering them, so unless
> > 
> > I don't fully understand this example.  What is the point -- to make 
> > sure that asynchronously probed devices are registered in the order of 
> > their discovery?
> 
> People still want devices to be numbered to their physical ports and
> so on, so we keep the registeration order the same as natural
> (whatever that means) hardware order.
> 
> > If so, here's how to do it safely: Start up the async jobs in reverse
> > order of discovery.  Have each job acquire a cookie when it starts.  
> > Then each job needs to wait only for tasks that started after its
> > cookie was issued.
> 
> It's a bit clumsy but yeah I guess it could work.
> 
> > > There aren't too many which use async anyway so changing stuff
> > > shouldn't be too difficult but I think the simpicity or dumbness is
> > > one of major attractions of async, so it'd be nice to keep things that
> > > way and the PF_USED_ASYNC hack seems to be able to hold things
> > > together for now.
> > 
> > Nesting won't matter for the chronological approach.  I really think 
> > you should consider it more fully.  It's not a hack, and it doesn't 
> > need to be complicated.
> 
> There is benefit to the current dumb implementation in that drivers
> can use it without thinking too much, but yeah it could be that the
> flushing range limit isn't too much of restriction on top.  I don't
> know.  At this point, I'd prefer to remove request_module() from
> elevator init path for the problem at hand.  If we need something more
> involved, changing cookie usage rules definitely seems like an option.

A simpler approach might be to leave the existing synchronization 
mechanisms as they are, and use the chronological approach only for the 
case of loading a module (or wherever else someone wants to use it).

Alan Stern

