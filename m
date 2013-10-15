Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab3JOOsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:48:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:35946 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab3JOOsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,499,1378882800"; 
   d="scan'208";a="393238786"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20131015143407.GE3479@redhat.com>
References: <alpine.LNX.2.00.1310150358170.11905@eggly.anvils>
 <20131015143407.GE3479@redhat.com>
Subject: Re: mm: fix BUG in __split_huge_page_pmd
Content-Transfer-Encoding: 7bit
Message-Id: <20131015144827.C45DDE0090@blue.fi.intel.com>
Date: Tue, 15 Oct 2013 17:48:27 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> Hi Hugh,
> 
> On Tue, Oct 15, 2013 at 04:08:28AM -0700, Hugh Dickins wrote:
> > Occasionally we hit the BUG_ON(pmd_trans_huge(*pmd)) at the end of
> > __split_huge_page_pmd(): seen when doing madvise(,,MADV_DONTNEED).
> > 
> > It's invalid: we don't always have down_write of mmap_sem there:
> > a racing do_huge_pmd_wp_page() might have copied-on-write to another
> > huge page before our split_huge_page() got the anon_vma lock.
> > 
> 
> I don't get exactly the scenario with do_huge_pmd_wp_page(), could you
> elaborate?

I think the scenario is follow:

	CPU0:					CPU1

__split_huge_page_pmd()
	page = pmd_page(*pmd);
					do_huge_pmd_wp_page() copy the
					page and changes pmd (the same as on CPU0)
					to point to newly copied page.
	split_huge_page(page)
	where page is original page,
	not allocated on COW.
	pmd still points on huge page.


Hugh, have I got it correctly?

-- 
 Kirill A. Shutemov
