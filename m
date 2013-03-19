Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab3CSVMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:12:39 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37785 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab3CSVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:12:37 -0400
Date: Tue, 19 Mar 2013 14:12:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the workqueues tree with Linus' tree
Message-ID: <20130319211233.GN3042@htj.dyndns.org>
References: <20130319131938.73dd0f1233c8aba41742aded@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319131938.73dd0f1233c8aba41742aded@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Stephen.

On Tue, Mar 19, 2013 at 01:19:38PM +1100, Stephen Rothwell wrote:
> @@@ -456,40 -462,30 +462,30 @@@ static int worker_pool_assign_id(struc
>   {
>   	int ret;
>   
> - 	mutex_lock(&worker_pool_idr_mutex);
> - 	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
> - 	if (ret >= 0)
> - 		pool->id = ret;
> - 	mutex_unlock(&worker_pool_idr_mutex);
> + 	lockdep_assert_held(&wq_mutex);
> + 
> + 	do {
>  -		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
>  -			return -ENOMEM;
>  -		ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
> ++		ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
> ++		if (ret >= 0)
> ++			pool->id = ret;
> + 	} while (ret == -EAGAIN);
>   
>  -	return ret;
>  +	return ret < 0 ? ret : 0;

We don't need the loop anymore, so it should look like

  static int worker_pool_assign_id(struct worker_pool *pool)
  {
	  int ret;

	  lockdep_assert_held(&wq_mutex);

	  ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
	  if (ret >= 0) {
		  pool->id = ret;
		  return 0;
	  }
	  return ret;
  }

Anyways, I pulled master into wq/for-next and resolved it there, so it
shouldn't cause you any more trouble.

Thanks!

-- 
tejun
