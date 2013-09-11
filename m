Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3IKF2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:28:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3IKE5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:24 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_NIXQZT_2S0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jy2ccRMYXSsA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=Nh7YIalddaGwczpXZ10A:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=78K5B4DhCii-Ekt2:21 a=iERdINJSVm1rwHv7:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042912.549188968@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [122/251] ARM: use linker magic for vectors and vector stubs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0122-ARM-use-linker-magic-for-vectors-and-vector-stubs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit b9b32bf70f2fb710b07c94e13afbc729afe221da ]

Use linker magic to create the vectors and vector stubs: we can tell the
linker to place them at an appropriate VMA, but keep the LMA within the
kernel.  This gets rid of some unnecessary symbol manipulation, and
have the linker calculate the relocations appropriately.

Cc: <stable@vger.kernel.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/entry-armv.S  |   28 ++++++++++------------------
 arch/arm/kernel/vmlinux.lds.S |   17 +++++++++++++++++
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index a4af8e8..c19779f 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1035,7 +1035,7 @@ ENDPROC(vector_\name)
 1:
 	.endm
 
-	.globl	__stubs_start
+	.section .stubs, "ax", %progbits
 __stubs_start:
 	@ This must be the first word
 	.word	vector_swi
@@ -1162,24 +1162,16 @@ vector_addrexcptn:
 vector_fiq:
 	subs	pc, lr, #4
 
-	.globl	__stubs_end
-__stubs_end:
-
-	.equ	stubs_offset, __vectors_start + 0x1000 - __stubs_start
-
-	.globl	__vectors_start
+	.section .vectors, "ax", %progbits
 __vectors_start:
-	W(b)	vector_rst + stubs_offset
-	W(b)	vector_und + stubs_offset
-	W(ldr)	pc, .LCvswi + stubs_offset
-	W(b)	vector_pabt + stubs_offset
-	W(b)	vector_dabt + stubs_offset
-	W(b)	vector_addrexcptn + stubs_offset
-	W(b)	vector_irq + stubs_offset
-	W(b)	vector_fiq + stubs_offset
-
-	.globl	__vectors_end
-__vectors_end:
+	W(b)	vector_rst
+	W(b)	vector_und
+	W(ldr)	pc, __vectors_start + 0x1000
+	W(b)	vector_pabt
+	W(b)	vector_dabt
+	W(b)	vector_addrexcptn
+	W(b)	vector_irq
+	W(b)	vector_fiq
 
 	.data
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 36ff15b..2f8f92e 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -137,6 +137,23 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_begin = .;
 #endif
+	/*
+	 * The vectors and stubs are relocatable code, and the
+	 * only thing that matters is their relative offsets
+	 */
+	__vectors_start = .;
+	.vectors 0 : AT(__vectors_start) {
+		*(.vectors)
+	}
+	. = __vectors_start + SIZEOF(.vectors);
+	__vectors_end = .;
+
+	__stubs_start = .;
+	.stubs 0x1000 : AT(__stubs_start) {
+		*(.stubs)
+	}
+	. = __stubs_start + SIZEOF(.stubs);
+	__stubs_end = .;
 
 	INIT_TEXT_SECTION(8)
 	.exit.text : {
-- 
1.7.10.4


