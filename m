Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3EVKTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:19:08 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37935 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3EVKTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:19:01 -0400
Date: Wed, 22 May 2013 12:18:47 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org, Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] mm: Fix warning
Message-ID: <20130522101847.GB10769@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_page() is typically implemented as a macro containing a cast so
it'll accept both pointers and unsigned long without causing a warning.
MIPS virt_to_page() uses virt_to_phys which is a function so passing an
unsigned long will cause a warning:

  CC      mm/page_alloc.o
/home/ralf/src/linux/linux-mips/mm/page_alloc.c: In function ‘free_reserved_area’:
/home/ralf/src/linux/linux-mips/mm/page_alloc.c:5161:3: warning: passing argument 1 of ‘virt_to_phys’ makes pointer from integer without a cast [enabled by default]
In file included from /home/ralf/src/linux/linux-mips/arch/mips/include/asm/page.h:153:0,
                 from /home/ralf/src/linux/linux-mips/include/linux/mmzone.h:20,
                 from /home/ralf/src/linux/linux-mips/include/linux/gfp.h:4,
                 from /home/ralf/src/linux/linux-mips/include/linux/mm.h:8,
                 from /home/ralf/src/linux/linux-mips/mm/page_alloc.c:18:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:119:100: note: expected ‘const volatile void *’ but argument is of type ‘long unsigned int’

All others users of virt_to_page() in mm/ are passing a void *.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reported-by: Eunbong Song <eunb.song@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 98cbdf6..378a15b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5158,7 +5158,7 @@ unsigned long free_reserved_area(unsigned long start, unsigned long end,
 	for (pages = 0; pos < end; pos += PAGE_SIZE, pages++) {
 		if (poison)
 			memset((void *)pos, poison, PAGE_SIZE);
-		free_reserved_page(virt_to_page(pos));
+		free_reserved_page(virt_to_page((void *)pos));
 	}
 
 	if (pages && s)
