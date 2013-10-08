Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3JHItm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:49:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:18047 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab3JHIth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:49:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1056,1371106800"; 
   d="scan'208";a="371299664"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
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
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Robin Holt <robinmholt@gmail.com>, Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20131007160907.3a4aca3e7eae404767ed3a8e@linux-foundation.org>
References: <1381154053-4848-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20131007160907.3a4aca3e7eae404767ed3a8e@linux-foundation.org>
Subject: Re: [PATCHv5 00/11] split page table lock for PMD tables
Content-Transfer-Encoding: 7bit
Message-Id: <20131008084927.BC193E0090@blue.fi.intel.com>
Date: Tue,  8 Oct 2013 11:49:27 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon,  7 Oct 2013 16:54:02 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > Alex Thorlton noticed that some massively threaded workloads work poorly,
> > if THP enabled. This patchset fixes this by introducing split page table
> > lock for PMD tables. hugetlbfs is not covered yet.
> > 
> > This patchset is based on work by Naoya Horiguchi.
> 
> I think I'll summarise the results thusly:
> 
> : THP off, v3.12-rc2: 18.059261877 seconds time elapsed
> : THP off, patched:   16.768027318 seconds time elapsed
> : 
> : THP on, v3.12-rc2:  42.162306788 seconds time elapsed
> : THP on, patched:    8.397885779 seconds time elapsed
> : 
> : HUGETLB, v3.12-rc2: 47.574936948 seconds time elapsed
> : HUGETLB, patched:   19.447481153 seconds time elapsed
> 
> What sort of machines are we talking about here?  Can mortals expect to
> see such results on their hardware, or is this mainly on SGI nuttyware?

I've tested on 4 socket Westmere: 40 cores / 80 threads.

With 4 threads, I can see 8% improvement on THP.
Nothing comparing to 36 times on Alex's 512 cores, but still...

> I'm seeing very few reviewed-by's and acked-by's in here, which is a
> bit surprising and disappointing for a large patchset at v5.  Are you
> sure none were missed?

Peter looked through, but I haven't got any tags from him.

> The new code is enabled only for x86.  Why is this?

x86 is the only hardware I have to test.

> What must arch maintainers do to enable it?  Have you any particular
> suggestions, warnings etc to make their lives easier?

The last patch is a good illustration what need to be done. It's very
straight forward, I don't see any pitfalls.

> I assume the patchset won't damage bisectability?  If our bisecter has
> only the first eight patches applied, the fact that
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK cannot be enabled protects from
> failures?

Unless CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK defined, pmd_lockptr() will
return mm->page_table_lock: we can convert code to new api stet-by-step
without breaking anything.

-- 
 Kirill A. Shutemov
