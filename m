Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3FCNTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:19:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab3FCNTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:19:36 -0400
Date: Mon, 3 Jun 2013 15:19:32 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlbfs: support split page table lock
Message-ID: <20130603131932.GA18588@dhcp22.suse.cz>
References: <1369770771-8447-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1369770771-8447-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369770771-8447-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-05-13 15:52:50, Naoya Horiguchi wrote:
> Currently all of page table handling by hugetlbfs code are done under
> mm->page_table_lock. This is not optimal because there can be lock
> contentions between unrelated components using this lock.

While I agree with such a change in general I am a bit afraid of all
subtle tweaks in the mm code that make hugetlb special. Maybe there are
none for page_table_lock but I am not 100% sure. So this might be
really tricky and it is not necessary for your further patches, is it?

How have you tested this?

> This patch makes hugepage support split page table lock so that
> we use page->ptl of the leaf node of page table tree which is pte for
> normal pages but can be pmd and/or pud for hugepages of some architectures.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  arch/x86/mm/hugetlbpage.c |  6 ++--
>  include/linux/hugetlb.h   | 18 ++++++++++
>  mm/hugetlb.c              | 84 ++++++++++++++++++++++++++++-------------------

This doesn't seem to be the complete story. At least not from the
trivial:
$ find arch/ -name "*hugetlb*" | xargs git grep "page_table_lock" -- 
arch/powerpc/mm/hugetlbpage.c:  spin_lock(&mm->page_table_lock);
arch/powerpc/mm/hugetlbpage.c:  spin_unlock(&mm->page_table_lock);
arch/tile/mm/hugetlbpage.c:             spin_lock(&mm->page_table_lock);
arch/tile/mm/hugetlbpage.c:
spin_unlock(&mm->page_table_lock);
arch/x86/mm/hugetlbpage.c: * called with vma->vm_mm->page_table_lock held.

-- 
Michal Hocko
SUSE Labs
