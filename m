Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbaGOTqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:46:54 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38549 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933671AbaGOTpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:44 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 2/11] x86, mm, pat: Define _PAGE_CACHE_WT for PA3/7 of PAT
Date: Tue, 15 Jul 2014 13:34:35 -0600
Message-Id: <1405452884-25688-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines _PAGE_CACHE_WT and its relevant macros, which
now use the PA3/7 slot in the PAT MSR.  pat_init() is also changed
to set the WT memory type to the PA3/7 slot in the PAT MSR.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/pgtable_types.h |    5 +++++
 arch/x86/mm/pat.c                    |    8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 03d40da..7b905cb 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -132,6 +132,7 @@
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
 #define _PAGE_CACHE_WC		(_PAGE_PWT)
+#define _PAGE_CACHE_WT		(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
 #define _PAGE_CACHE_UC		(_PAGE_CACHE_UC_MINUS)
 
@@ -159,6 +160,7 @@
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_CACHE_UC)
 #define __PAGE_KERNEL_WC		(__PAGE_KERNEL | _PAGE_CACHE_WC)
+#define __PAGE_KERNEL_WT		(__PAGE_KERNEL | _PAGE_CACHE_WT)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_CACHE_UC)
 #define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_CACHE_UC_MINUS)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
@@ -172,12 +174,14 @@
 #define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE | _PAGE_IOMAP)
 #define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS | _PAGE_IOMAP)
 #define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_WT		(__PAGE_KERNEL_WT | _PAGE_IOMAP)
 
 #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_WC			__pgprot(__PAGE_KERNEL_WC)
+#define PAGE_KERNEL_WT			__pgprot(__PAGE_KERNEL_WT)
 #define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
 #define PAGE_KERNEL_UC_MINUS		__pgprot(__PAGE_KERNEL_UC_MINUS)
 #define PAGE_KERNEL_EXEC_NOCACHE	__pgprot(__PAGE_KERNEL_EXEC_NOCACHE)
@@ -192,6 +196,7 @@
 #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
 #define PAGE_KERNEL_IO_UC_MINUS		__pgprot(__PAGE_KERNEL_IO_UC_MINUS)
 #define PAGE_KERNEL_IO_WC		__pgprot(__PAGE_KERNEL_IO_WC)
+#define PAGE_KERNEL_IO_WT		__pgprot(__PAGE_KERNEL_IO_WT)
 
 /*         xwr */
 #define __P000	PAGE_NONE
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index c3567a5..176d4d6 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -101,7 +101,7 @@ void pat_init(void)
 		}
 	}
 
-	/* Set PWT to Write-Combining. All other bits stay the same */
+	/* Set PWT to Write-Combining, and PCD|PWT to Write-Through. */
 	/*
 	 * PTE encoding used in Linux:
 	 *      PAT
@@ -111,11 +111,11 @@ void pat_init(void)
 	 *      000 WB		_PAGE_CACHE_WB
 	 *      001 WC		_PAGE_CACHE_WC
 	 *      010 UC-		_PAGE_CACHE_UC_MINUS
-	 *      011 UC		_PAGE_CACHE_UC
+	 *      011 WT		_PAGE_CACHE_WT
 	 * PAT bit unused
 	 */
-	pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
-	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
+	pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, WT) |
+	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, WT);
 
 	/* Boot CPU check */
 	if (!boot_pat_state)
