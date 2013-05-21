Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3EUMqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:46:18 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:42580 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3EUMqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:46:11 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] ARC: [mm] copy_(to|from)_user() to honor usermode-access permissions
Date: Tue, 21 May 2013 18:14:19 +0530
Message-ID: <1369140259-30501-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369140259-30501-1-git-send-email-vgupta@synopsys.com>
References: <1369140259-30501-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This manifested as grep failing psuedo-randomly:

-------------->8---------------------
[ARCLinux]$ ip address show lo | grep inet
[ARCLinux]$ ip address show lo | grep inet
[ARCLinux]$ ip address show lo | grep inet
[ARCLinux]$
[ARCLinux]$ ip address show lo | grep inet
    inet 127.0.0.1/8 scope host lo
-------------->8---------------------

ARC700 MMU provides fully orthogonal permission bits per page:
Ur, Uw, Ux, Kr, Kw, Kx

The user mode page permission templates used to have all Kernel mode
access bits enabled.
This caused a tricky race condition observed with uClibc buffered file
read and UNIX pipes.

1. Read access to an anon mapped page in libc .bss: write-protected
   zero_page mapped: TLB Entry installed with Ur + K[rwx]

2. grep calls libc:getc() -> buffered read layer calls read(2) with the
   internal read buffer in same .bss page.
   The read() call is on STDIN which has been redirected to a pipe.
   read(2) => sys_read() => pipe_read() => copy_to_user()

3. Since page has Kernel-write permission (despite being user-mode
   write-protected), copy_to_user() suceeds w/o taking a MMU TLB-Miss
   Exception (page-fault for ARC). core-MM is unaware that kernel
   erroneously wrote to the reserved read-only zero-page (BUG #1)

4. Control returns to userspace which now does a write to same .bss page
   Since Linux MM is not aware that page has been modified by kernel, it
   simply reassigns a new writable zero-init page to mapping, loosing the
   prior write by kernel - effectively zero'ing out the libc read buffer
   under the hood - hence grep doesn't see right data (BUG #2)

The fix is to make all kernel-mode access permissions mirror the
user-mode ones. Note that the kernel still has full access to pages,
when accessed directly (w/o MMU) - this fix ensures that kernel-mode
access in copy_to_from() path uses the same faulting access model as for
pure user accesses to keep MM fully aware of page state.

The issue is peudo-random because it only shows up if the TLB entry
installed in #1 is present at the time of #3. If it is evicted out, due
to TLB pressure or some-such, then copy_to_user() does take a TLB Miss
Exception, with a routine write-to-anon COW processing installing a
fresh page for kernel writes and also usable as it is in userspace.

Further the issue was dormant for so long as it depends on where the
libc internal read buffer (in .bss) is mapped at runtime.
If it happens to reside in file-backed data mapping of libc (in the
page-aligned slack space trailing the file backed data), loader zero
padding the slack space, does the early cow page replacement, setting
things up at the very beginning itself.

With gcc 4.8 based builds, the libc buffer got pushed out to a real
anon mapping which triggers the issue.

Reported-by: Anton Kolesov <akolesov@synopsys.com>
Cc: stable@vger.kernel.org # 3.9
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/pgtable.h |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arc/include/asm/pgtable.h b/arch/arc/include/asm/pgtable.h
index b7e3668..8ca472c 100644
--- a/arch/arc/include/asm/pgtable.h
+++ b/arch/arc/include/asm/pgtable.h
@@ -57,9 +57,9 @@
 
 #define _PAGE_ACCESSED      (1<<1)	/* Page is accessed (S) */
 #define _PAGE_CACHEABLE     (1<<2)	/* Page is cached (H) */
-#define _PAGE_EXECUTE       (1<<3)	/* Page has user execute perm (H) */
-#define _PAGE_WRITE         (1<<4)	/* Page has user write perm (H) */
-#define _PAGE_READ          (1<<5)	/* Page has user read perm (H) */
+#define _PAGE_U_EXECUTE     (1<<3)	/* Page has user execute perm (H) */
+#define _PAGE_U_WRITE       (1<<4)	/* Page has user write perm (H) */
+#define _PAGE_U_READ        (1<<5)	/* Page has user read perm (H) */
 #define _PAGE_K_EXECUTE     (1<<6)	/* Page has kernel execute perm (H) */
 #define _PAGE_K_WRITE       (1<<7)	/* Page has kernel write perm (H) */
 #define _PAGE_K_READ        (1<<8)	/* Page has kernel perm (H) */
@@ -72,9 +72,9 @@
 
 /* PD1 */
 #define _PAGE_CACHEABLE     (1<<0)	/* Page is cached (H) */
-#define _PAGE_EXECUTE       (1<<1)	/* Page has user execute perm (H) */
-#define _PAGE_WRITE         (1<<2)	/* Page has user write perm (H) */
-#define _PAGE_READ          (1<<3)	/* Page has user read perm (H) */
+#define _PAGE_U_EXECUTE     (1<<1)	/* Page has user execute perm (H) */
+#define _PAGE_U_WRITE       (1<<2)	/* Page has user write perm (H) */
+#define _PAGE_U_READ        (1<<3)	/* Page has user read perm (H) */
 #define _PAGE_K_EXECUTE     (1<<4)	/* Page has kernel execute perm (H) */
 #define _PAGE_K_WRITE       (1<<5)	/* Page has kernel write perm (H) */
 #define _PAGE_K_READ        (1<<6)	/* Page has kernel perm (H) */
@@ -93,7 +93,8 @@
 #endif
 
 /* Kernel allowed all permissions for all pages */
-#define _K_PAGE_PERMS  (_PAGE_K_EXECUTE | _PAGE_K_WRITE | _PAGE_K_READ)
+#define _K_PAGE_PERMS  (_PAGE_K_EXECUTE | _PAGE_K_WRITE | _PAGE_K_READ | \
+			_PAGE_GLOBAL | _PAGE_PRESENT)
 
 #ifdef CONFIG_ARC_CACHE_PAGES
 #define _PAGE_DEF_CACHEABLE _PAGE_CACHEABLE
@@ -106,7 +107,11 @@
  * -by default cached, unless config otherwise
  * -present in memory
  */
-#define ___DEF (_PAGE_PRESENT | _K_PAGE_PERMS | _PAGE_DEF_CACHEABLE)
+#define ___DEF (_PAGE_PRESENT | _PAGE_DEF_CACHEABLE)
+
+#define _PAGE_READ	(_PAGE_U_READ    | _PAGE_K_READ)
+#define _PAGE_WRITE	(_PAGE_U_WRITE   | _PAGE_K_WRITE)
+#define _PAGE_EXECUTE	(_PAGE_U_EXECUTE | _PAGE_K_EXECUTE)
 
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED)
@@ -125,11 +130,10 @@
  * kernel vaddr space - visible in all addr spaces, but kernel mode only
  * Thus Global, all-kernel-access, no-user-access, cached
  */
-#define PAGE_KERNEL          __pgprot(___DEF | _PAGE_GLOBAL)
+#define PAGE_KERNEL          __pgprot(_K_PAGE_PERMS | _PAGE_DEF_CACHEABLE)
 
 /* ioremap */
-#define PAGE_KERNEL_NO_CACHE __pgprot(_PAGE_PRESENT | _K_PAGE_PERMS | \
-						     _PAGE_GLOBAL)
+#define PAGE_KERNEL_NO_CACHE __pgprot(_K_PAGE_PERMS)
 
 /**************************************************************************
  * Mapping of vm_flags (Generic VM) to PTE flags (arch specific)
-- 
1.7.10.4

