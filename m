Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3IIPnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:43:52 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33889 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab3IIPnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:43:49 -0400
Date: Mon, 9 Sep 2013 10:43:57 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH 2/2] thp: support split page table lock
Message-ID: <20130909154357.GC12435@sgi.com>
References: <522D33C5.9050707@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522D33C5.9050707@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:34:45AM +0800, Daniel J Blueman wrote:
> On Saturday, 7 September 2013 02:10:02 UTC+8, Naoya Horiguchi  wrote:
> >Hi Alex,
> >
> >On Fri, Sep 06, 2013 at 11:04:23AM -0500, Alex Thorlton wrote:
> >> On Thu, Sep 05, 2013 at 05:27:46PM -0400, Naoya Horiguchi wrote:
> >> > Thp related code also uses per process mm->page_table_lock now.
> >> > So making it fine-grained can provide better performance.
> >> >
> >> > This patch makes thp support split page table lock by using page->ptl
> >> > of the pages storing "pmd_trans_huge" pmds.
> >> >
> >> > Some functions like pmd_trans_huge_lock() and
> page_check_address_pmd()
> >> > are expected by their caller to pass back the pointer of ptl, so this
> >> > patch adds to those functions new arguments for that. Rather than
> that,
> >> > this patch gives only straightforward replacement.
> >> >
> >> > ChangeLog v3:
> >> >  - fixed argument of huge_pmd_lockptr() in copy_huge_pmd()
> >> >  - added missing declaration of ptl in do_huge_pmd_anonymous_page()
> >>
> >> I've applied these and tested them using the same tests program that I
> >> used when I was working on the same issue, and I'm running into some
> >> bugs.  Here's a stack trace:
> >
> >Thank you for helping testing. This bug is new to me.
> 
> With 3.11, this patch series and CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS,
> I consistently hit the same failure when exiting one of my
> stress-testers [1] when using eg 24 cores.
> 
> Doesn't happen with 8 cores, so likely needs enough virtual memory
> to use multiple split locks. Otherwise, this is very promising work!

Daniel,

Hillf Danton (dhillf@gmail.com) suggested putting the big
page_table_lock back into the two functions seen below.  I re-tested
with this change and it seems to resolve the issue.  

- Alex

--- a/mm/pgtable-generic.c      Sat Sep  7 15:17:52 2013
+++ b/mm/pgtable-generic.c      Sat Sep  7 15:20:28 2013
@@ -127,12 +127,14 @@ void pmdp_splitting_flush(struct vm_area
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
                                pgtable_t pgtable)
 {
+       spin_lock(&mm->page_table_lock);
        /* FIFO */
        if (!mm->pmd_huge_pte)
                INIT_LIST_HEAD(&pgtable->lru);
        else
                list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
        mm->pmd_huge_pte = pgtable;
+       spin_unlock(&mm->page_table_lock);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
@@ -144,6 +146,7 @@ pgtable_t pgtable_trans_huge_withdraw(st
 {
        pgtable_t pgtable;

+       spin_lock(&mm->page_table_lock);
        /* FIFO */
        pgtable = mm->pmd_huge_pte;
        if (list_empty(&pgtable->lru))
@@ -153,6 +156,7 @@ pgtable_t pgtable_trans_huge_withdraw(st
                                              struct page, lru);
                list_del(&pgtable->lru);
        }
+       spin_unlock(&mm->page_table_lock);
        return pgtable;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
--
