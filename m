Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaLEM2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:28:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbaLEM2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:28:08 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: introduce helper functions to do save read and write accesses
Date: Fri,  5 Dec 2014 13:28:04 +0100
Message-Id: <1417782484-31780-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce two helper functions to savely read and write unsigned long
values from or to memory without crashing the system in case of access
failures.

These helpers can be used instead of open coded uses of __get_user()
and __put_user() avoiding the need to do casts to fix sparse warnings.

Use the helpers in page.h and p2m.c. This will fix the sparse
warnings when doing "make C=1".

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/xen/page.h | 16 +++++++++++++++-
 arch/x86/xen/p2m.c              |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index f5d5de4..330352f 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -60,6 +60,20 @@ extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
 extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
 
 /*
+ * Helper functions to write or read unsigned long values to/from memory.
+ * To be used when accesses might fail.
+ */
+static inline int xen_safe_write_ulong(unsigned long *addr, unsigned long val)
+{
+	return __put_user(val, (unsigned long __user *)addr);
+}
+
+static inline int xen_safe_read_ulong(unsigned long *addr, unsigned long *val)
+{
+	return __get_user(*val, (unsigned long __user *)addr);
+}
+
+/*
  * When to use pfn_to_mfn(), __pfn_to_mfn() or get_phys_to_machine():
  * - pfn_to_mfn() returns either INVALID_P2M_ENTRY or the mfn. No indicator
  *   bits (identity or foreign) are set.
@@ -125,7 +139,7 @@ static inline unsigned long mfn_to_pfn_no_overrides(unsigned long mfn)
 	 * In such cases it doesn't matter what we return (we return garbage),
 	 * but we must handle the fault without crashing!
 	 */
-	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
+	ret = xen_safe_read_ulong(&machine_to_phys_mapping[mfn], &pfn);
 	if (ret < 0)
 		return ~0;
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8b5db51..edbc7a6 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -625,7 +625,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 		return true;
 	}
 
-	if (likely(!__put_user(mfn, xen_p2m_addr + pfn)))
+	if (likely(!xen_safe_write_ulong(xen_p2m_addr + pfn, mfn)))
 		return true;
 
 	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
-- 
2.1.2

