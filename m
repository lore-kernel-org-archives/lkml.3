Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab3DKXDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:03:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761178Ab3DKXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:03:00 -0400
Date: Thu, 11 Apr 2013 16:02:48 -0700
From: "tip-bot for konrad@kernel.org" <tipbot@zytor.com>
Message-ID: <tip-4d681be3c33dd74efffbe2a8f70634f7128602ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, konrad@kernel.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, tglx@linutronix.de,
        rjw@sisk.pl, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, konrad@kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        tglx@linutronix.de, rjw@sisk.pl, hpa@linux.intel.com
In-Reply-To: <1365194544-14648-5-git-send-email-konrad.wilk@oracle.com>
References: <1365194544-14648-5-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86, wakeup, sleep:
  Use pvops functions for changing GDT entries
Git-Commit-ID: 4d681be3c33dd74efffbe2a8f70634f7128602ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 16:02:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d681be3c33dd74efffbe2a8f70634f7128602ec
Gitweb:     http://git.kernel.org/tip/4d681be3c33dd74efffbe2a8f70634f7128602ec
Author:     konrad@kernel.org <konrad@kernel.org>
AuthorDate: Fri, 5 Apr 2013 16:42:24 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 11 Apr 2013 15:41:15 -0700

x86, wakeup, sleep: Use pvops functions for changing GDT entries

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
Link: http://lkml.kernel.org/r/1365194544-14648-5-git-send-email-konrad.wilk@oracle.com
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/power/cpu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 82c39c5..168da84 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -132,7 +132,10 @@ static void fix_processor_context(void)
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
@@ -141,7 +144,9 @@ static void fix_processor_context(void)
 				 */
 
 #ifdef CONFIG_X86_64
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+	memcpy(&tss, &desc[GDT_ENTRY_TSS], sizeof(tss_desc));
+	tss.type = 0x9; /* The available 64-bit TSS (see AMD vol 2, pg 91 */
+	write_gdt_entry(desc, GDT_ENTRY_TSS, &tss, DESC_TSS);
 
 	syscall_init();				/* This sets MSR_*STAR and related */
 #endif
