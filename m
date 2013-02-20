Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab3BTRQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:16:52 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65309 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3BTRQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:16:50 -0500
Date: Wed, 20 Feb 2013 09:16:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] events: always do slow path when trying to find a pmu
Message-ID: <20130220171645.GB3570@htj.dyndns.org>
References: <1361380176-15081-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361380176-15081-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 07:09:36PM +0200, Andy Shevchenko wrote:
> The guilty commit is cc5b5f6 "events: convert to idr_alloc()" together with
> f49318a "idr: implement lookup hint". In our case the idr_alloc is never called, but idr_find is. The hint field is never initialized and could not be dereferenced.

Ah, right, ->hint is uninitialized at the beginning.

> The proposed fix uses the idr_slowpath call which reflects old behaviour.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  kernel/events/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 624e53f..20421ea 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6076,7 +6076,7 @@ struct pmu *perf_init_event(struct perf_event *event)
>  	idx = srcu_read_lock(&pmus_srcu);
>  
>  	rcu_read_lock();
> -	pmu = idr_find(&pmu_idr, event->attr.type);
> +	pmu = idr_find_slowpath(&pmu_idr, event->attr.type);

But I don't think this is the right thing to do.  I'm working on
proper fix for idr_find().  Will post soon.

Thanks!

-- 
tejun
