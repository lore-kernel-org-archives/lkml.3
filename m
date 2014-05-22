Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaEVWC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:02:27 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55706 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaEVWC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:02:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kernel: fadump.c:  Cleaning up inconsistent NULL checks
Date: Fri, 23 May 2014 00:03:16 +0200
Message-Id: <1400796196-12974-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up inconsistent NULL checks.
There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kernel/fadump.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 2230fd0..a76e7a4 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -645,7 +645,7 @@ static int __init fadump_build_cpu_notes(const struct fadump_mem_struct *fdm)
 		}
 		/* Lower 4 bytes of reg_value contains logical cpu id */
 		cpu = reg_entry->reg_value & FADUMP_CPU_ID_MASK;
-		if (!cpumask_test_cpu(cpu, &fdh->cpu_online_mask)) {
+		if (fdh && !cpumask_test_cpu(cpu, &fdh->cpu_online_mask)) {
 			SKIP_TO_NEXT_CPU(reg_entry);
 			continue;
 		}
@@ -662,9 +662,11 @@ static int __init fadump_build_cpu_notes(const struct fadump_mem_struct *fdm)
 	}
 	fadump_final_note(note_buf);
 
-	pr_debug("Updating elfcore header (%llx) with cpu notes\n",
+	if (fdh) {
+		pr_debug("Updating elfcore header (%llx) with cpu notes\n",
 							fdh->elfcorehdr_addr);
-	fadump_update_elfcore_header((char *)__va(fdh->elfcorehdr_addr));
+		fadump_update_elfcore_header((char *)__va(fdh->elfcorehdr_addr));
+	}
 	return 0;
 
 error_out:
-- 
1.7.10.4

