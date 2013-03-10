Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3CJMqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:46:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65528 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3CJMqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:46:37 -0400
Date: Sun, 10 Mar 2013 05:46:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 14/31] workqueue: replace POOL_MANAGING_WORKERS flag with
 worker_pool->manager_mutex
Message-ID: <20130310124632.GF24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-15-git-send-email-tj@kernel.org>
 <513C5BE2.8090409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513C5BE2.8090409@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Mar 10, 2013 at 06:09:38PM +0800, Lai Jiangshan wrote:
> > -	if (pool->flags & POOL_MANAGING_WORKERS)
> > +	if (!mutex_trylock(&pool->manager_mutex))
> >  		return ret;
> >  
> > -	pool->flags |= POOL_MANAGING_WORKERS;
> 
> 
> if mutex_trylock(&pool->manager_mutex) fails, it does not mean
> the pool is managing workers. (although current code does).
> so I recommend to keep POOL_MANAGING_WORKERS.

So, that's the intention.  It's gonna be used during pool destruction
and we want all the workers to think that the pool is being managed
and it's safe to proceed.

> I suggest that you reuse assoc_mutex for your purpose(later patches).
> (and rename assoc_mutex back to manager_mutex)

They are different.  assoc_mutex makes the workers wait for the
managership, which shouldn't happen during pool destruction.  We want
the workers to assume that the pool is managed which is what
manager_mutex achieves.

Thanks.

-- 
tejun
