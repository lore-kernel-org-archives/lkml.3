Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaGJImb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:42:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48347 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaGJIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:42:28 -0400
Message-ID: <53BE51EB.5090208@linux.vnet.ibm.com>
Date: Thu, 10 Jul 2014 14:12:19 +0530
From: Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH V2] powerpc: Fail remap_4k_pfn() if PFN doesn't fit inside
 PTE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071008-8878-0000-0000-00000D7E68CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2 : Rewritten to avoid helper function as suggested by Stephen Rothwell.
remap_4k_pfn() silently truncates upper bits of input 4K PFN if
it cannot be contained in PTE. This leads invalid memory mapping
and could result in a system crash when the memory is accessed.
This patch fails remap_4k_pfn() and returns -EINVAL if the input
4K PFN cannot be contained in PTE.

Signed-off-by: Madhusudanan Kandasamy <kmadhu@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pte-hash64-64k.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/include/asm/pte-hash64-64k.h
index d836d94..b5178e4 100644
--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -75,7 +75,8 @@
 	(((pte) & _PAGE_COMBO)? MMU_PAGE_4K: MMU_PAGE_64K)

 #define remap_4k_pfn(vma, addr, pfn, prot)				\
-	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,		\
+	WARN_ON((pfn >= (1UL << (64 - PTE_RPN_SHIFT)))) ? -EINVAL :	\
+		remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE,	\
 			__pgprot(pgprot_val((prot)) | _PAGE_4K_PFN))

 #endif	/* __ASSEMBLY__ */
-- 
2.0.1

