Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaHLPn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:43:57 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34690 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaHLPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:43:56 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked
In-Reply-To: <1407849830-22500-1-git-send-email-mhocko@suse.cz>
References: <1407849830-22500-1-git-send-email-mhocko@suse.cz>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Tue, 12 Aug 2014 21:13:39 +0530
Message-ID: <87r40l67dg.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081215-3864-0000-0000-0000008E4B23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> spin_lock may be an empty struct for !SMP configurations and so
> arch_spin_is_locked may return unconditional 0 and trigger the VM_BUG_ON
> even when the lock is held.
>
> Replace spin_is_locked by lockdep_assert_held. We will not BUG anymore
> but it is questionable whether crashing makes a lot of sense in the
> uncharge path. Uncharge happens after the last page reference was
> released so nobody should touch the page and the function doesn't update
> any shared state except for res counter which uses synchronization of
> its own.

We do update the hugepage's hugetlb cgroup details. But as you mentioned,
this should not be an issue because we are in hugepage free.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/hugetlb_cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 9aae6f47433f..9edf189a5ef3 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -217,7 +217,7 @@ void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>
>  	if (hugetlb_cgroup_disabled())
>  		return;
> -	VM_BUG_ON(!spin_is_locked(&hugetlb_lock));
> +	lockdep_assert_held(&hugetlb_lock);
>  	h_cg = hugetlb_cgroup_from_page(page);
>  	if (unlikely(!h_cg))
>  		return;
> -- 
> 2.1.0.rc1

