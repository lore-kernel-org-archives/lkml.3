Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3HVWh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:37:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3HVWhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:37:25 -0400
Subject: Patch "ARC: gdbserver breakage in Big-Endian configuration #1" has been added to the 3.10-stable tree
To: Vineet.Gupta1@synopsys.com, akolesov@synopsys.com,
        Anton.Kolesov@synopsys.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, noamc@ezchip.com, stable@vger.kernel.org,
        vgupta@synopsys.com
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 22 Aug 2013 15:37:24 -0700
In-Reply-To: <1376986091-30241-2-git-send-email-vgupta@synopsys.com>
Message-ID: <13772110441524@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ARC: gdbserver breakage in Big-Endian configuration #1

to the 3.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     arc-gdbserver-breakage-in-big-endian-configuration-1.patch
and it can be found in the queue-3.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From Vineet.Gupta1@synopsys.com  Thu Aug 22 15:32:58 2013
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Date: Tue, 20 Aug 2013 13:38:10 +0530
Subject: ARC: gdbserver breakage in Big-Endian configuration #1
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <noamc@ezchip.com>, <Anton.Kolesov@synopsys.com>, <linux-kernel@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Message-ID: <1376986091-30241-2-git-send-email-vgupta@synopsys.com>

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


Patches currently in stable-queue which might be from Vineet.Gupta1@synopsys.com are

queue-3.10/arc-gdbserver-breakage-in-big-endian-configuration-1.patch
queue-3.10/arc-gdbserver-breakage-in-big-endian-configuration-2.patch
