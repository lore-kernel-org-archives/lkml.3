Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab3CVCBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:01:54 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53680 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932265Ab3CVCBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:01:53 -0400
Date: Thu, 21 Mar 2013 22:01:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wfcqueue: functions for local append and enqueue
Message-ID: <20130322020150.GA17809@Krystal>
References: <20130311213602.GB9829@Krystal> <20130321114313.GA17275@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321114313.GA17275@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> With level-triggered epoll, append/enqueue operations to the
> local/locked queues increase performance by avoiding unnecessary atomic
> operations and barriers.  These are necessary to avoid performance
> regressions when looping through ep_send_events and appending many
> items to a queue.

Sounds like a good idea,

> 
> Signed-off-by: Eric Wong <normalperson@yhbt.net>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Davide Libenzi <davidel@xmailserver.org>
> ---
>   Benchmark for this coming with updated epoll patches.
> 
>  include/linux/wfcqueue.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/include/linux/wfcqueue.h b/include/linux/wfcqueue.h
> index 9464a0c..7eb2aaa 100644
> --- a/include/linux/wfcqueue.h
> +++ b/include/linux/wfcqueue.h
> @@ -205,6 +205,49 @@ static inline bool wfcq_enqueue(struct wfcq_head *head,
>  }
>  
>  /*
> + * __wfcq_append_local: append one local queue to another local queue
> + *
> + * No memory barriers are issued.  Mutual exclusion is the responsibility
> + * of the caller.
> + *
> + * Returns false if the queue was empty prior to adding the node.
> + * Returns true otherwise.
> + */
> +static inline bool __wfcq_append_local(struct wfcq_head *head,

Following the rest of the header, we could use:

___wfcq_append() for this function,

> +		struct wfcq_tail *tail,
> +		struct wfcq_node *new_head,
> +		struct wfcq_node *new_tail)
> +{
> +	struct wfcq_node *old_tail;
> +
> +	old_tail = tail->p;
> +	tail->p = new_tail;
> +	old_tail->next = new_head;
> +
> +	/*
> +	 * Return false if queue was empty prior to adding the node,
> +	 * else return true.
> +	 */
> +	return old_tail != &head->node;
> +}
> +
> +/*
> + * wfcq_enqueue_local: enqueue a node into a local wait-free queue
> + *
> + * No memory barriers are issued.  Mutual exclusion is the responsibility
> + * of the caller.
> + *
> + * Returns false if the queue was empty prior to adding the node.
> + * Returns true otherwise.
> + */
> +static inline bool wfcq_enqueue_local(struct wfcq_head *head,

and:

__wfcq_enqueue()

we should also update the "Synchronization table" at the beginning of
the file accordingly.

Thoughts ?

Thanks,

Mathieu

> +		struct wfcq_tail *tail,
> +		struct wfcq_node *new_tail)
> +{
> +	return __wfcq_append_local(head, tail, new_tail, new_tail);
> +}
> +
> +/*
>   * ___wfcq_busy_wait: busy-wait.
>   */
>  static inline void ___wfcq_busy_wait(void)
> -- 
> 1.8.2.rc3.2.g89ce8d6
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
