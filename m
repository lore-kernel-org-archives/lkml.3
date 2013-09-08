Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab3IHDUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56157 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756476Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.76578814@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [102/121] powerpc: Work around gcc miscompilation of __pa() on 64-bit
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit bdbc29c19b2633b1d9c52638fb732bcde7a2031a upstream.

On 64-bit, __pa(&static_var) gets miscompiled by recent versions of
gcc as something like:

        addis 3,2,.LANCHOR1+4611686018427387904@toc@ha
        addi 3,3,.LANCHOR1+4611686018427387904@toc@l

This ends up effectively ignoring the offset, since its bottom 32 bits
are zero, and means that the result of __pa() still has 0xC in the top
nibble.  This happens with gcc 4.8.1, at least.

To work around this, for 64-bit we make __pa() use an AND operator,
and for symmetry, we make __va() use an OR operator.  Using an AND
operator rather than a subtraction ends up with slightly shorter code
since it can be done with a single clrldi instruction, whereas it
takes three instructions to form the constant (-PAGE_OFFSET) and add
it on.  (Note that MEMORY_START is always 0 on 64-bit.)

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/Kconfig            |  1 +
 arch/powerpc/include/asm/page.h | 10 ++++++++++
 2 files changed, 11 insertions(+)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -937,6 +937,7 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
+# This value must have zeroes in the bottom 60 bits otherwise lots will break
 config PAGE_OFFSET
 	hex
 	default "0xc000000000000000"
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -132,9 +132,19 @@ extern phys_addr_t kernstart_addr;
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) - PHYSICAL_START + KERNELBASE))
 #define __pa(x) ((unsigned long)(x) + PHYSICAL_START - KERNELBASE)
 #else
+#ifdef CONFIG_PPC64
+/*
+ * gcc miscompiles (unsigned long)(&static_var) - PAGE_OFFSET
+ * with -mcmodel=medium, so we use & and | instead of - and + on 64-bit.
+ */
+#define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) | PAGE_OFFSET))
+#define __pa(x) ((unsigned long)(x) & 0x0fffffffffffffffUL)
+
+#else /* 32-bit, non book E */
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) + PAGE_OFFSET - MEMORY_START))
 #define __pa(x) ((unsigned long)(x) - PAGE_OFFSET + MEMORY_START)
 #endif
+#endif
 
 /*
  * Unfortunately the PLT is in the BSS in the PPC32 ELF ABI,

