Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162859Ab3DEUmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:42:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20083 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162655Ab3DEUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:42:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, hpa@zytor.com, konrad@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] x86/wakeup/sleep:  Use pvops functions for changing GDT entries.
Date: Fri,  5 Apr 2013 16:42:24 -0400
Message-Id: <1365194544-14648-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
References: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "konrad@kernel.org" <konrad@kernel.org>

We check the TSS descriptor before we try to dereference it.
Also we document what the value '9' actually means using the
AMD64 Architecture Programmer's Manual Volume 2, pg 90:
"Hex value 9: Available 64-bit TSS" and pg 91:
"The available 32-bit TSS (09h), which is redefined as the
available 64-bit TSS."

Without this, on Xen, where the GDT is available as R/O (to
protect the hypervisor from the guest modifying it), we end up
with a pagetable fault.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/power/cpu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 571176f..6d6e907 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -133,7 +133,10 @@ static void fix_processor_context(void)
 {
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
+#ifdef CONFIG_X86_64
+	struct desc_struct *desc = get_cpu_gdt_table(cpu);
+	tss_desc tss;
+#endif
 	set_tss_desc(cpu, t);	/*
 				 * This just modifies memory; should not be
 				 * necessary. But... This is necessary, because
@@ -142,7 +145,9 @@ static void fix_processor_context(void)
 				 */
 
 #ifdef CONFIG_X86_64
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+	memcpy(&tss, &desc[GDT_ENTRY_TSS], sizeof(tss_desc));
+	tss.type = 0x9; /* The available 64-bit TSS (see AMD vol 2, pg 91 */
+	write_gdt_entry(desc, GDT_ENTRY_TSS, &tss, DESC_TSS);
 
 	syscall_init();				/* This sets MSR_*STAR and related */
 #endif
-- 
1.8.1.4

