Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab3HNKxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:53:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab3HNKho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 29/75] ARM: use linker magic for vectors and vector stubs
Date: Wed, 14 Aug 2013 11:36:18 +0100
Message-Id: <1376476624-10011-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit b9b32bf70f2fb710b07c94e13afbc729afe221da upstream.

Use linker magic to create the vectors and vector stubs: we can tell the
linker to place them at an appropriate VMA, but keep the LMA within the
kernel.  This gets rid of some unnecessary symbol manipulation, and
have the linker calculate the relocations appropriately.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/entry-armv.S  | 28 ++++++++++------------------
 arch/arm/kernel/vmlinux.lds.S | 17 +++++++++++++++++
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
1.8.3.2

