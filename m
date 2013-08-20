Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3HTIIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:08:49 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:35240 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3HTIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:08:45 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <noamc@ezchip.com>,
        <Anton.Kolesov@synopsys.com>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/2] ARC: gdbserver breakage in Big-Endian configuration #1
Date: Tue, 20 Aug 2013 13:38:10 +0530
Message-ID: <1376986091-30241-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376986091-30241-1-git-send-email-vgupta@synopsys.com>
References: <20130820062901.GA3758@kroah.com>
 <1376986091-30241-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Based on mainline commit 502a0c775c7f0a: "ARC: pt_regs update #5"]

gdbserver needs @stop_pc, served by ptrace, but fetched from pt_regs
differently, based on in_brkpt_traps(), which in turn relies on
additional machine state in pt_regs->event bitfield.

        unsigned long orig_r8:16, event:16;

For big endian config, this macro was returning false, despite being in
breakpoint Trap exception, causing wrong @stop_pc to be returned to gdb.

Issue #1: In BE, @event above is at offset 2 in word, while a STW insn
          at offset 0 was used to update it. Resort to using ST insn
	  which updates the half-word at right location.

Issue #2: The union involving bitfields causes all the members to be
	  laid out at offset 0. So with fix #1 above, ASM was now
	  updating at offset 2, "C" code was still referencing at
	  offset 0. Fixed by wrapping bitfield in a struct.

Reported-by: Noam Camus <noamc@ezchip.com>
Cc: <stable@vger.kernel.org> # [3.9 and 3.10 only]
Tested-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/ptrace.h | 2 ++
 arch/arc/kernel/entry.S       | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 6179de7..2046a89 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -52,12 +52,14 @@ struct pt_regs {
 
 	/*to distinguish bet excp, syscall, irq */
 	union {
+		struct {
 #ifdef CONFIG_CPU_BIG_ENDIAN
 		/* so that assembly code is same for LE/BE */
 		unsigned long orig_r8:16, event:16;
 #else
 		unsigned long event:16, orig_r8:16;
 #endif
+		};
 		long orig_r8_word;
 	};
 };
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 7b5f3ec..724de08 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -498,7 +498,7 @@ tracesys_exit:
 trap_with_param:
 
 	; stop_pc info by gdb needs this info
-	stw orig_r8_IS_BRKPT, [sp, PT_orig_r8]
+	st  orig_r8_IS_BRKPT, [sp, PT_orig_r8]
 
 	mov r0, r12
 	lr  r1, [efa]
@@ -727,7 +727,7 @@ not_exception:
 	; things to what they were, before returning from L2 context
 	;----------------------------------------------------------------
 
-	ldw  r9, [sp, PT_orig_r8]      ; get orig_r8 to make sure it is
+	ld   r9, [sp, PT_orig_r8]      ; get orig_r8 to make sure it is
 	brne r9, orig_r8_IS_IRQ2, 149f ; infact a L2 ISR ret path
 
 	ld r9, [sp, PT_status32]       ; get statu32_l2 (saved in pt_regs)
-- 
1.8.1.2

