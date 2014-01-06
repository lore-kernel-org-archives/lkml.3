Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbaAFXTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:19:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaAFWlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 074/129] mm: numa: guarantee that tlb_flush_pending updates are visible before page table updates
Date: Mon,  6 Jan 2014 14:38:23 -0800
Message-Id: <20140106223901.729801564@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mm_types.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -480,7 +480,12 @@ static inline bool mm_tlb_flush_pending(
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


