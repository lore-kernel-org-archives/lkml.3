Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3CZPWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab3CZPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 029/150] s390/mm: fix flush_tlb_kernel_range()
Date: Tue, 26 Mar 2013 15:18:48 +0000
Message-Id: <1364311249-14454-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/include/asm/tlbflush.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
index 9fde315..6f709bd 100644
--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -74,8 +74,6 @@ static inline void __tlb_flush_idte(unsigned long asce)
 
 static inline void __tlb_flush_mm(struct mm_struct * mm)
 {
-	if (unlikely(cpumask_empty(mm_cpumask(mm))))
-		return;
 	/*
 	 * If the machine has IDTE we prefer to do a per mm flush
 	 * on all cpus instead of doing a local flush if the mm
-- 
1.8.1.2

