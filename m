Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaKLBf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:35:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637AbaKLBfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.17 301/319] powerpc: do_notify_resume can be called with bad thread_info flags argument
Date: Wed, 12 Nov 2014 10:17:19 +0900
Message-Id: <20141112011042.633206419@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/entry_64.S |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -659,7 +659,13 @@ _GLOBAL(ret_from_except_lite)
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


