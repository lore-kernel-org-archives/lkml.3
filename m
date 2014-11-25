Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaKYKkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaKYKkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 008/254] powerpc: do_notify_resume can be called with bad thread_info flags argument
Date: Tue, 25 Nov 2014 10:35:58 +0000
Message-Id: <1416912004-5928-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 808be31426af57af22268ef0fcb42617beb3d15b upstream.

Back in 7230c5644188 ("powerpc: Rework lazy-interrupt handling") we
added a call out to restore_interrupts() (written in c) before calling
do_notify_resume:

        bl      restore_interrupts
        addi    r3,r1,STACK_FRAME_OVERHEAD
        bl      do_notify_resume

Unfortunately do_notify_resume takes two arguments, the second one
being the thread_info flags:

void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)

We do populate r4 (the second argument) earlier, but
restore_interrupts() is free to muck it up all it wants. My guess is
the gcc compiler gods shone down on us and its register allocator
never used r4. Sometimes, rarely, luck is on our side.

LLVM on the other hand did trample r4.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/entry_64.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 6528c5e2cc44..42c8e2d635e8 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -663,7 +663,13 @@ _GLOBAL(ret_from_except_lite)
 3:
 #endif
 	bl	save_nvgprs
+	/*
+	 * Use a non volatile GPR to save and restore our thread_info flags
+	 * across the call to restore_interrupts.
+	 */
+	mr	r30,r4
 	bl	restore_interrupts
+	mr	r4,r30
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_notify_resume
 	b	ret_from_except
-- 
2.1.0

