Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3EJOkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:40:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57093 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842Ab3EJOU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.835878781@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [080/118] s390: move dummy io_remap_pfn_range() to asm/pgtable.h
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: the macro was not defined, so this is an addition
 and not a move]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/include/asm/io.h      |    4 ----
 arch/s390/include/asm/pgtable.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -67,6 +67,10 @@ static inline int is_zero_pfn(unsigned l
 
 #define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
+/* TODO: s390 cannot support io_remap_pfn_range... */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) 	       \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
 #endif /* !__ASSEMBLY__ */
 
 /*

