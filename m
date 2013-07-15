Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3GOU7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:59:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab3GOU7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:59:00 -0400
Date: Mon, 15 Jul 2013 13:58:18 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-5ff560fd48d5b3d82fa0c3aff625c9da1a301911@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        onny@project-insanity.org, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl, christian.suenkenberg@student.kit.edu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        onny@project-insanity.org, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl, christian.suenkenberg@student.kit.edu
In-Reply-To: <51DDC972.3010005@student.kit.edu>
References: <51DDC972.3010005@student.kit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, suspend:
  Handle CPUs which fail to #GP on RDMSR
Git-Commit-ID: 5ff560fd48d5b3d82fa0c3aff625c9da1a301911
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 15 Jul 2013 13:58:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ff560fd48d5b3d82fa0c3aff625c9da1a301911
Gitweb:     http://git.kernel.org/tip/5ff560fd48d5b3d82fa0c3aff625c9da1a301911
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 12 Jul 2013 16:48:12 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 15 Jul 2013 13:50:54 -0700

x86, suspend: Handle CPUs which fail to #GP on RDMSR

There are CPUs which have errata causing RDMSR of a nonexistent MSR to
not fault.  We would then try to WRMSR to restore the value of that
MSR, causing a crash.  Specifically, some Pentium M variants would
have this problem trying to save and restore the non-existent EFER,
causing a crash on resume.

Work around this by making sure we can write back the result at
suspend time.

Huge thanks to Christian Sünkenberg for finding the offending erratum
that finally deciphered the mystery.

Reported-and-tested-by: Johan Heinrich <onny@project-insanity.org>
Debugged-by: Christian Sünkenberg <christian.suenkenberg@student.kit.edu>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/51DDC972.3010005@student.kit.edu
Cc: <stable@vger.kernel.org> # v3.7+
---
 arch/x86/kernel/acpi/sleep.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 2a34aaf..3312010 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -48,9 +48,20 @@ int x86_acpi_suspend_lowlevel(void)
 #ifndef CONFIG_64BIT
 	native_store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
+	/*
+	 * We have to check that we can write back the value, and not
+	 * just read it.  At least on 90 nm Pentium M (Family 6, Model
+	 * 13), reading an invalid MSR is not guaranteed to trap, see
+	 * Erratum X4 in "Intel Pentium M Processor on 90 nm Process
+	 * with 2-MB L2 Cache and Intel® Processor A100 and A110 on 90
+	 * nm process with 512-KB L2 Cache Specification Update".
+	 */
 	if (!rdmsr_safe(MSR_EFER,
 			&header->pmode_efer_low,
-			&header->pmode_efer_high))
+			&header->pmode_efer_high) &&
+	    !wrmsr_safe(MSR_EFER,
+			header->pmode_efer_low,
+			header->pmode_efer_high))
 		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_EFER);
 #endif /* !CONFIG_64BIT */
 
@@ -61,7 +72,10 @@ int x86_acpi_suspend_lowlevel(void)
 	}
 	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
 			&header->pmode_misc_en_low,
-			&header->pmode_misc_en_high))
+			&header->pmode_misc_en_high) &&
+	    !wrmsr_safe(MSR_IA32_MISC_ENABLE,
+			header->pmode_misc_en_low,
+			header->pmode_misc_en_high))
 		header->pmode_behavior |=
 			(1 << WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE);
 	header->realmode_flags = acpi_realmode_flags;
