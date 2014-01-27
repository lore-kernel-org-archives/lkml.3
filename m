Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaA0VDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:03:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbaA0VDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:03:14 -0500
Date: Mon, 27 Jan 2014 16:02:56 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1390856576-ud1qp3fm-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1390794746-16755-4-git-send-email-davidlohr@hp.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
 <1390794746-16755-4-git-send-email-davidlohr@hp.com>
Subject: Re: [PATCH 3/8] mm, hugetlb: fix race in region tracking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1390794746-16755-4-git-send-email-davidlohr@hp.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 07:52:21PM -0800, Davidlohr Bueso wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> There is a race condition if we map a same file on different processes.
> Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> When we do mmap, we don't grab a hugetlb_instantiation_mutex, but only the,
> mmap_sem (exclusively). This doesn't prevent other tasks from modifying the
> region structure, so it can be modified by two processes concurrently.
> 
> To solve this, introduce a spinlock to resv_map and make region manipulation
> function grab it before they do actual work.
> 
> Acked-by: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> [Updated changelog]
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
...
> @@ -203,15 +200,23 @@ static long region_chg(struct resv_map *resv, long f, long t)
>  	 * Subtle, allocate a new region at the position but make it zero
>  	 * size such that we can guarantee to record the reservation. */
>  	if (&rg->link == head || t < rg->from) {
> -		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
> -		if (!nrg)
> -			return -ENOMEM;
> +		if (!nrg) {
> +			spin_unlock(&resv->lock);

I think that doing kmalloc() inside the lock is simpler.
Why do you unlock and retry here?

Thanks,
Naoya Horiguchi

> +			nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
> +			if (!nrg)
> +				return -ENOMEM;
> +
> +			goto retry;
> +		}
> +
>  		nrg->from = f;
>  		nrg->to   = f;
>  		INIT_LIST_HEAD(&nrg->link);
>  		list_add(&nrg->link, rg->link.prev);
> +		nrg = NULL;
>  
> -		return t - f;
> +		chg = t - f;
> +		goto out_locked;
>  	}
>  
>  	/* Round our left edge to the current segment if it encloses us. */
