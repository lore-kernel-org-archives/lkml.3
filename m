Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3CJSZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:25:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab3CJSZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:25:50 -0400
Date: Sun, 10 Mar 2013 19:23:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] epoll: fix sparse error on RCU assignment
Message-ID: <20130310182358.GA686@redhat.com>
References: <20130310113559.GA16551@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310113559.GA16551@dcvr.yhbt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Eric Wong wrote:
>
> This fixes the following sparse error when using
> CONFIG_SPARSE_RCU_POINTER=y and "make C=2 fs/eventpoll.o"
>
>   fs/eventpoll.c:514:17: error: incompatible types in comparison expression (different address spaces)

ep_remove_wait_queue() does rcu_dereference(pwq->whead) and
rcu_dereference_sparse(__rcu) complains, I guess.

> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -228,7 +228,7 @@ struct eppoll_entry {
>  	wait_queue_t wait;
>
>  	/* The wait queue head that linked the "wait" wait queue item */
> -	wait_queue_head_t *whead;
> +	wait_queue_head_t __rcu *whead;

Well, perhaps this change is fine... but otoh this this a bit misleading.
It is not actually __rcu. The special case is sighand->signalfd_wqh, and
the commemt in ep_remove_wait_queue() means: if ->whead is not stable then
we can only race with signalfd_cleanup(), and rcu_read_lock() ensures this
memory can't go away.

We do not even need smp_read_barrier_depends() here, ACCESS_ONCE() should
be enough.

Perhaps it would be better to simply shut up this warning somehow...

>  };
>
>  /* Wrapper struct used by poll queueing */
> @@ -929,7 +929,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>  	struct eventpoll *ep = epi->ep;
>
>  	if ((unsigned long)key & POLLFREE) {
> -		ep_pwq_from_wait(wait)->whead = NULL;
> +		RCU_INIT_POINTER(ep_pwq_from_wait(wait)->whead, NULL);
>  		/*
>  		 * whead = NULL above can race with ep_remove_wait_queue()
>  		 * which can do another remove_wait_queue() after us, so we
> @@ -1018,7 +1018,7 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
>
>  	if (epi->nwait >= 0 && (pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL))) {
>  		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
> -		pwq->whead = whead;
> +		RCU_INIT_POINTER(pwq->whead, whead);
>  		pwq->base = epi;
>  		add_wait_queue(whead, &pwq->wait);
>  		list_add_tail(&pwq->llink, &epi->pwqlist);
> -- 
> Eric Wong

