Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3EFW71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:59:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759168Ab3EFW7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 45/46] s390: move dummy io_remap_pfn_range() to asm/pgtable.h
Date: Mon,  6 May 2013 15:58:51 -0700
Message-Id: <20130506225825.429475910@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jiri Slaby <jslaby@suse.cz>
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


