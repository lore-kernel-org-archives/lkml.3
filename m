Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3G3PUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:20:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55387 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3G3PUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 31/75] x86, suspend: Handle CPUs which fail to #GP on RDMSR
Date: Tue, 30 Jul 2013 08:17:00 -0700
Message-Id: <1375197464-27962-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 5ff560fd48d5b3d82fa0c3aff625c9da1a301911 upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/acpi/sleep.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index d5e0d71..753dfaa 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -48,9 +48,20 @@ int acpi_suspend_lowlevel(void)
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
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
 
@@ -61,7 +72,10 @@ int acpi_suspend_lowlevel(void)
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
-- 
1.8.1.2

