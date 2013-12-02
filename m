Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3LBU3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:29:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3LBTQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 004/212] ARM: 7876/1: clear Thumb-2 IT state on exception handling
Date: Mon,  2 Dec 2013 11:13:15 -0800
Message-Id: <20131202191249.054846148@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/entry-armv.S |    1 +
 arch/arm/mm/extable.c        |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

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
--- a/arch/arm/mm/extable.c
+++ b/arch/arm/mm/extable.c
@@ -9,8 +9,13 @@ int fixup_exception(struct pt_regs *regs
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


