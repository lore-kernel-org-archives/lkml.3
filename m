Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaACUcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:32:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23304 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaACUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 06/19] xen/mmu: Cleanup xen_pagetable_p2m_copy a bit.
Date: Fri,  3 Jan 2014 14:38:23 -0500
Message-Id: <1388777916-1328-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano noticed that the code runs only under 64-bit so
the comments about 32-bit are pointless.

Also we change the condition for xen_revector_p2m_tree
returning the same value (because it could not allocate
a swath of space to put the new P2M in) or it had been
called once already. In such we return early from the
function.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c140eff..9d74249 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1209,29 +1209,29 @@ static void __init xen_pagetable_p2m_copy(void)
 
 	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
 
-	/* On 32-bit, we get zero so this never gets executed. */
 	new_mfn_list = xen_revector_p2m_tree();
-	if (new_mfn_list && new_mfn_list != xen_start_info->mfn_list) {
-		/* using __ka address and sticking INVALID_P2M_ENTRY! */
-		memset((void *)xen_start_info->mfn_list, 0xff, size);
-
-		/* We should be in __ka space. */
-		BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
-		addr = xen_start_info->mfn_list;
-		/* We roundup to the PMD, which means that if anybody at this stage is
-		 * using the __ka address of xen_start_info or xen_start_info->shared_info
-		 * they are in going to crash. Fortunatly we have already revectored
-		 * in xen_setup_kernel_pagetable and in xen_setup_shared_info. */
-		size = roundup(size, PMD_SIZE);
-		xen_cleanhighmap(addr, addr + size);
-
-		size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
-		memblock_free(__pa(xen_start_info->mfn_list), size);
-		/* And revector! Bye bye old array */
-		xen_start_info->mfn_list = new_mfn_list;
-	} else
+	/* No memory or already called. */
+	if (!new_mfn_list || new_mfn_list == xen_start_info->mfn_list)
 		return;
 
+	/* using __ka address and sticking INVALID_P2M_ENTRY! */
+	memset((void *)xen_start_info->mfn_list, 0xff, size);
+
+	/* We should be in __ka space. */
+	BUG_ON(xen_start_info->mfn_list < __START_KERNEL_map);
+	addr = xen_start_info->mfn_list;
+	/* We roundup to the PMD, which means that if anybody at this stage is
+	 * using the __ka address of xen_start_info or xen_start_info->shared_info
+	 * they are in going to crash. Fortunatly we have already revectored
+	 * in xen_setup_kernel_pagetable and in xen_setup_shared_info. */
+	size = roundup(size, PMD_SIZE);
+	xen_cleanhighmap(addr, addr + size);
+
+	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
+	memblock_free(__pa(xen_start_info->mfn_list), size);
+	/* And revector! Bye bye old array */
+	xen_start_info->mfn_list = new_mfn_list;
+
 	/* At this stage, cleanup_highmap has already cleaned __ka space
 	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
 	 * the ramdisk). We continue on, erasing PMD entries that point to page
-- 
1.8.3.1

