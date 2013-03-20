Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3CTRjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:39:35 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:43769 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3CTRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:39:34 -0400
Date: Wed, 20 Mar 2013 10:39:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] workqueue: swap the two branches in
 pwq_adjust_max_active() to get better readability
Message-ID: <20130320173921.GE28968@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:04AM +0800, Lai Jiangshan wrote:
> "if (!freezable || !(pwq->pool->flags & POOL_FREEZING))" is hard to read.
> 
> Swap the two branches. it becomes
> "if (freezable && (pwq->pool->flags & POOL_FREEZING))", it is better.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index e1b31fc..8c882ae 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3592,14 +3592,14 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
>  
>  	spin_lock(&pwq->pool->lock);
>  
> -	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
> +	if (freezable && (pwq->pool->flags & POOL_FREEZING)) {
> +		pwq->max_active = 0;
> +	} else {
>  		pwq->max_active = wq->saved_max_active;
>  
>  		while (!list_empty(&pwq->delayed_works) &&
>  		       pwq->nr_active < pwq->max_active)
>  			pwq_activate_first_delayed(pwq);
> -	} else {
> -		pwq->max_active = 0;

Well, I have tendency to put what I think is the "main" branch above
(which also is what compiler assumes to be the hotter path too without
other input, not that it matters here), but yeah, maybe swapping them
is prettier.  Does this even matter?

Trying the patch.... hmm.... I don't know.  It looks weirder that way.
Maybe we can do the following if !A || !B bothers you?

	if (!(freezable && (pwq->pool->flags & POOL_FREEZING)))

Thanks.

-- 
tejun
