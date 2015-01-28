Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097AbbA1EYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:40550 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965059AbbA1EYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:07 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 124/177] powerpc: do_notify_resume can be called with bad thread_info flags argument
Date: Wed, 28 Jan 2015 12:09:42 +0800
Message-Id: <1422418236-12852-215-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/powerpc/kernel/entry_64.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index e500969..c3fc39e 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -813,7 +813,13 @@ user_work:
 	b	.ret_from_except_lite
 
 1:	bl	.save_nvgprs
+	/*
+	 * Use a non volatile GPR to save and restore our thread_info flags
+	 * across the call to restore_interrupts.
+	 */
+	mr	r30,r4
 	bl	.restore_interrupts
+	mr	r4,r30
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	.do_notify_resume
 	b	.ret_from_except
-- 
1.9.1

