Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab3DFVNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 17:13:12 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41126 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932713Ab3DFVNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 17:13:11 -0400
Date: Sat, 6 Apr 2013 17:13:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Message-ID: <20130406211307.GA32683@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcc: 
Subject: Re: [PATCH] wfcqueue: add function for unsynchronized prepend
Reply-To: 
In-Reply-To: <20130329081016.GA15979@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com

* Eric Wong (normalperson@yhbt.net) wrote:
> In some situations, it is necessary to prepend a node to a queue.
> For epoll, this is necessary for two rare conditions:
> 
> * when the user triggers -EFAULT
> * when reinjecting elements from the ovflist (implemented as a stack)
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

I don't think this table is accurate, and there is likely an issue with
the implementation below.

AFAIU, you plan to use wait-free enqueue (to tail) concurrently with
enqueue to head (prepend). Therefore, the table above should reflect
this.

I'll look into this and try to come up with a correct implementation.

Thanks,

Mathieu

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
