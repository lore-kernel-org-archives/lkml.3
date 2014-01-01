Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaAAEks (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:40:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19634 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 05/18] xen/mmu/p2m: Refactor the xen_pagetable_init code.
Date: Tue, 31 Dec 2013 23:35:32 -0500
Message-Id: <1388550945-25499-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The revector and copying of the P2M only happens when
!auto-xlat and on 64-bit builds. It is not obvious from
the code, so lets have seperate 32 and 64-bit functions.

We also invert the check for auto-xlat to make the code
flow simpler.

Suggested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 73 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ce563be..d792a69 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1198,44 +1198,40 @@ static void __init xen_cleanhighmap(unsigned long vaddr,
 	 * instead of somewhere later and be confusing. */
 	xen_mc_flush();
 }
-#endif
-static void __init xen_pagetable_init(void)
+static void __init xen_pagetable_p2m_copy(void)
 {
-#ifdef CONFIG_X86_64
 	unsigned long size;
 	unsigned long addr;
-#endif
-	paging_init();
-	xen_setup_shared_info();
-#ifdef CONFIG_X86_64
-	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		unsigned long new_mfn_list;
+	unsigned long new_mfn_list;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
+	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
+
+	/* On 32-bit, we get zero so this never gets executed. */
+	new_mfn_list = xen_revector_p2m_tree();
+	if (new_mfn_list && new_mfn_list != xen_start_info->mfn_list) {
+		/* using __ka address and sticking INVALID_P2M_ENTRY! */
+		memset((void *)xen_start_info->mfn_list, 0xff, size);
+
+		/* We should be in __ka space. */
+		BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
+		addr = xen_start_info->mfn_list;
+		/* We roundup to the PMD, which means that if anybody at this stage is
+		 * using the __ka address of xen_start_info or xen_start_info->shared_info
+		 * they are in going to crash. Fortunatly we have already revectored
+		 * in xen_setup_kernel_pagetable and in xen_setup_shared_info. */
+		size = roundup(size, PMD_SIZE);
+		xen_cleanhighmap(addr, addr + size);
 
 		size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
+		memblock_free(__pa(xen_start_info->mfn_list), size);
+		/* And revector! Bye bye old array */
+		xen_start_info->mfn_list = new_mfn_list;
+	} else
+		return;
 
-		/* On 32-bit, we get zero so this never gets executed. */
-		new_mfn_list = xen_revector_p2m_tree();
-		if (new_mfn_list && new_mfn_list != xen_start_info->mfn_list) {
-			/* using __ka address and sticking INVALID_P2M_ENTRY! */
-			memset((void *)xen_start_info->mfn_list, 0xff, size);
-
-			/* We should be in __ka space. */
-			BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
-			addr = xen_start_info->mfn_list;
-			/* We roundup to the PMD, which means that if anybody at this stage is
-			 * using the __ka address of xen_start_info or xen_start_info->shared_info
-			 * they are in going to crash. Fortunatly we have already revectored
-			 * in xen_setup_kernel_pagetable and in xen_setup_shared_info. */
-			size = roundup(size, PMD_SIZE);
-			xen_cleanhighmap(addr, addr + size);
-
-			size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
-			memblock_free(__pa(xen_start_info->mfn_list), size);
-			/* And revector! Bye bye old array */
-			xen_start_info->mfn_list = new_mfn_list;
-		} else
-			goto skip;
-	}
 	/* At this stage, cleanup_highmap has already cleaned __ka space
 	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
 	 * the ramdisk). We continue on, erasing PMD entries that point to page
@@ -1255,8 +1251,19 @@ static void __init xen_pagetable_init(void)
 	 * anything at this stage. */
 	xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);
 #endif
-skip:
+}
+#else
+static void __init xen_pagetable_p2m_copy(void)
+{
+	/* Nada! */
+}
 #endif
+
+static void __init xen_pagetable_init(void)
+{
+	paging_init();
+	xen_setup_shared_info();
+	xen_pagetable_p2m_copy();
 	xen_post_allocator_init();
 }
 static void xen_write_cr2(unsigned long cr2)
-- 
1.8.3.1

