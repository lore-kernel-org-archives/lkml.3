Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3ERC2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3ERCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:49 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JfmCN0InqAkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xIKWC3RsU0EA:10 a=7CQSdrXTAAAA:8 a=drOt6m5kAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=3awN1vTrJB2_KaZi7AkA:9 a=ESTKKtUg-DoA:10 a=UTB_XpHje0EA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=ZBo8780zpc-Ioygr:21 a=o_l5b48T7ad5DmUE:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021645.902972501@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 026/136 ] arm: set the page table freeing ceiling to TASK_SIZE
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0026-arm-set-the-page-table-freeing-ceiling-to-TASK_SIZE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit 104ad3b32d7a71941c8ab2dee78eea38e8a23309 ]

ARM processors with LPAE enabled use 3 levels of page tables, with an
entry in the top level (pgd) covering 1GB of virtual space.  Because of
the branch relocation limitations on ARM, the loadable modules are
mapped 16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared
between kernel modules and user space.

If free_pgtables() is called with the default ceiling 0,
free_pgd_range() (and subsequently called functions) also frees the page
table shared between user space and kernel modules (which is normally
handled by the ARM-specific pgd_free() function).  This patch changes
defines the ARM USER_PGTABLES_CEILING to TASK_SIZE when CONFIG_ARM_LPAE
is enabled.

Note that the pgd_free() function already checks the presence of the
shared pmd page allocated by pgd_alloc() and frees it, though with
ceiling 0 this wasn't necessary.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 41dc31f..cc5e50f 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -61,6 +61,15 @@ extern void __pgd_error(const char *file, int line, pgd_t);
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
 /*
+ * Use TASK_SIZE as the ceiling argument for free_pgtables() and
+ * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
+ * page shared between user and kernel).
+ */
+#ifdef CONFIG_ARM_LPAE
+#define USER_PGTABLES_CEILING	TASK_SIZE
+#endif
+
+/*
  * The pgprot_* and protection_map entries will be fixed up in runtime
  * to include the cachable and bufferable bits based on memory policy,
  * as well as any architecture dependent bits like global/ASID and SMP
-- 
1.7.10.4


