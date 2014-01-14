Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaANPpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:45:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANPpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:45:02 -0500
Date: Tue, 14 Jan 2014 15:44:57 +0000
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140114154457.GD4963@suse.de>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
 <20140110202310.GB1421@node.dhcp.inet.fi>
 <20140110220155.GD3066@sgi.com>
 <20140110221010.GP31570@twins.programming.kicks-ass.net>
 <20140110223909.GA8666@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140110223909.GA8666@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:39:09PM -0600, Alex Thorlton wrote:
> On Fri, Jan 10, 2014 at 11:10:10PM +0100, Peter Zijlstra wrote:
> > We already have the information to determine if a page is shared across
> > nodes, Mel even had some prototype code to do splits under those
> > conditions.
> 
> I'm aware that we can determine if pages are shared across nodes, but I
> thought that Mel's code to split pages under these conditions had some
> performance issues.  I know I've seen the code that Mel wrote to do
> this, but I can't seem to dig it up right now.  Could you point me to
> it?
> 

It was a lot of revisions ago! The git branches no longer exist but the
diff from the monolithic patches is below. The baseline was v3.10 and
this will no longer apply but you'll see the two places where I added a
split_huge_page and prevented khugepaged collapsing them again. At the
time, the performance with it applied was much worse but it was a 10
minute patch as a distraction. There was a range of basic problems that
had to be tackled before there was any point looking at splitting THP due
to locality. I did not pursue it further and have not revisited it since.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c8b25a8..2b80abe 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1317,6 +1317,23 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	last_nidpid = page_nidpid_last(page);
 	target_nid = mpol_misplaced(page, vma, haddr);
 	if (target_nid == -1) {
+		int last_pid = nidpid_to_pid(last_nidpid);
+
+		/*
+		 * If the fault failed to pass the two-stage filter but is on
+		 * a remote node then it could be due to false sharing of the
+		 * THP page. Remote accesses are more expensive than base
+		 * page TLB accesses so split the huge page and return to
+		 * retry the fault.
+		 */
+		if (!nidpid_nid_unset(last_nidpid) &&
+		    src_nid != page_to_nid(page) &&
+		    last_pid != (current->pid & LAST__PID_MASK)) {
+			spin_unlock(&mm->page_table_lock);
+			split_huge_page(page);
+			put_page(page);
+			return 0;
+		}
 		put_page(page);
 		goto clear_pmdnuma;
 	}
@@ -2398,6 +2415,7 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE;
+	int hint_node = NUMA_NO_NODE;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -2427,8 +2445,20 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 		 * be more sophisticated and look at more pages,
 		 * but isn't for now.
 		 */
-		if (node == NUMA_NO_NODE)
+		if (node == NUMA_NO_NODE) {
+			int nidpid = page_nidpid_last(page);
 			node = page_to_nid(page);
+			hint_node = nidpid_to_nid(nidpid);
+		}
+
+		/*
+		 * If the range is receiving hinting faults from CPUs on
+		 * different nodes then prioritise locality over TLB
+		 * misses
+		 */
+		if (nidpid_to_nid(page_nidpid_last(page)) != hint_node)
+			goto out_unmap;
+
 		VM_BUG_ON(PageCompound(page));
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
 			goto out_unmap;

-- 
Mel Gorman
SUSE Labs
