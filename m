Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbaCEOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbaCEOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 62/62] powerpc/crashdump : Fix page frame number check in copy_oldmem_page
Date: Wed,  5 Mar 2014 14:37:06 +0000
Message-Id: <1394030226-26652-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Dufour <ldufour@linux.vnet.ibm.com>

commit f5295bd8ea8a65dc5eac608b151386314cb978f1 upstream.

In copy_oldmem_page, the current check using max_pfn and min_low_pfn to
decide if the page is backed or not, is not valid when the memory layout is
not continuous.

This happens when running as a QEMU/KVM guest, where RTAS is mapped higher
in the memory. In that case max_pfn points to the end of RTAS, and a hole
between the end of the kdump kernel and RTAS is not backed by PTEs. As a
consequence, the kdump kernel is crashing in copy_oldmem_page when accessing
in a direct way the pages in that hole.

This fix relies on the memblock's service memblock_is_region_memory to
check if the read page is part or not of the directly accessible memory.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Tested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/crash_dump.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index b3ba516..9d6a4a4 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -108,17 +108,19 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 			size_t csize, unsigned long offset, int userbuf)
 {
 	void  *vaddr;
+	phys_addr_t paddr;
 
 	if (!csize)
 		return 0;
 
 	csize = min_t(size_t, csize, PAGE_SIZE);
+	paddr = pfn << PAGE_SHIFT;
 
-	if ((min_low_pfn < pfn) && (pfn < max_pfn)) {
-		vaddr = __va(pfn << PAGE_SHIFT);
+	if (memblock_is_region_memory(paddr, csize)) {
+		vaddr = __va(paddr);
 		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
 	} else {
-		vaddr = __ioremap(pfn << PAGE_SHIFT, PAGE_SIZE, 0);
+		vaddr = __ioremap(paddr, PAGE_SIZE, 0);
 		csize = copy_oldmem_vaddr(vaddr, buf, csize, offset, userbuf);
 		iounmap(vaddr);
 	}
-- 
1.9.0

