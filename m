Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab3IFKsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:48:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:4444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab3IFKsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:48:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,853,1371106800"; 
   d="scan'208";a="356769715"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1378416466-30913-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1378416466-30913-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1378416466-30913-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Subject: RE: [PATCH 2/2] thp: support split page table lock
Content-Transfer-Encoding: 7bit
Message-Id: <20130906104803.0F39CE0090@blue.fi.intel.com>
Date: Fri,  6 Sep 2013 13:48:03 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi wrote:
> Thp related code also uses per process mm->page_table_lock now.
> So making it fine-grained can provide better performance.
> 
> This patch makes thp support split page table lock by using page->ptl
> of the pages storing "pmd_trans_huge" pmds.
> 
> Some functions like pmd_trans_huge_lock() and page_check_address_pmd()
> are expected by their caller to pass back the pointer of ptl, so this
> patch adds to those functions new arguments for that. Rather than that,
> this patch gives only straightforward replacement.
> 
> ChangeLog v3:
>  - fixed argument of huge_pmd_lockptr() in copy_huge_pmd()
>  - added missing declaration of ptl in do_huge_pmd_anonymous_page()
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Generally, looks good. Few notes:

I believe you need to convert __pte_alloc() to new locking. Not sure about
__pte_alloc_kernel().
Have you check all rest mm->page_table_lock, that they shouldn't be
converted to new locking?

You use uninitialized_var() a lot. It's ugly. I've check few places
(task_mmu.c, copy_huge_pmd) and have found a reason why we need it there.
Why?

You often do

+       ptl = huge_pmd_lockptr(mm, pmd);
+       spin_lock(ptl);

Should we have a helper to combine them? huge_pmd_lock()?

-- 
 Kirill A. Shutemov
