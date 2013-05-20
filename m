Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3ETKxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3ETKxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 055/115] s390: move dummy io_remap_pfn_range() to asm/pgtable.h
Date: Mon, 20 May 2013 11:50:55 +0100
Message-Id: <1369047116-9378-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4f2e29031e6c67802e7370292dd050fd62f337ee upstream.

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
[ luis: backported to 3.5:
  - Took the patch 2nd hunk only, as the io_remap_pfn_range wasn't defined ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/include/asm/pgtable.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b322741..0d6400e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -67,6 +67,10 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 #define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
+/* TODO: s390 cannot support io_remap_pfn_range... */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) 	       \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
 #endif /* !__ASSEMBLY__ */
 
 /*
-- 
1.8.1.2

