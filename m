Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaC3XoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:44:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbaC3Xnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mahesh Salgaonkar" <mahesh@linux.vnet.ibm.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Laurent Dufour" <ldufour@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.169184599@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 154/200] powerpc/crashdump : Fix page frame number
 check in copy_oldmem_page
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/crash_dump.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -108,17 +108,19 @@ ssize_t copy_oldmem_page(unsigned long p
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

