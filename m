Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3CORpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:45:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab3CORpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:45:23 -0400
Date: Fri, 15 Mar 2013 18:42:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] epoll: fix sparse error on RCU assignment
Message-ID: <20130315174240.GA1069@redhat.com>
References: <20130310113559.GA16551@dcvr.yhbt.net> <20130310182358.GA686@redhat.com> <20130314024559.GA19856@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314024559.GA19856@dcvr.yhbt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Eric Wong wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
> > On 03/10, Eric Wong wrote:
> > >
> > > This fixes the following sparse error when using
> > > CONFIG_SPARSE_RCU_POINTER=y and "make C=2 fs/eventpoll.o"
> > >
> > >   fs/eventpoll.c:514:17: error: incompatible types in comparison expression (different address spaces)
> >
> > ep_remove_wait_queue() does rcu_dereference(pwq->whead) and
> > rcu_dereference_sparse(__rcu) complains, I guess.
> >
> > > --- a/fs/eventpoll.c
> > > +++ b/fs/eventpoll.c
> > > @@ -228,7 +228,7 @@ struct eppoll_entry {
> > >  	wait_queue_t wait;
> > >
> > >  	/* The wait queue head that linked the "wait" wait queue item */
> > > -	wait_queue_head_t *whead;
> > > +	wait_queue_head_t __rcu *whead;
> >
> > Well, perhaps this change is fine... but otoh this this a bit misleading.
> > It is not actually __rcu. The special case is sighand->signalfd_wqh, and
> > the commemt in ep_remove_wait_queue() means: if ->whead is not stable then
> > we can only race with signalfd_cleanup(), and rcu_read_lock() ensures this
> > memory can't go away.
> >
> > We do not even need smp_read_barrier_depends() here, ACCESS_ONCE() should
> > be enough.
> >
> > Perhaps it would be better to simply shut up this warning somehow...
>
> Hi, I've been hoping others would give a reply and offer a better
> solution than min.

Me too ;)

OK, probably we should use your patch, although personally I'd prefer
to simply shut up the warning, say

	- whead = rcu_dereference(pwq->whead);
	+ whead = rcu_dereference((void __rcu*)pwq->whead);

> Without my proposed patch, sparse _errors_ out on me,

it is only sparse...

But OK, I won't argue with you patch.

Oleg.

