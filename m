Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710AbaE2FiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:38:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaE2Eex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>, Jeroen Roovers <jer@gentoo.org>,
        John David Anglin <dave.anglin@bell.net>,
        Carlos ODonell <carlos@systemhalted.org>
Subject: [PATCH 3.14 020/140] parisc: change value of SHMLBA from 0x00400000 to PAGE_SIZE
Date: Wed, 28 May 2014 21:32:39 -0700
Message-Id: <20140529043051.945910726@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 0ef36bd2b37815719e31a72d2beecc28ca8ecd26 upstream.

On parisc, SHMLBA was defined to 0x00400000 (4MB) to reflect that we need to
take care of our caches for shared mappings. But actually, we can map a file at
any multiple address of PAGE_SIZE, so let us correct that now with a value of
PAGE_SIZE for SHMLBA.  Instead we now take care of this cache colouring via the
constant SHM_COLOUR while we map shared pages.

Signed-off-by: Helge Deller <deller@gmx.de>
CC: Jeroen Roovers <jer@gentoo.org>
CC: John David Anglin <dave.anglin@bell.net>
CC: Carlos O'Donell <carlos@systemhalted.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/shmparam.h |    5 ++---
 arch/parisc/kernel/cache.c         |    3 ++-
 arch/parisc/kernel/sys_parisc.c    |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/parisc/include/asm/shmparam.h
+++ b/arch/parisc/include/asm/shmparam.h
@@ -1,8 +1,7 @@
 #ifndef _ASMPARISC_SHMPARAM_H
 #define _ASMPARISC_SHMPARAM_H
 
-#define __ARCH_FORCE_SHMLBA 	1
-
-#define SHMLBA 0x00400000   /* attach addr needs to be 4 Mb aligned */
+#define SHMLBA	   PAGE_SIZE	/* attach addr a multiple of this */
+#define SHM_COLOUR 0x00400000	/* shared mappings colouring */
 
 #endif /* _ASMPARISC_SHMPARAM_H */
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -323,7 +323,8 @@ void flush_dcache_page(struct page *page
 		 * specifically accesses it, of course) */
 
 		flush_tlb_page(mpnt, addr);
-		if (old_addr == 0 || (old_addr & (SHMLBA - 1)) != (addr & (SHMLBA - 1))) {
+		if (old_addr == 0 || (old_addr & (SHM_COLOUR - 1))
+				      != (addr & (SHM_COLOUR - 1))) {
 			__flush_cache_page(mpnt, addr, page_to_phys(page));
 			if (old_addr)
 				printk(KERN_ERR "INEQUIVALENT ALIASES 0x%lx and 0x%lx in file %s\n", old_addr, addr, mpnt->vm_file ? (char *)mpnt->vm_file->f_path.dentry->d_name.name : "(null)");
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -45,7 +45,7 @@
 
 static int get_offset(unsigned int last_mmap)
 {
-	return (last_mmap & (SHMLBA-1)) >> PAGE_SHIFT;
+	return (last_mmap & (SHM_COLOUR-1)) >> PAGE_SHIFT;
 }
 
 static unsigned long shared_align_offset(unsigned int last_mmap,
@@ -57,8 +57,8 @@ static unsigned long shared_align_offset
 static inline unsigned long COLOR_ALIGN(unsigned long addr,
 			 unsigned int last_mmap, unsigned long pgoff)
 {
-	unsigned long base = (addr+SHMLBA-1) & ~(SHMLBA-1);
-	unsigned long off  = (SHMLBA-1) &
+	unsigned long base = (addr+SHM_COLOUR-1) & ~(SHM_COLOUR-1);
+	unsigned long off  = (SHM_COLOUR-1) &
 		(shared_align_offset(last_mmap, pgoff) << PAGE_SHIFT);
 
 	return base + off;
@@ -101,7 +101,7 @@ unsigned long arch_get_unmapped_area(str
 	if (flags & MAP_FIXED) {
 		if ((flags & MAP_SHARED) && last_mmap &&
 		    (addr - shared_align_offset(last_mmap, pgoff))
-				& (SHMLBA - 1))
+				& (SHM_COLOUR - 1))
 			return -EINVAL;
 		goto found_addr;
 	}
@@ -122,7 +122,7 @@ unsigned long arch_get_unmapped_area(str
 	info.length = len;
 	info.low_limit = mm->mmap_legacy_base;
 	info.high_limit = mmap_upper_limit();
-	info.align_mask = last_mmap ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	info.align_mask = last_mmap ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
 	info.align_offset = shared_align_offset(last_mmap, pgoff);
 	addr = vm_unmapped_area(&info);
 
@@ -161,7 +161,7 @@ arch_get_unmapped_area_topdown(struct fi
 	if (flags & MAP_FIXED) {
 		if ((flags & MAP_SHARED) && last_mmap &&
 		    (addr - shared_align_offset(last_mmap, pgoff))
-			& (SHMLBA - 1))
+			& (SHM_COLOUR - 1))
 			return -EINVAL;
 		goto found_addr;
 	}
@@ -182,7 +182,7 @@ arch_get_unmapped_area_topdown(struct fi
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = last_mmap ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	info.align_mask = last_mmap ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
 	info.align_offset = shared_align_offset(last_mmap, pgoff);
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))


