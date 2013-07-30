Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3G3S2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:28:37 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42813 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3G3S2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:28:36 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 1/8] migrate: make core migration code aware of hugepage
In-Reply-To: <1374728103-17468-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1374728103-17468-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1374728103-17468-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 30 Jul 2013 23:58:27 +0530
Message-ID: <87mwp3q4vo.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073018-4790-0000-0000-00000989E99F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Before enabling each user of page migration to support hugepage,
> this patch enables the list of pages for migration to link not only
> LRU pages, but also hugepages. As a result, putback_movable_pages()
> and migrate_pages() can handle both of LRU pages and hugepages.
>
> ChangeLog v4:
>  - make some macros return 'do {} while(0)'
>  - use more readable variable name
>
> ChangeLog v3:
>  - revert introducing migrate_movable_pages
>  - add isolate_huge_page
>
> ChangeLog v2:
>  - move code removing VM_HUGETLB from vma_migratable check into a
>    separate patch
>  - hold hugetlb_lock in putback_active_hugepage
>  - update comment near the definition of hugetlb_lock
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  include/linux/hugetlb.h |  6 ++++++
>  mm/hugetlb.c            | 32 +++++++++++++++++++++++++++++++-
>  mm/migrate.c            | 10 +++++++++-
>  3 files changed, 46 insertions(+), 2 deletions(-)
>
> diff --git v3.11-rc1.orig/include/linux/hugetlb.h v3.11-rc1/include/linux/hugetlb.h
> index c2b1801..c7a14a4 100644
> --- v3.11-rc1.orig/include/linux/hugetlb.h
> +++ v3.11-rc1/include/linux/hugetlb.h
> @@ -66,6 +66,9 @@ int hugetlb_reserve_pages(struct inode *inode, long from, long to,
>  						vm_flags_t vm_flags);
>  void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
>  int dequeue_hwpoisoned_huge_page(struct page *page);
> +bool isolate_huge_page(struct page *page, struct list_head *list);
> +void putback_active_hugepage(struct page *page);
> +void putback_active_hugepages(struct list_head *list);

are we using putback_active_hugepages in the patch series ?


>  void copy_huge_page(struct page *dst, struct page *src);
>
>  #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
> @@ -134,6 +137,9 @@ static inline int dequeue_hwpoisoned_huge_page(struct page *page)
>  	return 0;
>  }

-aneesh

