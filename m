Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154Ab3ECKnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:43:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46628
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763140Ab3ECKni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:43:38 -0400
Date: Fri, 3 May 2013 12:42:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: wangbiao <biao.wang@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        yanmin.zhang@intel.com, mochel@digitalimplant.org
Subject: Re: [PATCH] klist: del waiter from klist_remove_waiters before
 wakeup waitting process
Message-ID: <20130503104207.GA27558@dyad.programming.kicks-ass.net>
References: <1367564796.27529.15.camel@wangbiao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367564796.27529.15.camel@wangbiao>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 03:06:36PM +0800, wangbiao wrote:
> From: "wang, biao" <biao.wang@intel.com>
> Date: Fri, 3 May 2013 14:18:34 +0800
> Subject: [PATCH] klist: del waiter from klist_remove_waiters before wakeup
>  waitting process
> 
> There is a race between klist_remove and klist_release. klist_remove
> uses a local var waiter saved on stack. When klist_release calls
> wake_up_process(waiter->process) to wake up the waiter, waiter might run
> immediately and reuse the stack. Then, klist_release calls
> list_del(&waiter->list) to change previous
> wait data and cause prior waiter thread corrupt.
> 
> The patch fixes it against kernel 3.9.


I've never seen that code before in my life; but after a quick look you appear
to be completely right.

> Signed-off-by: wang, biao <biao.wang@intel.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  lib/klist.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/klist.c b/lib/klist.c
> index 0874e41..358a368 100644
> --- a/lib/klist.c
> +++ b/lib/klist.c
> @@ -193,10 +193,10 @@ static void klist_release(struct kref *kref)
>  		if (waiter->node != n)
>  			continue;
>  
> +		list_del(&waiter->list);
>  		waiter->woken = 1;
>  		mb();
>  		wake_up_process(waiter->process);
> -		list_del(&waiter->list);
>  	}
>  	spin_unlock(&klist_remove_lock);
>  	knode_set_klist(n, NULL);
> -- 
> 1.7.6
> 
> 
> 
