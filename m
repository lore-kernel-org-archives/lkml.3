Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaD3J6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:58:09 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:46652 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaD3J6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:58:06 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, <arc-linux-dev@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, <stable@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: [PATCH] ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe
Date: Wed, 30 Apr 2014 15:26:45 +0530
Message-ID: <1398851805-10147-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a very small race window where resume to kernel mode from a
Exception Path (or pure kernel mode which is true for most of ARC
exceptions anyways), was not disabling interrupts in restore_regs,
clobbering the exception regs

Anton found the culprit call flow (after many sleepless nights)

| 1. we got a Trap from user land
| 2. started to service it.
| 3. While doing some stuff on user-land memory (I think it is padzero()),
|     we got a DataTlbMiss
| 4. On return from it we are taking "resume_kernel_mode" path
| 5. NEED_RESHED is not set, so we go to "return from exception" path in
|     restore regs.
| 6. there seems to be IRQ happening

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: <stable@vger.kernel.org>   #3.10, 3.12, 3.13, 3.14
Cc: Anton Kolesov <Anton.Kolesov@synopsys.com>
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
---
 arch/arc/kernel/entry.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 819dd5f7eb05..29b82adbf0b4 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -614,11 +614,13 @@ resume_user_mode_begin:
 
 resume_kernel_mode:
 
-#ifdef CONFIG_PREEMPT
-
-	; This is a must for preempt_schedule_irq()
+	; Disable Interrupts from this point on
+	; CONFIG_PREEMPT: This is a must for preempt_schedule_irq()
+	; !CONFIG_PREEMPT: To ensure restore_regs is intr safe
 	IRQ_DISABLE	r9
 
+#ifdef CONFIG_PREEMPT
+
 	; Can't preempt if preemption disabled
 	GET_CURR_THR_INFO_FROM_SP   r10
 	ld  r8, [r10, THREAD_INFO_PREEMPT_COUNT]
-- 
1.8.3.2

