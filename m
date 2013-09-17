Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab3IQIFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:05:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3IQIFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:05:15 -0400
Date: Tue, 17 Sep 2013 09:05:02 +0100
From: Mel Gorman <mgorman@suse.de>
To: ?????? <ZhangTianFei@leadcoretech.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ????: [PATCH 34/50] sched: numa: Do not trap hinting faults for
 shared libraries
Message-ID: <20130917080502.GH22421@suse.de>
References: <1378805550-29949-35-git-send-email-mgorman@suse.de>
 <E81554BCB8813E49A8916AACC0503A851844C937@lc-shmail3.SHANGHAI.LEADCORETECH.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <E81554BCB8813E49A8916AACC0503A851844C937@lc-shmail3.SHANGHAI.LEADCORETECH.COM>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:02:22AM +0800, ?????? wrote:
> index fd724bc..5d244d0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1227,6 +1227,16 @@ void task_numa_work(struct callback_head *work)
>  		if (!vma_migratable(vma))
>  			continue;
>  
> +		/*
> +		 * Shared library pages mapped by multiple processes are not
> +		 * migrated as it is expected they are cache replicated. Avoid
> +		 * hinting faults in read-only file-backed mappings or the vdso
> +		 * as migrating the pages will be of marginal benefit.
> +		 */
> +		if (!vma->vm_mm ||
> +		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ)))
> +			continue;
> +
>  
> =?? May I ask a question, we should consider some VMAs canot be scaned for BalanceNuma?
> (VM_DONTEXPAND | VM_RESERVED | VM_INSERTPAGE |
> 				  VM_NONLINEAR | VM_MIXEDMAP | VM_SAO));

vma_migratable check covers most of the other VMAs we do not care
about.  I do not see the point of checking for some of the VMA flags you
mention. Please state which of the additional flags that you think should
be checked and why.

-- 
Mel Gorman
SUSE Labs
