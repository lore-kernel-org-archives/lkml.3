Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3IKE5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3IKE4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:49 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=rtVuEUoX3JIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YgdE7FNah_QA:10 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=dowx1zmaLagA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042932.294397927@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [240/251] powerpc: Work around gcc miscompilation of __pa() on 64-bit
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0240-powerpc-Work-around-gcc-miscompilation-of-__pa-on-64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

[ Upstream commit bdbc29c19b2633b1d9c52638fb732bcde7a2031a ]

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

CC: <stable@vger.kernel.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/Kconfig            |    1 +
 arch/powerpc/include/asm/page.h |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..3254335 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -973,6 +973,7 @@ config RELOCATABLE
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
1.7.10.4


