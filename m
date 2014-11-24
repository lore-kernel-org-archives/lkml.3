Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaKXKla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:41:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbaKXKl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:41:27 -0500
Date: Mon, 24 Nov 2014 05:41:16 -0500
From: Rafael Aquini <aquini@redhat.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Rik van Riel <riel@redhat.com>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
Message-ID: <20141124104115.GA26444@t510.redhat.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
 <54722639.1040605@colorfullife.com>
 <54724B8A.8080607@redhat.com>
 <1416778611.11084.2.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416778611.11084.2.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 01:36:51PM -0800, Davidlohr Bueso wrote:
> On Sun, 2014-11-23 at 16:03 -0500, Rik van Riel wrote:
> > On 11/23/2014 01:23 PM, Manfred Spraul wrote:
> > > Hi Rik,
> > > 
> > > On 11/21/2014 08:52 PM, Rik van Riel wrote:
> > >> When manipulating just one semaphore with semop, sem_lock only
> > >> takes that single semaphore's lock. This creates a problem during
> > >> initialization of the semaphore array, when the data structures
> > >> used by sem_lock have not been set up yet. The sma->lock is
> > >> already held by newary, and we just have to make sure everything
> > >> else waits on that lock during initialization.
> > >> 
> > >> Luckily it is easy to make sem_lock wait on the sma->lock, by
> > >> pretending there is a complex operation in progress while the sma
> > >> is being initialized.
> > > That's not sufficient, as sma->sem_nsems is accessed before
> > > calling sem_lock(), both within find_alloc_undo() and within
> > > semtimedop().
> > > 
> > > The root problem is that sma->sem_nsems and sma->sem_base are
> > > accessed without any locks, this conflicts with the approach that
> > > sma starts to exist as not yet initialized but locked and is
> > > unlocked after the initialization is completed.
> > > 
> > > Attached is an idea. It did pass a few short tests. What do you
> > > think?
> > 
> > This was my other idea for fixing the issue; unfortunately
> > I didn't think of it until after I sent the first patch :)
> 
> Yep, this is what I was mentioning as well.
> 
> > You are right that without that change, we can return the
> > wrong error codes to userspace.
> > 
> > I will give the patch a try, though I have so far been unable
> > to reproduce the bug that the customer reported, so I am unlikely
> > to give much in the way of useful testing results...
> > 
> > Andrew, feel free to give Manfred's patch my
> > 
> > Acked-by: Rik van Riel <riel@redhat.com>
> 
> Acked-by: Davidlohr Bueso <dave@stgolabs.net>
> 
Acked-by: Rafael Aquini <aquini@redhat.com>
