Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab3HMGsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:48:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab3HMGdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 09/60] powerpc/tm: Fix context switching TAR, PPR and DSCR SPRs
Date: Mon, 12 Aug 2013 23:33:36 -0700
Message-Id: <20130813063333.197589457@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 28e61cc466d8daace4b0f04ba2b83e0bd68f5832 upstream.

If a transaction is rolled back, the Target Address Register (TAR), Processor
Priority Register (PPR) and Data Stream Control Register (DSCR) should be
restored to the checkpointed values before the transaction began.  Any changes
to these SPRs inside the transaction should not be visible in the abort
handler.

Currently Linux doesn't save or restore the checkpointed TAR, PPR or DSCR.  If
we preempt a processes inside a transaction which has modified any of these, on
process restore, that same transaction may be aborted we but we won't see the
checkpointed versions of these SPRs.

This adds checkpointed versions of these SPRs to the thread_struct and adds the
save/restore of these three SPRs to the treclaim/trechkpt code.

Without this if any of these SPRs are modified during a transaction, users may
incorrectly see a speculated SPR value even if the transaction is aborted.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/processor.h |    4 ++++
 arch/powerpc/kernel/asm-offsets.c    |    3 +++
 arch/powerpc/kernel/tm.S             |   20 ++++++++++++++++++++
 3 files changed, 27 insertions(+)

--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -247,6 +247,10 @@ struct thread_struct {
 	unsigned long	tm_orig_msr;	/* Thread's MSR on ctx switch */
 	struct pt_regs	ckpt_regs;	/* Checkpointed registers */
 
+	unsigned long	tm_tar;
+	unsigned long	tm_ppr;
+	unsigned long	tm_dscr;
+
 	/*
 	 * Transactional FP and VSX 0-31 register set.
 	 * NOTE: the sense of these is the opposite of the integer ckpt_regs!
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -139,6 +139,9 @@ int main(void)
 	DEFINE(THREAD_TM_TFHAR, offsetof(struct thread_struct, tm_tfhar));
 	DEFINE(THREAD_TM_TEXASR, offsetof(struct thread_struct, tm_texasr));
 	DEFINE(THREAD_TM_TFIAR, offsetof(struct thread_struct, tm_tfiar));
+	DEFINE(THREAD_TM_TAR, offsetof(struct thread_struct, tm_tar));
+	DEFINE(THREAD_TM_PPR, offsetof(struct thread_struct, tm_ppr));
+	DEFINE(THREAD_TM_DSCR, offsetof(struct thread_struct, tm_dscr));
 	DEFINE(PT_CKPT_REGS, offsetof(struct thread_struct, ckpt_regs));
 	DEFINE(THREAD_TRANSACT_VR0, offsetof(struct thread_struct,
 					 transact_vr[0]));
--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -224,6 +224,16 @@ dont_backup_fp:
 	std	r5, _CCR(r7)
 	std	r6, _XER(r7)
 
+
+	/* ******************** TAR, PPR, DSCR ********** */
+	mfspr	r3, SPRN_TAR
+	mfspr	r4, SPRN_PPR
+	mfspr	r5, SPRN_DSCR
+
+	std	r3, THREAD_TM_TAR(r12)
+	std	r4, THREAD_TM_PPR(r12)
+	std	r5, THREAD_TM_DSCR(r12)
+
 	/* MSR and flags:  We don't change CRs, and we don't need to alter
 	 * MSR.
 	 */
@@ -338,6 +348,16 @@ dont_restore_fp:
 	mtmsr	r6				/* FP/Vec off again! */
 
 restore_gprs:
+
+	/* ******************** TAR, PPR, DSCR ********** */
+	ld	r4, THREAD_TM_TAR(r3)
+	ld	r5, THREAD_TM_PPR(r3)
+	ld	r6, THREAD_TM_DSCR(r3)
+
+	mtspr	SPRN_TAR,	r4
+	mtspr	SPRN_PPR,	r5
+	mtspr	SPRN_DSCR,	r6
+
 	/* ******************** CR,LR,CCR,MSR ********** */
 	ld	r3, _CTR(r7)
 	ld	r4, _LINK(r7)


