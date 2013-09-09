Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3IISpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:45:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 01/24] ARM: update FIQ support for relocation of vectors
Date: Mon,  9 Sep 2013 11:44:51 -0700
Message-Id: <1378752314-2416-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8 upstream.

FIQ should no longer copy the FIQ code into the user visible vector
page.  Instead, it should use the hidden page.  This change makes
that happen.

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/entry-armv.S |  3 +++
 arch/arm/kernel/fiq.c        | 19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index f7488fd..5492d72 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1165,6 +1165,9 @@ vector_addrexcptn:
 vector_fiq:
 	subs	pc, lr, #4
 
+	.globl	vector_fiq_offset
+	.equ	vector_fiq_offset, vector_fiq
+
 	.section .vectors, "ax", %progbits
 __vectors_start:
 	W(b)	vector_rst
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 2adda11..25442f4 100644
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
@@ -80,13 +85,16 @@ int show_fiq_list(struct seq_file *p, int prec)
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
-- 
1.8.1.2

