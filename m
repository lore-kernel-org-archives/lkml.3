Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3IKF2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:28:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab3IKE5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:24 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=gr9EIj6Y8gcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=j7bzT6rKYqYA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=oej2A1Sdv-erdW-XwhwA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=sNZVxfKoEDRqcDjf:21 a=J1Mli8haGmSgdxkd:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042912.703921740@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [123/251] ARM: update FIQ support for relocation of vectors
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0123-ARM-update-FIQ-support-for-relocation-of-vectors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8 ]

FIQ should no longer copy the FIQ code into the user visible vector
page.  Instead, it should use the hidden page.  This change makes
that happen.

Cc: <stable@vger.kernel.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/entry-armv.S |    3 +++
 arch/arm/kernel/fiq.c        |   19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index c19779f..4c28aff 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1162,6 +1162,9 @@ vector_addrexcptn:
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
1.7.10.4


