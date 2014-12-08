Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaLHTo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:44:27 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52278 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbaLHToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:44:23 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH 1/2] x86_64, switch_to: Load TLS descriptors before switching DS and ES
Date: Mon,  8 Dec 2014 11:44:14 -0800
Message-Id: <93c68f19444322b52fa1a5a81599361d026cfa8b.1418067750.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1418067750.git.luto@amacapital.net>
References: <cover.1418067750.git.luto@amacapital.net>
In-Reply-To: <cover.1418067750.git.luto@amacapital.net>
References: <cover.1418067750.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, if buggy user code points DS or ES into the TLS array,
they would be corrupted after a context switch.

----- begin test case -----

/*
 * Copyright (c) 2014 Andy Lutomirski
 * GPL v2
 */

static unsigned short GDT3(int idx)
{
	return (idx << 3) | 3;
}

static int create_tls(int idx, unsigned int base)
{
	struct user_desc desc = {
		.entry_number    = idx,
		.base_addr       = base,
		.limit           = 0xfffff,
		.seg_32bit       = 1,
		.contents        = 0, /* Data, grow-up */
		.read_exec_only  = 0,
		.limit_in_pages  = 1,
		.seg_not_present = 0,
		.useable         = 0,
	};

	if (syscall(SYS_set_thread_area, &desc) != 0)
		err(1, "set_thread_area");

	return desc.entry_number;
}

int main()
{
	int idx = create_tls(-1, 0);
	printf("Allocated GDT index %d\n", idx);

	unsigned short orig_es;
	asm volatile ("mov %%es,%0" : "=rm" (orig_es));

	int errors = 0;
	int total = 1000;
	for (int i = 0; i < total; i++) {
		asm volatile ("mov %0,%%es" : : "rm" (GDT3(idx)));
		usleep(100);

		unsigned short es;
		asm volatile ("mov %%es,%0" : "=rm" (es));
		asm volatile ("mov %0,%%es" : : "rm" (orig_es));
		if (es != GDT3(idx)) {
			if (errors == 0)
				printf("[FAIL]\tES changed from 0x%hx to 0x%hx\n",
				       GDT3(idx), es);
			errors++;
		}
	}

	if (errors) {
		printf("[FAIL]\tES was corrupted %d/%d times\n", errors, total);
		return 1;
	} else {
		printf("[OK]\tES was preserved\n");
		return 0;
	}
}

----- end test case -----

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/process_64.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3ed4a68d4013..e2efaa3473fa 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -288,19 +288,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	load_sp0(tss, next);
 
-	/*
-	 * Switch DS and ES.
-	 * This won't pick up thread selector changes, but I guess that is ok.
-	 */
-	savesegment(es, prev->es);
-	if (unlikely(next->es | prev->es))
-		loadsegment(es, next->es);
-
-	savesegment(ds, prev->ds);
-	if (unlikely(next->ds | prev->ds))
-		loadsegment(ds, next->ds);
-
-
 	/* We must save %fs and %gs before load_TLS() because
 	 * %fs and %gs may be cleared by load_TLS().
 	 *
@@ -309,17 +296,30 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	savesegment(fs, fsindex);
 	savesegment(gs, gsindex);
 
+	/*
+	 * Load TLS before restoring any segments so that segment loads
+	 * reference the correct GDT entries.
+	 */
 	load_TLS(next, cpu);
 
 	/*
-	 * Leave lazy mode, flushing any hypercalls made here.
-	 * This must be done before restoring TLS segments so
-	 * the GDT and LDT are properly updated, and must be
-	 * done before math_state_restore, so the TS bit is up
-	 * to date.
+	 * Leave lazy mode, flushing any hypercalls made here.  This
+	 * must be done after loading TLS entries in the GDT but before
+	 * loading segments that might reference them, and and it must
+	 * be done before math_state_restore, so the TS bit is up to
+	 * date.
 	 */
 	arch_end_context_switch(next_p);
 
+	/* Switch DS and ES. */
+	savesegment(es, prev->es);
+	if (unlikely(next->es | prev->es))
+		loadsegment(es, next->es);
+
+	savesegment(ds, prev->ds);
+	if (unlikely(next->ds | prev->ds))
+		loadsegment(ds, next->ds);
+
 	/*
 	 * Switch FS and GS.
 	 *
-- 
1.9.3

