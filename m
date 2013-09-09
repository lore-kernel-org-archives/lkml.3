Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3IISri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:47:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3IISpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 13/24] powerpc: Work around gcc miscompilation of __pa() on 64-bit
Date: Mon,  9 Sep 2013 11:45:03 -0700
Message-Id: <1378752314-2416-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/Kconfig            |  1 +
 arch/powerpc/include/asm/page.h | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 74002f0..7dd83fc 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -995,6 +995,7 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
+# This value must have zeroes in the bottom 60 bits otherwise lots will break
 config PAGE_OFFSET
 	hex
 	default "0xc000000000000000"
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index f072e97..2e6c4e5a 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -211,9 +211,19 @@ extern long long virt_phys_offset;
 #define __va(x) ((void *)(unsigned long)((phys_addr_t)(x) + VIRT_PHYS_OFFSET))
 #define __pa(x) ((unsigned long)(x) - VIRT_PHYS_OFFSET)
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
-- 
1.8.1.2

