Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaG3SU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:20:58 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:45235 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaG3SU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:20:57 -0400
Message-ID: <1406744455.14047.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -tip/master 2/7] locking/mutex: Document quick lock
 release when unlocking
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 11:20:55 -0700
In-Reply-To: <1406733032.3544.2.camel@j-VirtualBox>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-2-git-send-email-davidlohr@hp.com>
	 <1406733032.3544.2.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 08:10 -0700, Jason Low wrote:
> On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> > - * Release the lock, slowpath:
> > + * Release the lock, slowpath.
> > + *  At this point, the lock counter is 0 or negative.
> 
> Hmm, so in the !__mutex_slowpath_needs_to_unlock() case, we could enter
> this function with the lock count == 1 right?

Yes, it is possible. So that comment should actually be moved down to:

> >   */
> >  static inline void
> >  __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
> > @@ -684,9 +685,16 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
> >  	unsigned long flags;
> >  
> >  	/*
> > -	 * some architectures leave the lock unlocked in the fastpath failure
> > +	 * As a performance measurement, release the lock before doing other
> > +	 * wakeup related duties to follow. This allows other tasks to acquire
> > +	 * the lock sooner, while still handling cleanups in past unlock calls.
> > +	 * This can be done as we do not enforce strict equivalence between the
> > +	 * mutex counter and wait_list.
> > +	 *
> > +	 *
> > +	 * Some architectures leave the lock unlocked in the fastpath failure
> >  	 * case, others need to leave it locked. In the later case we have to
> > -	 * unlock it here
> > +	 * unlock it here.

... here.

