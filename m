Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JCXiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:38:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:44411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3JCXiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:38:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1028,1371106800"; 
   d="scan'208";a="369521653"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20131003161109.aa568784d6fc48e61dc1d33e@linux-foundation.org>
References: <1380287787-30252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1380287787-30252-10-git-send-email-kirill.shutemov@linux.intel.com>
 <20131003161109.aa568784d6fc48e61dc1d33e@linux-foundation.org>
Subject: Re: [PATCHv4 09/10] mm: implement split page table lock for PMD level
Content-Transfer-Encoding: 7bit
Message-Id: <20131003233800.8A003E0090@blue.fi.intel.com>
Date: Fri,  4 Oct 2013 02:38:00 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Sep 2013 16:16:26 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > The basic idea is the same as with PTE level: the lock is embedded into
> > struct page of table's page.
> > 
> > We can't use mm->pmd_huge_pte to store pgtables for THP, since we don't
> > take mm->page_table_lock anymore. Let's reuse page->lru of table's page
> > for that.
> > 
> > pgtable_pmd_page_ctor() returns true, if initialization is successful
> > and false otherwise. Current implementation never fails, but assumption
> > that constructor can fail will help to port it to -rt where spinlock_t
> > is rather huge and cannot be embedded into struct page -- dynamic
> > allocation is required.
> 
> spinlock_t is rather large when lockdep is enabled.  What happens?

The same as with PTE split lock: CONFIG_SPLIT_PTLOCK_CPUS set to 999999
if DEBUG_SPINLOCK || DEBUG_LOCK_ALLOC. It effectively blocks split locks
usage if spinlock_t is too big.

-- 
 Kirill A. Shutemov
