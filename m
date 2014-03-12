Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbaCLSop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:44:45 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:21060 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaCLSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:44:43 -0400
X-Greylist: delayed 98418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2014 14:44:43 EDT
Message-ID: <1394649878.29352.21.camel@j-VirtualBox>
Subject: Re: [tip:core/locking] locking/mutexes: Unlock the mutex without
 the wait_lock
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Wed, 12 Mar 2014 11:44:38 -0700
In-Reply-To: <20140312122442.GB27965@twins.programming.kicks-ass.net>
References: <1390936396-3962-4-git-send-email-jason.low2@hp.com>
	 <tip-1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8@git.kernel.org>
	 <20140312122442.GB27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 13:24 +0100, Peter Zijlstra wrote:
> On Tue, Mar 11, 2014 at 05:41:23AM -0700, tip-bot for Jason Low wrote:
> >  kernel/locking/mutex.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> > index 82dad2c..dc3d6f2 100644
> > --- a/kernel/locking/mutex.c
> > +++ b/kernel/locking/mutex.c
> > @@ -671,10 +671,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
> >  	struct mutex *lock = container_of(lock_count, struct mutex, count);
> >  	unsigned long flags;
> >  
> > -	spin_lock_mutex(&lock->wait_lock, flags);
> > -	mutex_release(&lock->dep_map, nested, _RET_IP_);
> > -	debug_mutex_unlock(lock);
> > -

With the latest patch, perhaps it may be helpful to also add to the
comment below, mentioning that it doesn't unlock here for debug mutexes
since the following debug_mutex_unlock() would handle the unlocking
instead.

> >  	/*
> >  	 * some architectures leave the lock unlocked in the fastpath failure
> >  	 * case, others need to leave it locked. In the later case we have to
> > @@ -683,6 +679,10 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
> >  	if (__mutex_slowpath_needs_to_unlock())
> >

