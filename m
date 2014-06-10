Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaFJTIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaFJTIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:08:24 -0400
Date: Tue, 10 Jun 2014 21:08:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, bpetkov@suse.de,
        jroedel@suse.de
Subject: [PATCH] x86: be more helpful with SMEP faults
Message-ID: <alpine.LNX.2.00.1406102102030.1321@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pagefault happens due to SMEP triggering, it can't be really easily 
distinguished from any other oops-causing pagefault, which might lead to 
quite some confusion when trying to understand the reason for the oops.

Print an explanatory message in case the fault happened during instruction 
fetch for _PAGE_USER page which is present and executable on SMEP-enabled 
CPUs.

This is consistent with what we are doing for NX already; in addition to 
immediately seeing from the oops what might be happening, it can even 
easily give a good indication to sysadmins who are carefully monitoring 
their kernel logs that someone might be trying to pwn them.

Tested-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/mm/fault.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e57229..2466ced 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -574,6 +574,8 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 
 static const char nx_warning[] = KERN_CRIT
 "kernel tried to execute NX-protected page - exploit attempt? (uid: %d)\n";
+static const char smep_warning[] = KERN_CRIT
+"unable to execute userspace code (SMEP?) (uid: %d)\n";
 
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code,
@@ -594,6 +596,11 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
+		if (pte && pte_present(*pte) && pte_exec(*pte) &&
+				(pgd_flags(*pgd) & _PAGE_USER) &&
+				static_cpu_has(X86_FEATURE_SMEP) &&
+				(read_cr4() & X86_CR4_SMEP))
+			printk(smep_warning, from_kuid(&init_user_ns, current_uid()));
 	}
 
 	printk(KERN_ALERT "BUG: unable to handle kernel ");

-- 
Jiri Kosina
SUSE Labs
