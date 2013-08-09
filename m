Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967369Ab3HIB62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967342Ab3HIB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 005/102] ARM: update FIQ support for relocation of vectors
Date: Thu,  8 Aug 2013 18:56:41 -0700
Message-Id: <20130809015011.484451736@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8 upstream.

FIQ should no longer copy the FIQ code into the user visible vector
page.  Instead, it should use the hidden page.  This change makes
that happen.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/entry-armv.S |    3 +++
 arch/arm/kernel/fiq.c        |   19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1119,6 +1119,9 @@ vector_addrexcptn:
 vector_fiq:
 	subs	pc, lr, #4
 
+	.globl	vector_fiq_offset
+	.equ	vector_fiq_offset, vector_fiq
+
 	.section .vectors, "ax", %progbits
 __vectors_start:
 	W(b)	vector_rst
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -47,6 +47,11 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 
+#define FIQ_OFFSET ({					\
+		extern void *vector_fiq_offset;		\
+		(unsigned)&vector_fiq_offset;		\
+	})
+
 static unsigned long no_fiq_insn;
 
 /* Default reacquire function
@@ -80,13 +85,16 @@ int show_fiq_list(struct seq_file *p, in
 void set_fiq_handler(void *start, unsigned int length)
 {
 #if defined(CONFIG_CPU_USE_DOMAINS)
-	memcpy((void *)0xffff001c, start, length);
+	void *base = (void *)0xffff0000;
 #else
-	memcpy(vectors_page + 0x1c, start, length);
+	void *base = vectors_page;
 #endif
-	flush_icache_range(0xffff001c, 0xffff001c + length);
+	unsigned offset = FIQ_OFFSET;
+
+	memcpy(base + offset, start, length);
+	flush_icache_range(0xffff0000 + offset, 0xffff0000 + offset + length);
 	if (!vectors_high())
-		flush_icache_range(0x1c, 0x1c + length);
+		flush_icache_range(offset, offset + length);
 }
 
 int claim_fiq(struct fiq_handler *f)
@@ -144,6 +152,7 @@ EXPORT_SYMBOL(disable_fiq);
 
 void __init init_FIQ(int start)
 {
-	no_fiq_insn = *(unsigned long *)0xffff001c;
+	unsigned offset = FIQ_OFFSET;
+	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
 	fiq_start = start;
 }


