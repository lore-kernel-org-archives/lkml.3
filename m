Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3DBNFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:05:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34954 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760846Ab3DBNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:05:46 -0400
Date: Tue, 2 Apr 2013 09:05:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] wfcqueue: add function for unsynchronized prepend
Message-ID: <20130402130541.GC11621@Krystal>
References: <20130311213602.GB9829@Krystal> <20130329081016.GA15979@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329081016.GA15979@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> In some situations, it is necessary to prepend a node to a queue.
> For epoll, this is necessary for two rare conditions:
> 
> * when the user triggers -EFAULT
> * when reinjecting elements from the ovflist (implemented as a stack)

This approach makes sense.

In terms of API naming, I wonder if "prepend" is the good counterpart
for "enqueue". Maybe "enqueue_first" or "enqueue_head" could be better
suited ?

Currently, we have an "append" function used internally, but it's not
exposed by the API.

Just for fun, I tried making your "prepend" wait-free (thus not
requiring a mutex), but it's really not obvious, because of its impact
on splice operation and dequeue-last-node operation.

Thoughts ?

Thanks,

Mathieu

> 
> Signed-off-by: Eric Wong <normalperson@yhbt.net>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  This is on top of my other patch to implement __wfcq_enqueue
> 
>  include/linux/wfcqueue.h | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/wfcqueue.h b/include/linux/wfcqueue.h
> index a452ab9..4cb8f22 100644
> --- a/include/linux/wfcqueue.h
> +++ b/include/linux/wfcqueue.h
> @@ -56,15 +56,17 @@
>   * [5] __wfcq_first
>   * [6] __wfcq_next
>   * [7] __wfcq_enqueue
> + * [8] __wfcq_prepend
>   *
> - *     [1] [2] [3] [4] [5] [6] [7]
> - * [1]  -   -   -   -   -   -   X
> - * [2]  -   -   -   -   -   -   X
> - * [3]  -   -   X   X   X   X   X
> - * [4]  -   -   X   -   X   X   X
> - * [5]  -   -   X   X   -   -   X
> - * [6]  -   -   X   X   -   -   X
> - * [7]  X   X   X   X   X   X   X
> + *     [1] [2] [3] [4] [5] [6] [7] [8]
> + * [1]  -   -   -   -   -   -   X   X
> + * [2]  -   -   -   -   -   -   X   X
> + * [3]  -   -   X   X   X   X   X   X
> + * [4]  -   -   X   -   X   X   X   X
> + * [5]  -   -   X   X   -   -   X   X
> + * [6]  -   -   X   X   -   -   X   X
> + * [7]  X   X   X   X   X   X   X   X
> + * [8]  X   X   X   X   X   X   X   X
>   *
>   * Besides locking, mutual exclusion of dequeue, splice and iteration
>   * can be ensured by performing all of those operations from a single
> @@ -441,6 +443,23 @@ static inline enum wfcq_ret __wfcq_splice(
>  }
>  
>  /*
> + * __wfcq_prepend: prepend a node into a queue, requiring mutual exclusion.
> + *
> + * No memory barriers are issued.  Mutual exclusion is the responsibility
> + * of the caller.
> + */
> +static inline void __wfcq_prepend(struct wfcq_head *head,
> +				struct wfcq_tail *tail, struct wfcq_node *node)
> +{
> +	node->next = head->node.next;
> +	head->node.next = node;
> +
> +	/* if the queue was empty before, it is no longer empty now */
> +	if (tail->p == &head->node)
> +		tail->p = node;
> +}
> +
> +/*
>   * __wfcq_for_each: Iterate over all nodes in a queue,
>   * without dequeuing them.
>   * @head: head of the queue (struct wfcq_head pointer).
> -- 
> Eric Wong
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
