Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbaGULl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:41:26 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:56522 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754785AbaGULlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:41:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAKb7zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCeGTBePSwcWhDAFil+oPGk
X-IPAS-Result: AjcBAKb7zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCeGTBePSwcWhDAFil+oPGk
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353641"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 3/3] x86: Check RFLAGS.RF on interrupt during REP-str
Date: Mon, 21 Jul 2014 14:39:54 +0300
Message-Id: <1405942794-22681-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
 <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel SDM states (17.3.1.1): "For any interrupt arriving after any iteration of
a repeated string instruction but the last iteration, the value pushed for RF
is 1." This test checks whether it is performed correctly.  Unfortunately,
there is no easy fix for this problem, since the hypervisor has no indication
whether any iteration was executed.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/eventinj.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/eventinj.c b/x86/eventinj.c
index 32de6f0..8fa4d84 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -54,6 +54,7 @@ static void flush_idt_page()
 
 static volatile unsigned int test_divider;
 static volatile int test_count;
+static volatile unsigned long rflags = 0;
 
 ulong stack_phys;
 void *stack_va;
@@ -190,6 +191,7 @@ static void tirq1(isr_regs_t *r)
 {
 	printf("irq1 running\n");
 	test_count++;
+	rflags = r->rflags;
 	eoi();
 }
 
@@ -208,6 +210,7 @@ int main()
 {
 	unsigned int res;
 	ulong *pt, *cr3, i;
+	unsigned char src[10], dst[10];
 
 	setup_vm();
 	setup_idt();
@@ -291,6 +294,19 @@ int main()
 	printf("After vec 32 and 33 to self\n");
 	report("vec 32/33", test_count == 2);
 
+	/* Inject HW interrupt on rep-movs and check RF */
+	test_count = 0;
+	flush_idt_page();
+	printf("Sending vec 33 to self\n");
+	apic_self_ipi(33);
+	io_delay();
+	irq_enable();
+	asm volatile("rep movsb\n" : :
+		"S"(src), "D"(dst), "c"(10) : "memory", "cc");
+	irq_disable();
+	printf("After vec 33 to self\n");
+	report("rflags.rf during rep movsb", test_count == 1 &&
+					     (rflags & (1<<16)));
 
 	/* Inject HW interrupt, do sti and than (while in irq shadow) inject
 	   soft interrupt. Fault during soft interrupt. Soft interrup shoud be
-- 
1.9.1

