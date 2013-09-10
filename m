Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3IJQmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:42:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3IJQmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:42:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, takeuchi.akr@jp.panasonic.com,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mn10300: Fix crash just after starting userspace on !CONFIG_PREEMPT
Date: Tue, 10 Sep 2013 17:20:05 +0100
Message-ID: <13501.1378830005@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Kernel crashes just after starting userspace programs, if CONFIG_PREEMPT is
disabled.

  Freeing unused kernel memory: 96K (90286000 - 9029e000)
  MISALIGN: 97c33ff9: unsupported instruction f
  MISALIGN: 97c33ff9: unsupported instruction f
  MISALIGN: 97c33ff9: unsupported instruction f
  :

This commit fix the problem. It was introduced by the commit d17fc238ac14
(MN10300: Enable IRQs more in system call exit work path).

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/entry.S |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 222152a..177d61d 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -171,10 +171,10 @@ ret_from_intr:
 	mov	(REG_EPSW,fp),d0	# need to deliver signals before
 					# returning to userspace
 	and	EPSW_nSL,d0
-	beq	resume_kernel		# returning to supervisor mode
+	bne	resume_userspace	# returning to userspace
 
 #ifdef CONFIG_PREEMPT
-ENTRY(resume_kernel)
+resume_kernel:
 	LOCAL_IRQ_DISABLE
 	mov	(TI_preempt_count,a2),d0	# non-zero preempt_count ?
 	cmp	0,d0
@@ -189,6 +189,8 @@ need_resched:
 	bne	restore_all
 	call	preempt_schedule_irq[],0
 	jmp	need_resched
+#else
+	jmp	resume_kernel
 #endif
 
 
