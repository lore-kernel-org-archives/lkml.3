Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaHDROV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:14:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56480 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lennox Wu" <lennox.wu@gmail.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.774484403@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 75/94] Score: The commit is for compiling
 successfully. 	The modifications include: 	1. Kconfig of Score: we don't
 support ioremap  2. Missed headfile including 	3. There are some errors in
 other people's commit not checked by us, we fix it now 	3.1
 arch/score/kernel/entry.S: wrong instructions 	3.2 arch/score/kernel/process.c
 : just some typos
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lennox Wu <lennox.wu@gmail.com>

commit 5fbbf8a1a93452b26e7791cf32cefce62b0a480b upstream.

	Signed-off-by: Lennox Wu <lennox.wu@gmail.com>
[bwh: Backported to 3.2:
 - Drop addition of 'select HAVE_GENERIC_HARDIRQS' which was not removed here
 - Drop inapplicale change to copy_thread()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -108,3 +108,6 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+config NO_IOMEM
+       def_bool y
--- a/arch/score/include/asm/io.h
+++ b/arch/score/include/asm/io.h
@@ -5,5 +5,4 @@
 
 #define virt_to_bus	virt_to_phys
 #define bus_to_virt	phys_to_virt
-
 #endif /* _ASM_SCORE_IO_H */
--- a/arch/score/include/asm/pgalloc.h
+++ b/arch/score/include/asm/pgalloc.h
@@ -2,7 +2,7 @@
 #define _ASM_SCORE_PGALLOC_H
 
 #include <linux/mm.h>
-
+#include <linux/highmem.h>
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 	pte_t *pte)
 {
--- a/arch/score/kernel/entry.S
+++ b/arch/score/kernel/entry.S
@@ -264,7 +264,7 @@ resume_kernel:
 	disable_irq
 	lw	r8, [r28, TI_PRE_COUNT]
 	cmpz.c	r8
-	bne	r8, restore_all
+	bne	restore_all
 need_resched:
 	lw	r8, [r28, TI_FLAGS]
 	andri.c	r9, r8, _TIF_NEED_RESCHED
@@ -408,7 +408,7 @@ ENTRY(handle_sys)
 	sw	r9, [r0, PT_EPC]
 
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
-	bgeu	illegal_syscall
+	bcs	illegal_syscall
 
 	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table

