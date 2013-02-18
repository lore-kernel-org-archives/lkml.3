Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3BRQSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:18:47 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54948 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754248Ab3BRQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:18:45 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 2/2] arm: Set the page table freeing ceiling to TASK_SIZE
Date: Mon, 18 Feb 2013 16:18:31 +0000
Message-Id: <1361204311-14127-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1361204311-14127-1-git-send-email-catalin.marinas@arm.com>
References: <1361204311-14127-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM processors with LPAE enabled use 3 levels of page tables, with an
entry in the top level (pgd) covering 1GB of virtual space. Because of
the branch relocation limitations on ARM, the loadable modules are
mapped 16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared
between kernel modules and user space.

If free_pgtables() is called with the default ceiling 0,
free_pgd_range() (and subsequently called functions) also frees the page
table shared between user space and kernel modules (which is normally
handled by the ARM-specific pgd_free() function). This patch changes
defines the ARM USER_PGTABLES_CEILING to TASK_SIZE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/include/asm/pgtable.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index c094749..8f06ee5 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -61,6 +61,13 @@ extern void __pgd_error(const char *file, int line, pgd_t);
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
 /*
+ * Use TASK_SIZE as the ceiling argument for free_pgtables() and
+ * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
+ * page shared between user and kernel).
+ */
+#define USER_PGTABLES_CEILING	TASK_SIZE
+
+/*
  * The pgprot_* and protection_map entries will be fixed up in runtime
  * to include the cachable and bufferable bits based on memory policy,
  * as well as any architecture dependent bits like global/ASID and SMP
