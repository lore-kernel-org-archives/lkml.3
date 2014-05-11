Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbaEKT4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:56:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaEKTVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 27/83] ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe
Date: Sun, 11 May 2014 21:19:28 +0200
Message-Id: <20140511191910.756830473@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/entry.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

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


