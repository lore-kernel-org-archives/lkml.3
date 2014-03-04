Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaCDVFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:05:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbaCDUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 101/172] powerpc/crashdump : Fix page frame number check in copy_oldmem_page
Date: Tue,  4 Mar 2014 12:03:05 -0800
Message-Id: <20140304200302.944502898@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/crash_dump.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -98,17 +98,19 @@ ssize_t copy_oldmem_page(unsigned long p
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


