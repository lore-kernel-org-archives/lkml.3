Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaFJTt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:49:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaFJTtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:49:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vineet Gupta <vgupta@synopsys.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 121/160] ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe
Date: Tue, 10 Jun 2014 12:46:01 -0700
Message-Id: <1402429600-20477-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

commit 8aa9e85adac609588eeec356e5a85059b3b819ba upstream.

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
Cc: Anton Kolesov <Anton.Kolesov@synopsys.com>
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arc/kernel/entry.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 47d09d0..6e8f83a 100644
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
1.9.1

