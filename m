Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaFLA61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:58:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFLA60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:58:26 -0400
Date: Wed, 11 Jun 2014 17:58:02 -0700
From: tip-bot for Jiri Kosina <tipbot@zytor.com>
Message-ID: <tip-eff50c347fcc8feeb8c1723c23c89aba67c60263@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jkosina@suse.cz, hpa@linux.intel.com
In-Reply-To: <alpine.LNX.2.00.1406102248490.1321@pobox.suse.cz>
References: <alpine.LNX.2.00.1406102248490.1321@pobox.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/smep:
  Be more informative when signalling an SMEP fault
Git-Commit-ID: eff50c347fcc8feeb8c1723c23c89aba67c60263
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eff50c347fcc8feeb8c1723c23c89aba67c60263
Gitweb:     http://git.kernel.org/tip/eff50c347fcc8feeb8c1723c23c89aba67c60263
Author:     Jiri Kosina <jkosina@suse.cz>
AuthorDate: Tue, 10 Jun 2014 22:49:31 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 11 Jun 2014 17:55:30 -0700

x86/smep: Be more informative when signalling an SMEP fault

If pagefault triggers due to SMEP triggering, it can't be really easily
distinguished from any other oops-causing pagefault, which might lead to quite
some confusion when trying to understand the reason for the oops.

Print an explanatory message in case the fault happened during instruction
fetch for _PAGE_USER page which is present and executable on SMEP-enabled CPUs.

This is consistent with what we are doing for NX already; in addition to
immediately seeing from the oops what might be happening, it can even easily
give a good indication to sysadmins who are carefully monitoring their kernel
logs that someone might be trying to pwn them.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1406102248490.1321@pobox.suse.cz
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/fault.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 858b47b..9de4cdb 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -575,6 +575,8 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 
 static const char nx_warning[] = KERN_CRIT
 "kernel tried to execute NX-protected page - exploit attempt? (uid: %d)\n";
+static const char smep_warning[] = KERN_CRIT
+"unable to execute userspace code (SMEP?) (uid: %d)\n";
 
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code,
@@ -595,6 +597,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
+		if (pte && pte_present(*pte) && pte_exec(*pte) &&
+				(pgd_flags(*pgd) & _PAGE_USER) &&
+				(read_cr4() & X86_CR4_SMEP))
+			printk(smep_warning, from_kuid(&init_user_ns, current_uid()));
 	}
 
 	printk(KERN_ALERT "BUG: unable to handle kernel ");
