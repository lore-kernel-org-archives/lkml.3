Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaAMQEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:04:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaAMQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 154/208] mm: numa: guarantee that tlb_flush_pending updates are visible before page table updates
Date: Mon, 13 Jan 2014 15:59:55 +0000
Message-Id: <1389628849-1614-155-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit af2c1401e6f9177483be4fad876d0073669df9df upstream.

According to documentation on barriers, stores issued before a LOCK can
complete after the lock implying that it's possible tlb_flush_pending
can be visible after a page table update.  As per revised documentation,
this patch adds a smp_mb__before_spinlock to guarantee the correct
ordering.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/mm_types.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ef9dc52..e8d77fb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -477,7 +477,12 @@ static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
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
-- 
1.8.3.2

