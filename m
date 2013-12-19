Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3LSMvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:51:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3LSL5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 074/208] parisc: fix mmap(MAP_FIXED|MAP_SHARED) to already mmapped address
Date: Thu, 19 Dec 2013 11:52:52 +0000
Message-Id: <1387454106-19326-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 0576da2c08e3d332f1b0653030d28ab804585ab6 upstream.

locale-gen on Debian showed a strange problem on parisc:
mmap2(NULL, 536870912, PROT_NONE, MAP_SHARED, 3, 0) = 0x42a54000
mmap2(0x42a54000, 103860, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, 3, 0) = -1 EINVAL (Invalid argument)

Basically it was just trying to re-mmap() a file at the same address
which it was given by a previous mmap() call. But this remapping failed
with EINVAL.

The problem is, that when MAP_FIXED and MAP_SHARED flags were used, we didn't
included the mapping-based offset when we verified the alignment of the given
fixed address against the offset which we calculated it in the previous call.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/kernel/sys_parisc.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 5dfd248..0d3a9d4 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -61,8 +61,15 @@ static int get_offset(struct address_space *mapping)
 	return (unsigned long) mapping >> 8;
 }
 
-static unsigned long get_shared_area(struct address_space *mapping,
-		unsigned long addr, unsigned long len, unsigned long pgoff)
+static unsigned long shared_align_offset(struct file *filp, unsigned long pgoff)
+{
+	struct address_space *mapping = filp ? filp->f_mapping : NULL;
+
+	return (get_offset(mapping) + pgoff) << PAGE_SHIFT;
+}
+
+static unsigned long get_shared_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff)
 {
 	struct vm_unmapped_area_info info;
 
@@ -71,7 +78,7 @@ static unsigned long get_shared_area(struct address_space *mapping,
 	info.low_limit = PAGE_ALIGN(addr);
 	info.high_limit = TASK_SIZE;
 	info.align_mask = PAGE_MASK & (SHMLBA - 1);
-	info.align_offset = (get_offset(mapping) + pgoff) << PAGE_SHIFT;
+	info.align_offset = shared_align_offset(filp, pgoff);
 	return vm_unmapped_area(&info);
 }
 
@@ -82,20 +89,18 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		return -ENOMEM;
 	if (flags & MAP_FIXED) {
 		if ((flags & MAP_SHARED) &&
-		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
+		    (addr - shared_align_offset(filp, pgoff)) & (SHMLBA - 1))
 			return -EINVAL;
 		return addr;
 	}
 	if (!addr)
 		addr = TASK_UNMAPPED_BASE;
 
-	if (filp) {
-		addr = get_shared_area(filp->f_mapping, addr, len, pgoff);
-	} else if(flags & MAP_SHARED) {
-		addr = get_shared_area(NULL, addr, len, pgoff);
-	} else {
+	if (filp || (flags & MAP_SHARED))
+		addr = get_shared_area(filp, addr, len, pgoff);
+	else
 		addr = get_unshared_area(addr, len);
-	}
+
 	return addr;
 }
 
-- 
1.8.3.2

