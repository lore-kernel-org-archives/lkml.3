Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423077Ab3LFXVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:21:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423062Ab3LFXU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 064/152] ARM: 7876/1: clear Thumb-2 IT state on exception handling
Date: Fri,  6 Dec 2013 15:09:48 -0800
Message-Id: <1386371476-2477-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <Marc.Zyngier@arm.com>

commit e16b31bf47738f4498d7ce632e12d7d2a6a2492a upstream.

The exception handling code fails to clear the IT state, potentially
leading to incorrect execution of the fixup if the size of the IT
block is more than one.

Let fixup_exception do the IT sanitizing if a fixup has been found,
and restore CPSR from the stack when returning from a data abort.

Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/entry-armv.S | 1 +
 arch/arm/mm/extable.c        | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index a7de792..130ed1f 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -192,6 +192,7 @@ __dabt_svc:
 	svc_entry
 	mov	r2, sp
 	dabt_helper
+ THUMB(	ldr	r5, [sp, #S_PSR]	)	@ potentially updated CPSR
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__dabt_svc)
diff --git a/arch/arm/mm/extable.c b/arch/arm/mm/extable.c
index 9d28562..312e15e 100644
--- a/arch/arm/mm/extable.c
+++ b/arch/arm/mm/extable.c
@@ -9,8 +9,13 @@ int fixup_exception(struct pt_regs *regs)
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(instruction_pointer(regs));
-	if (fixup)
+	if (fixup) {
 		regs->ARM_pc = fixup->fixup;
+#ifdef CONFIG_THUMB2_KERNEL
+		/* Clear the IT state to avoid nasty surprises in the fixup */
+		regs->ARM_cpsr &= ~PSR_IT_MASK;
+#endif
+	}
 
 	return fixup != NULL;
 }
-- 
1.8.3.2

