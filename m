Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaKWVhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 16:37:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaKWVhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:37:04 -0500
Message-ID: <1416778611.11084.2.camel@linux-t7sj.site>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
From: Davidlohr Bueso <dave@stgolabs.net>
To: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>, 1vier1@web.de
Date: Sun, 23 Nov 2014 13:36:51 -0800
In-Reply-To: <54724B8A.8080607@redhat.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
	 <54722639.1040605@colorfullife.com> <54724B8A.8080607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 16:03 -0500, Rik van Riel wrote:
> On 11/23/2014 01:23 PM, Manfred Spraul wrote:
> > Hi Rik,
> > 
> > On 11/21/2014 08:52 PM, Rik van Riel wrote:
> >> When manipulating just one semaphore with semop, sem_lock only
> >> takes that single semaphore's lock. This creates a problem during
> >> initialization of the semaphore array, when the data structures
> >> used by sem_lock have not been set up yet. The sma->lock is
> >> already held by newary, and we just have to make sure everything
> >> else waits on that lock during initialization.
> >> 
> >> Luckily it is easy to make sem_lock wait on the sma->lock, by
> >> pretending there is a complex operation in progress while the sma
> >> is being initialized.
> > That's not sufficient, as sma->sem_nsems is accessed before
> > calling sem_lock(), both within find_alloc_undo() and within
> > semtimedop().
> > 
> > The root problem is that sma->sem_nsems and sma->sem_base are
> > accessed without any locks, this conflicts with the approach that
> > sma starts to exist as not yet initialized but locked and is
> > unlocked after the initialization is completed.
> > 
> > Attached is an idea. It did pass a few short tests. What do you
> > think?
> 
> This was my other idea for fixing the issue; unfortunately
> I didn't think of it until after I sent the first patch :)

Yep, this is what I was mentioning as well.

> You are right that without that change, we can return the
> wrong error codes to userspace.
> 
> I will give the patch a try, though I have so far been unable
> to reproduce the bug that the customer reported, so I am unlikely
> to give much in the way of useful testing results...
> 
> Andrew, feel free to give Manfred's patch my
> 
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

