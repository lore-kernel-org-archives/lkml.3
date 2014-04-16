Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaDPTvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:51:16 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42284 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaDPTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:51:13 -0400
Date: Wed, 16 Apr 2014 15:51:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Message-ID: <20140416195109.GD22569@htj.dyndns.org>
References: <20130421012925.GA19097@mtj.dyndns.org>
 <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 25, 2014 at 05:56:04PM +0800, Lai Jiangshan wrote:
> freezing is nothing related to pools, but POOL_FREEZING adds a connection,
> and causes freeze_workqueues_begin() and thaw_workqueues() complicated.
> 
> Since freezing is workqueue instance attribute, so we introduce __WQ_FREEZING
> to wq->flags instead and remove POOL_FREEZING.
> 
> we set __WQ_FREEZING only when freezable(to simplify pwq_adjust_max_active()),
> make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.

Please wrap the description to 80 columns.

> @@ -3730,18 +3726,13 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
>  static void pwq_adjust_max_active(struct pool_workqueue *pwq)
>  {
>  	struct workqueue_struct *wq = pwq->wq;
> -	bool freezable = wq->flags & WQ_FREEZABLE;
>  
> -	/* for @wq->saved_max_active */
> +	/* for @wq->saved_max_active and @wq->flags */
>  	lockdep_assert_held(&wq->mutex);
>  
> -	/* fast exit for non-freezable wqs */
> -	if (!freezable && pwq->max_active == wq->saved_max_active)
> -		return;
> -

Why are we removing the above?  Can't we still test __WQ_FREEZING as
we're holding wq->mutex?  I don't really mind removing the
optimization but the patch description at least has to explain what's
going on.

...
>  	list_for_each_entry(wq, &workqueues, list) {
> +		if (!(wq->flags & WQ_FREEZABLE))
> +			continue;

Ah, okay, you're not calling the function at all if WQ_FREEZABLE is
not set.  I couldn't really understand what you were trying to say in
the patch description.  Can you please try to refine the description
more?  It's better to be verbose and clear than short and difficult to
understand.

Thanks.

-- 
tejun
