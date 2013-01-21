Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3AUKEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:04:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3AUKEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:04:14 -0500
Date: Mon, 21 Jan 2013 11:04:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tony Lu <zlu@tilera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: Set PTE as huge in
 hugetlb_change_protection
Message-ID: <20130121100410.GE7798@dhcp22.suse.cz>
References: <BAB94DBB0E89D8409949BC28AC95914C47B123D2@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47B123D2@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-01-13 04:13:07, Tony Lu wrote:
> From da8432aafd231e7cdcda9d15484829def4663cb0 Mon Sep 17 00:00:00 2001
> From: Zhigang Lu <zlu@tilera.com>
> Date: Mon, 21 Jan 2013 11:23:26 +0800
> Subject: [PATCH 1/1] mm/hugetlb: Set PTE as huge in hugetlb_change_protection
> 
> When setting a huge PTE, besides calling pte_mkhuge(), we also need
> to call arch_make_huge_pte(), which we indeed do in make_huge_pte(),
> but we forget to do in hugetlb_change_protection().

I guess you also need it in remove_migration_pte. This calls for a
helper which would do both pte_mkhuge() and arch_make_huge_pte.

Besides that, tile seem to be the only arch which implements this arch
hook (introduced by 621b1955 in 3.5) so this should be considered for
stable.

> 
> Signed-off-by: Zhigang Lu <zlu@tilera.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  mm/hugetlb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4f3ea0b..546db81 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3033,6 +3033,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
>                 if (!huge_pte_none(huge_ptep_get(ptep))) {
>                         pte = huge_ptep_get_and_clear(mm, address, ptep);
>                         pte = pte_mkhuge(pte_modify(pte, newprot));
> +                       pte = arch_make_huge_pte(pte, vma, NULL, 0);
>                         set_huge_pte_at(mm, address, ptep, pte);
>                         pages++;
>                 }
> -- 
> 1.7.10.3

-- 
Michal Hocko
SUSE Labs
