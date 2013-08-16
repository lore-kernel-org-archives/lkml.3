Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3HPOfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:35:23 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752314Ab3HPOed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:33 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 2/8] mm: make clear_huge_page tolerate non aligned address
Date: Fri, 16 Aug 2013 09:33:58 -0500
Message-Id: <1376663644-153546-3-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 mm/memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1ce2e2a..69a5a38 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4249,16 +4249,17 @@ void clear_huge_page(struct page *page,
 		     unsigned long addr, unsigned int pages_per_huge_page)
 {
 	int i;
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
 
 	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, addr, pages_per_huge_page);
+		clear_gigantic_page(page, haddr, pages_per_huge_page);
 		return;
 	}
 
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page; i++) {
 		cond_resched();
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		clear_user_highpage(page + i, haddr + i * PAGE_SIZE);
 	}
 }
 
-- 
1.7.12.4

