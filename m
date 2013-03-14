Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3CNEW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:22:29 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:51433 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab3CNEW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:22:28 -0400
Date: Thu, 14 Mar 2013 04:22:27 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
 Implementation
Message-ID: <20130314042227.GA15675@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311213602.GB9829@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> Ported to the Linux kernel from Userspace RCU library, at commit
> 108a92e5b97ee91b2b902dba2dd2e78aab42f420.
> 
> Ref: http://git.lttng.org/userspace-rcu.git
> 
> It is provided as a starting point only. Test cases should be ported
> from Userspace RCU to kernel space and thoroughly ran on a wide range of
> architectures before considering this port production-ready.

Thanks, this seems to work.  Will post an early epoll patch in a minute.

Minor comments below.

> +/*
> + * Load a data from shared memory.
> + */
> +#define CMM_LOAD_SHARED(p)		ACCESS_ONCE(p)

When iterating through the queue by dequeueing, I needed a way
to get the tail at the start of the iteration and use that as
a sentinel while iterating, so I access the tail like this:

	struct wfcq_node *p = CMM_LOAD_SHARED(ep->rdltail.p);

I hope this is supported... it seems to work :)

Unlike most queue users, I need to stop iteration to prevent the same
item from appearing in the events returned by epoll_wait; since a
dequeued item may appear back in the wfcqueue immediately.

> +struct wfcq_head {
> +	struct wfcq_node node;
> +	struct mutex lock;
> +};

I'm not using this lock at all since I already have ep->mtx (which also
protects the ep->rbr).  Perhaps it should not be included; normal linked
list and most data structures I see in the kernel do not provide their
own locks, either

> +static inline void wfcq_init(struct wfcq_head *head,
> +		struct wfcq_tail *tail)
> +{
> +	/* Set queue head and tail */
> +	wfcq_node_init(&head->node);
> +	tail->p = &head->node;
> +	mutex_init(&head->lock);
> +}

There's no corresponding mutex_destroy, so I'm just destroying it
myself...
