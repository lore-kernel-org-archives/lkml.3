Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaBVOkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:40:16 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:43019 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaBVOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:40:13 -0500
Date: Sat, 22 Feb 2014 09:40:10 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Guarantee work function memory ordering
Message-ID: <20140222144010.GE12830@htj.dyndns.org>
References: <1393071111-5128-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393071111-5128-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 07:11:51AM -0500, Peter Hurley wrote:
> Users of the workqueue api may assume the workqueue provides a
> memory ordering guarantee for re-queued work items; ie., that
> if a work item is not queue-able then the previously queued
> work instance is not running and so any memory operations
> which occur before queuing the work will be visible to the work
> function.
> 
> For example, code of the form:
>     add new data to work on
>     queue work
> assumes that this latest data is acted upon, either by the
> newly queued instance (if it could be queued) or by the not-yet-
> running instance (if a new instance could not be queued).
> 
> Provide this implicit memory ordering guarantee; prevent
> speculative loads in the work function from occurring before
> the current work instance is marked not pending (and thus has
> started). This, in turn, guarantees that stores occurring before
> schedule_work/queue_work are visible to either the not-yet-running
> work instance (if new work could not be queued) or that new work
> is queued (and thus ensuring the new data is acted upon).
> 
> Note that preventing early stores is unnecessary because no
> conclusion can be reached about the state of the work function
> from outside the work function by ordering early stores after
> clearing PENDING (other than testing PENDING).
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  kernel/workqueue.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 82ef9f3..a4b241d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2201,6 +2201,16 @@ __acquires(&pool->lock)
>  
>  	spin_unlock_irq(&pool->lock);
>  
> +	/*
> +	 * Paired with the implied mb of test_and_set_bit(PENDING).
> +	 * Guarantees speculative loads which occur in the work item
> +	 * function do not complete before PENDING is cleared in
> +	 * set_work_pool_and_clear_pending() above. In turn, this
> +	 * ensures that stores are either visible to the not-yet-
> +	 * running work instance or a new instance is queueable.
> +	 */
> +	smp_rmb();

Wouldn't it make more sense to have the above right after
clear_pending?

Thanks.

-- 
tejun
