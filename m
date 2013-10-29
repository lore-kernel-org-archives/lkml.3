Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3J2KnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:43:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43644 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3J2KnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:43:10 -0400
Date: Tue, 29 Oct 2013 03:42:23 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-1dd49bfa3465756b3ce72214b58a33e4afb67aa3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        stable@kernel.org, aarcange@redhat.com, srikar@linux.vnet.ibm.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, stable@kernel.org, aarcange@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1381141781-10992-5-git-send-email-mgorman@suse.de>
References: <1381141781-10992-5-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mm: numa:
  Do not account for a hinting fault if we raced
Git-Commit-ID: 1dd49bfa3465756b3ce72214b58a33e4afb67aa3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 03:42:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dd49bfa3465756b3ce72214b58a33e4afb67aa3
Gitweb:     http://git.kernel.org/tip/1dd49bfa3465756b3ce72214b58a33e4afb67aa3
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 11:37:05 +0100

mm: numa: Do not account for a hinting fault if we raced

If another task handled a hinting fault in parallel then do not double
account for it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-5-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 610e3df..33ee637 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1325,8 +1325,11 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 check_same:
 	spin_lock(&mm->page_table_lock);
-	if (unlikely(!pmd_same(pmd, *pmdp)))
+	if (unlikely(!pmd_same(pmd, *pmdp))) {
+		/* Someone else took our fault */
+		current_nid = -1;
 		goto out_unlock;
+	}
 clear_pmdnuma:
 	pmd = pmd_mknonnuma(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
