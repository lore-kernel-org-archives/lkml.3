Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab3IMNqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:46:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49950 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700Ab3IMNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:19:50 -0400
Date: Fri, 13 Sep 2013 15:19:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 3/9] mm: introduce api for split page table lock for PMD
 level
Message-ID: <20130913131907.GC21832@twins.programming.kicks-ass.net>
References: <20130910074748.GA2971@gmail.com>
 <1379077576-2472-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1379077576-2472-4-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379077576-2472-4-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 04:06:10PM +0300, Kirill A. Shutemov wrote:
> Basic api, backed by mm->page_table_lock for now. Actual implementation
> will be added later.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/mm.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6cf8ddb..d4361e7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1294,6 +1294,19 @@ static inline void pgtable_page_dtor(struct page *page)
>  	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
>  		NULL: pte_offset_kernel(pmd, address))
>  
> +static inline spinlock_t *huge_pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
> +{
> +	return &mm->page_table_lock;
> +}
> +
> +
> +static inline spinlock_t *huge_pmd_lock(struct mm_struct *mm, pmd_t *pmd)
> +{
> +	spinlock_t *ptl = huge_pmd_lockptr(mm, pmd);
> +	spin_lock(ptl);
> +	return ptl;
> +}

Why not call the thing pmd_lock()? The pmd bit differentiates it from
pte_lock() enough IMIO.
