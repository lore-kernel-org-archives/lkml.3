Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaGIQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:08:43 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52730 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaGIQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:08:42 -0400
Message-ID: <53BD68FF.7000307@linux.vnet.ibm.com>
Date: Wed, 09 Jul 2014 21:38:31 +0530
From: Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Fail remap_4k_pfn() if PFN doesn't fit inside PTE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070916-4790-0000-0000-0000028DF306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


remap_4k_pfn() silently truncates upper bits of input 4K PFN if
it cannot be contained in PTE. This leads invalid memory mapping
and could result in a system crash when the memory is accessed.
This patch fails remap_4k_pfn() and returns -EINVAL if the input
4K PFN cannot be contained in PTE.
Used a helper inline function in the failure case so that the
remap_4k_pfn() macro can still be used in expression contexts.

Signed-off-by: Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pte-hash64-64k.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/include/asm/pte-hash64-64k.h
index d836d94..10af7f1 100644
--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -74,8 +74,15 @@
 #define pte_pagesize_index(mm, addr, pte)	\
 	(((pte) & _PAGE_COMBO)? MMU_PAGE_4K: MMU_PAGE_64K)

+static inline int bad_4k_pfn(void)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
 #define remap_4k_pfn(vma, addr, pfn, prot)				\
-	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,		\
-			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN))
+	((pfn >= (1UL << (64 - PTE_RPN_SHIFT))) ? bad_4k_pfn() :	\
+		remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,	\
+			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN)))

 #endif	/* __ASSEMBLY__ */
-- 
2.0.1

