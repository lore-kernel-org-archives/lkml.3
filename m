Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3AVNuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:50:20 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44260 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3AVNuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:50:18 -0500
MIME-Version: 1.0
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47B12789@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C47B123D2@USMAExch1.tad.internal.tilera.com>
	<20130121100410.GE7798@dhcp22.suse.cz>
	<BAB94DBB0E89D8409949BC28AC95914C47B12789@USMAExch1.tad.internal.tilera.com>
Date: Tue, 22 Jan 2013 21:50:16 +0800
Message-ID: <CAJd=RBD-C5dUJL-S8aRk-yQ2-7+GUdQRGJuyxsnymG8k9P8ppw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: Set PTE as huge in hugetlb_change_protection
From: Hillf Danton <dhillf@gmail.com>
To: Tony Lu <zlu@tilera.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:37 AM, Tony Lu <zlu@tilera.com> wrote:
> From 44045d672aa72eb2e76be89f95ab720952b4b09c Mon Sep 17 00:00:00 2001
> From: Zhigang Lu <zlu@tilera.com>
> Date: Tue, 22 Jan 2013 09:58:58 +0800
> Subject: [PATCH 1/1] mm/hugetlb: Set PTE as huge in hugetlb_change_protection
>  and remove_migration_pte
>
> When setting a huge PTE, besides calling pte_mkhuge(), we also need
> to call arch_make_huge_pte(), which we indeed do in make_huge_pte(),
> but we forget to do in hugetlb_change_protection() and
> remove_migration_pte().
>
> Signed-off-by: Zhigang Lu <zlu@tilera.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>


>  mm/hugetlb.c |    1 +
>  mm/migrate.c |    4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
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
> diff --git a/mm/migrate.c b/mm/migrate.c
> index c387786..2fd8b4a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -160,8 +160,10 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
>         if (is_write_migration_entry(entry))
>                 pte = pte_mkwrite(pte);
>  #ifdef CONFIG_HUGETLB_PAGE
> -       if (PageHuge(new))
> +       if (PageHuge(new)) {
>                 pte = pte_mkhuge(pte);
> +               pte = arch_make_huge_pte(pte, vma, new, 0);
> +       }
>  #endif
>         flush_cache_page(vma, addr, pte_pfn(pte));
>         set_pte_at(mm, addr, ptep, pte);
> --
> 1.7.10.3
