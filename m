Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbaEMK1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:27:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933364AbaEMKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 141/182] ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe
Date: Tue, 13 May 2014 11:28:13 +0200
Message-Id: <398c9d05c58f7456e127b81a79a42d67c3e1f9a4.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arc/kernel/entry.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index b908dde8a331..15588b0611e9 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -610,11 +610,13 @@ resume_user_mode_begin:
 
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
1.9.3

