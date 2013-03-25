Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3CYBjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:39:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33762 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017Ab3CYBPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:00 -0400
Message-Id: <20130325010526.341185526@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:44 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 020/104] s390/mm: fix flush_tlb_kernel_range()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit f6a70a07079518280022286a1dceb797d12e1edf upstream.

Our flush_tlb_kernel_range() implementation calls __tlb_flush_mm() with
&init_mm as argument. __tlb_flush_mm() however will only flush tlbs
for the passed in mm if its mm_cpumask is not empty.

For the init_mm however its mm_cpumask has never any bits set. Which in
turn means that our flush_tlb_kernel_range() implementation doesn't
work at all.

This can be easily verified with a vmalloc/vfree loop which allocates
a page, writes to it and then frees the page again. A crash will follow
almost instantly.

To fix this remove the cpumask_empty() check in __tlb_flush_mm() since
there shouldn't be too many mms with a zero mm_cpumask, besides the
init_mm of course.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/tlbflush.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -74,8 +74,6 @@ static inline void __tlb_flush_idte(unsi
 
 static inline void __tlb_flush_mm(struct mm_struct * mm)
 {
-	if (unlikely(cpumask_empty(mm_cpumask(mm))))
-		return;
 	/*
 	 * If the machine has IDTE we prefer to do a per mm flush
 	 * on all cpus instead of doing a local flush if the mm


