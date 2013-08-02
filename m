Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3HBKTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:19:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3HBKTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:19:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 36/39] s390: move dummy io_remap_pfn_range() to asm/pgtable.h
Date: Fri,  2 Aug 2013 18:18:46 +0800
Message-Id: <20130802101501.894472966@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
[bwh: Backported to 3.2: the macro was not defined, so this is an addition
 and not a move]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/pgtable.h |    4 ++++
 1 file changed, 4 insertions(+)

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


