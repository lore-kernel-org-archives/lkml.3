Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaHTPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaHTPZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:25:56 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com
Subject: [PATCH 1/2] x86: add high_memory check to (xlate|unxlate)_dev_mem_ptr
Date: Wed, 20 Aug 2014 17:25:25 +0200
Message-Id: <1408548326-18665-2-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1408548326-18665-1-git-send-email-fhrbata@redhat.com>
References: <1408103043-31015-1-git-send-email-fhrbata@redhat.com>
 <1408548326-18665-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far (xlate|unxlate)_dev_mem_ptr for read/write /dev/mem relies on a generic
high_memory check in valid_phys_addr_range(), which does not allow to access any
memory above high_memory whatsoever. By adding the high_memory check to
(xlate|unxlate)_dev_mem_ptr, it still will be possible to use __va safely for
kernel mapped memory and it will also allow read/write to access non-system RAM
above high_memory once the high_memory check is removed from
valid_phys_addr_range.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 arch/x86/mm/ioremap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index baff1da..1ae7323 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -320,8 +320,11 @@ void *xlate_dev_mem_ptr(unsigned long phys)
 	void *addr;
 	unsigned long start = phys & PAGE_MASK;
 
-	/* If page is RAM, we can use __va. Otherwise ioremap and unmap. */
-	if (page_is_ram(start >> PAGE_SHIFT))
+	/*
+	 * If page is RAM and is mapped by kernel, we can use __va.
+	 * Otherwise ioremap and unmap.
+	 */
+	if (page_is_ram(start >> PAGE_SHIFT) && phys <= __pa(high_memory))
 		return __va(phys);
 
 	addr = (void __force *)ioremap_cache(start, PAGE_SIZE);
@@ -333,7 +336,7 @@ void *xlate_dev_mem_ptr(unsigned long phys)
 
 void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 {
-	if (page_is_ram(phys >> PAGE_SHIFT))
+	if (page_is_ram(phys >> PAGE_SHIFT) && phys <= __pa(high_memory))
 		return;
 
 	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
-- 
1.9.3

