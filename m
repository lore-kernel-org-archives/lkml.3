Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3C1TeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:34:16 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:51780 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab3C1TeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:34:13 -0400
Date: Thu, 28 Mar 2013 19:34:12 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] epoll: fix sparse error on RCU assignment
Message-ID: <20130328193412.GA10116@dcvr.yhbt.net>
References: <20130310113559.GA16551@dcvr.yhbt.net>
 <20130310182358.GA686@redhat.com>
 <20130314024559.GA19856@dcvr.yhbt.net>
 <20130315174240.GA1069@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130315174240.GA1069@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/14, Eric Wong wrote:
> > Oleg Nesterov <oleg@redhat.com> wrote:
> > > On 03/10, Eric Wong wrote:
> > > >
> > > > This fixes the following sparse error when using
> > > > CONFIG_SPARSE_RCU_POINTER=y and "make C=2 fs/eventpoll.o"
> > > >
> > > >   fs/eventpoll.c:514:17: error: incompatible types in comparison expression (different address spaces)
> > >
> > > ep_remove_wait_queue() does rcu_dereference(pwq->whead) and
> > > rcu_dereference_sparse(__rcu) complains, I guess.
> > >
> > > > --- a/fs/eventpoll.c
> > > > +++ b/fs/eventpoll.c
> > > > @@ -228,7 +228,7 @@ struct eppoll_entry {
> > > >  	wait_queue_t wait;
> > > >
> > > >  	/* The wait queue head that linked the "wait" wait queue item */
> > > > -	wait_queue_head_t *whead;
> > > > +	wait_queue_head_t __rcu *whead;
> > >
> > > Well, perhaps this change is fine... but otoh this this a bit misleading.
> > > It is not actually __rcu. The special case is sighand->signalfd_wqh, and
> > > the commemt in ep_remove_wait_queue() means: if ->whead is not stable then
> > > we can only race with signalfd_cleanup(), and rcu_read_lock() ensures this
> > > memory can't go away.
> > >
> > > We do not even need smp_read_barrier_depends() here, ACCESS_ONCE() should
> > > be enough.
> > >
> > > Perhaps it would be better to simply shut up this warning somehow...
> >
> > Hi, I've been hoping others would give a reply and offer a better
> > solution than min.
> 
> Me too ;)
> 
> OK, probably we should use your patch, although personally I'd prefer
> to simply shut up the warning, say
> 
> 	- whead = rcu_dereference(pwq->whead);
> 	+ whead = rcu_dereference((void __rcu*)pwq->whead);

I just tried the above and it does not build:

$ make C=2 fs/eventpoll.o
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   scripts/mod/empty.c
  CHECK   fs/eventpoll.c
fs/eventpoll.c:516:17: error: not addressable
  CC      fs/eventpoll.o
fs/eventpoll.c: In function ‘ep_remove_wait_queue’:
fs/eventpoll.c:516: error: lvalue required as unary ‘&’ operand
make[1]: *** [fs/eventpoll.o] Error 1
make: *** [fs/eventpoll.o] Error 2

> > Without my proposed patch, sparse _errors_ out on me,
> 
> it is only sparse...
> 
> But OK, I won't argue with you patch.

Thanks.  I think my patch is the best way to address the issue and help
prevent myself from introducing new bugs while working on epoll.

I will continue to wait for comments from others.
