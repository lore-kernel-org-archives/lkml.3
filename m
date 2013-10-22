Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3JVQIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:08:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:12837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab3JVQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="415250074"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rusty@rustcorp.com.au
Subject: [PATCH 1/7] x86, asmlinkage, lguest: Pass in globals into assembler statement
Date: Tue, 22 Oct 2013 09:07:53 -0700
Message-Id: <1382458079-24450-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Tell the compiler that the inline assembler statement
references lguest_entry.

This fixes compile problems with LTO where the variable
and the assembler code may end up in different files.

Cc: x86@kernel.org
Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/lguest/x86/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 5169239..922a1ac 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -157,7 +157,7 @@ static void run_guest_once(struct lg_cpu *cpu, struct lguest_pages *pages)
 	 * stack, then the address of this call.  This stack layout happens to
 	 * exactly match the stack layout created by an interrupt...
 	 */
-	asm volatile("pushf; lcall *lguest_entry"
+	asm volatile("pushf; lcall *%4"
 		     /*
 		      * This is how we tell GCC that %eax ("a") and %ebx ("b")
 		      * are changed by this routine.  The "=" means output.
@@ -169,7 +169,9 @@ static void run_guest_once(struct lg_cpu *cpu, struct lguest_pages *pages)
 		      * physical address of the Guest's top-level page
 		      * directory.
 		      */
-		     : "0"(pages), "1"(__pa(cpu->lg->pgdirs[cpu->cpu_pgd].pgdir))
+		     : "0"(pages), 
+		       "1"(__pa(cpu->lg->pgdirs[cpu->cpu_pgd].pgdir)),
+		       "m"(lguest_entry)
 		     /*
 		      * We tell gcc that all these registers could change,
 		      * which means we don't have to save and restore them in
-- 
1.8.3.1

