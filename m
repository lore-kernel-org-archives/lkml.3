Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab3CRVvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:51:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3CRVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 46/75] s390/mm: fix flush_tlb_kernel_range()
Date: Mon, 18 Mar 2013 14:07:09 -0700
Message-Id: <20130318210513.564595317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


