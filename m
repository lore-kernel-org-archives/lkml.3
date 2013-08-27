Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3H0BUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:20:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab3H0BHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Noam Camus <noamc@ezchip.com>, Anton Kolesov <akolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 05/74] ARC: gdbserver breakage in Big-Endian configuration #1
Date: Mon, 26 Aug 2013 18:08:03 -0700
Message-Id: <20130827010425.743028026@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

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
Tested-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/ptrace.h |    2 ++
 arch/arc/kernel/entry.S       |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

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
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -498,7 +498,7 @@ tracesys_exit:
 trap_with_param:
 
 	; stop_pc info by gdb needs this info
-	stw orig_r8_IS_BRKPT, [sp, PT_orig_r8]
+	st  orig_r8_IS_BRKPT, [sp, PT_orig_r8]
 
 	mov r0, r12
 	lr  r1, [efa]
@@ -723,7 +723,7 @@ not_exception:
 	; things to what they were, before returning from L2 context
 	;----------------------------------------------------------------
 
-	ldw  r9, [sp, PT_orig_r8]      ; get orig_r8 to make sure it is
+	ld   r9, [sp, PT_orig_r8]      ; get orig_r8 to make sure it is
 	brne r9, orig_r8_IS_IRQ2, 149f ; infact a L2 ISR ret path
 
 	ld r9, [sp, PT_status32]       ; get statu32_l2 (saved in pt_regs)


