Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3LKNVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:21:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3LKNVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:21:13 -0500
Date: Wed, 11 Dec 2013 13:21:09 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: numa: Guarantee that tlb_flush_pending updates are
 visible before page table updates
Message-ID: <20131211132109.GB24125@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to documentation on barriers, stores issued before a LOCK can
complete after the lock implying that it's possible tlb_flush_pending can
be visible after a page table update. As per revised documentation, this patch
adds a smp_mb__before_spinlock to guarantee the correct ordering.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mm_types.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c122bb1..a12f2ab 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -482,7 +482,12 @@ static inline bool tlb_flush_pending(struct mm_struct *mm)
 static inline void set_tlb_flush_pending(struct mm_struct *mm)
 {
 	mm->tlb_flush_pending = true;
-	barrier();
+
+	/*
+	 * Guarantee that the tlb_flush_pending store does not leak into the
+	 * critical section updating the page tables
+	 */
+	smp_mb__before_spinlock();
 }
 /* Clearing is done after a TLB flush, which also provides a barrier. */
 static inline void clear_tlb_flush_pending(struct mm_struct *mm)
