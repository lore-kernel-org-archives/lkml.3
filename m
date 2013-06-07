Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3FGC2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:28:24 -0400
Received: from science.horizon.com ([71.41.210.146]:11540 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752224Ab3FGC2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:28:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2013 22:28:23 EDT
Date: 6 Jun 2013 22:21:42 -0400
Message-ID: <20130607022142.28037.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: peterz@infradead.org
Subject: Re: TLB and PTE coherency during munmap
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a bug in the original code, but as long as you're cleaning it up:

@@ -103,6 +97,7 @@ extern struct ia64_tr_entry *ia64_idtrs[NR_CPUS];
 static inline void
 ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+	unsigned long i;
 	unsigned int nr;
 
 	if (!tlb->need_flush)
@@ -141,13 +136,11 @@ ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long e
 
 	/* lastly, release the freed pages */
 	nr = tlb->nr;
-	if (!tlb_fast_mode(tlb)) {
-		unsigned long i;
-		tlb->nr = 0;
-		tlb->start_addr = ~0UL;
-		for (i = 0; i < nr; ++i)
-			free_page_and_swap_cache(tlb->pages[i]);
-	}
+
+	tlb->nr = 0;
+	tlb->start_addr = ~0UL;
+	for (i = 0; i < nr; ++i)
+		free_page_and_swap_cache(tlb->pages[i]);
 }


How about making that first hunk:

@@ -103,6 +97,6 @@ extern struct ia64_tr_entry *ia64_idtrs[NR_CPUS];
 static inline void
 ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
-	unsigned int nr;
+	unsigned int nr, i;
 
 	if (!tlb->need_flush)

Because i does not need to be 64 bits; tlb->nr is only 32.
