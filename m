Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab3ERDAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab3ERDAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:08 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5KyoKaReq3oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xwbbgsaVZFcA:10 a=Z4Rwk6OoAAAA:8 a=VnNF1IyMAAAA:8 a=F-6q-gLq3rtfC1HCImYA:9 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021703.397632313@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [ 136/136 ] s390: move dummy io_remap_pfn_range() to asm/pgtable.h
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0136-s390-move-dummy-io_remap_pfn_range-to-asm-pgtable.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4f2e29031e6c67802e7370292dd050fd62f337ee ]

Commit b4cbb197c7e7 ("vm: add vm_iomap_memory() helper function") added
a helper function wrapper around io_remap_pfn_range(), and every other
architecture defined it in <asm/pgtable.h>.

The s390 choice of <asm/io.h> may make sense, but is not very convenient
for this case, and gratuitous differences like that cause unexpected errors like this:

   mm/memory.c: In function 'vm_iomap_memory':
   mm/memory.c:2439:2: error: implicit declaration of function 'io_remap_pfn_range' [-Werror=implicit-function-declaration]

Glory be the kbuild test robot who noticed this, bisected it, and
reported it to the guilty parties (ie me).

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/s390/include/asm/pgtable.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6bd7d74..fb433eb 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -65,6 +65,10 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 #define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
+/* TODO: s390 cannot support io_remap_pfn_range... */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) 	       \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
 #endif /* !__ASSEMBLY__ */
 
 /*
-- 
1.7.10.4


