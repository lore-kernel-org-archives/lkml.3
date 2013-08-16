Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3HQA2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:28:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3HPWhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 075/133] ARM: use linker magic for vectors and vector stubs
Date: Fri, 16 Aug 2013 15:33:37 -0700
Message-Id: <1376692475-28413-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit b9b32bf70f2fb710b07c94e13afbc729afe221da upstream.

Use linker magic to create the vectors and vector stubs: we can tell the
linker to place them at an appropriate VMA, but keep the LMA within the
kernel.  This gets rid of some unnecessary symbol manipulation, and
have the linker calculate the relocations appropriately.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
index 11c1785..f9036ac 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -148,6 +148,23 @@ SECTIONS
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
1.8.1.2

