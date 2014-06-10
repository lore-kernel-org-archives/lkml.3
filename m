Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaFJUte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:49:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbaFJUtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:49:33 -0400
Date: Tue, 10 Jun 2014 22:49:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, jroedel@suse.de
Subject: Re: [PATCH] x86: be more helpful with SMEP faults
In-Reply-To: <53976984.4030301@zytor.com>
Message-ID: <alpine.LNX.2.00.1406102248490.1321@pobox.suse.cz>
References: <alpine.LNX.2.00.1406102102030.1321@pobox.suse.cz> <20140610201823.GA29302@pd.tnic> <53976984.4030301@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, H. Peter Anvin wrote:

> >> @@ -594,6 +596,11 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
> >>  
> >>  		if (pte && pte_present(*pte) && !pte_exec(*pte))
> >>  			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
> >> +		if (pte && pte_present(*pte) && pte_exec(*pte) &&
> >> +				(pgd_flags(*pgd) & _PAGE_USER) &&
> >> +				static_cpu_has(X86_FEATURE_SMEP) &&
> > 
> > Btw, we could probably save us this line as CR4 reserved bits should be
> > Must-Be-Zero and setting any of those should #GP. And I'm talking about
> > pre-SMEP Intel, and AMD machines.
> > 
> > IOW, if CR4.SMEP is set, it definitely means SMEP is present and
> > enabled.
> > 
> > hpa, that true?
> 
> Yes.  Also, the Linux kernel will set or clear X86_FEATURE_SMEP to
> match, so the two are redundant.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v2] x86: be more helpful with SMEP faults

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
---
 arch/x86/mm/fault.c | 6 ++++++
 1 file changed, 6 insertions(+)

- v1 -> v2: removed redundant X86_FEATURE_SMEP check

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e57229..6f6b0e8 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -574,6 +574,8 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 
 static const char nx_warning[] = KERN_CRIT
 "kernel tried to execute NX-protected page - exploit attempt? (uid: %d)\n";
+static const char smep_warning[] = KERN_CRIT
+"unable to execute userspace code (SMEP?) (uid: %d)\n";
 
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code,
@@ -594,6 +596,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
+		if (pte && pte_present(*pte) && pte_exec(*pte) &&
+				(pgd_flags(*pgd) & _PAGE_USER) &&
+				(read_cr4() & X86_CR4_SMEP))
+			printk(smep_warning, from_kuid(&init_user_ns, current_uid()));
 	}
 
 	printk(KERN_ALERT "BUG: unable to handle kernel ");

-- 
Jiri Kosina
SUSE Labs
