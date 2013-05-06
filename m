Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3EFUqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:46:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab3EFUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 067/115] ARM: 7702/1: Set the page table freeing ceiling to TASK_SIZE
Date: Mon,  6 May 2013 13:45:03 -0700
Message-Id: <20130506203102.410919957@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 6aaa189f8712471a250bfdf8fc8d08277258b8ab upstream.

ARM processors with LPAE enabled use 3 levels of page tables, with an
entry in the top level (pgd) covering 1GB of virtual space. Because of
the branch relocation limitations on ARM, the loadable modules are
mapped 16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared
between kernel modules and user space.

If free_pgtables() is called with the default ceiling 0,
free_pgd_range() (and subsequently called functions) also frees the page
table shared between user space and kernel modules (which is normally
handled by the ARM-specific pgd_free() function). This patch changes
defines the ARM USER_PGTABLES_CEILING to TASK_SIZE when CONFIG_ARM_LPAE
is enabled.

Note that the pgd_free() function already checks the presence of the
shared pmd page allocated by pgd_alloc() and frees it, though with
ceiling 0 this wasn't necessary.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -70,6 +70,15 @@ extern void __pgd_error(const char *file
 #endif
 
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


