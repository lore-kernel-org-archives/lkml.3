Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965730Ab3HHNyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:54:39 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:39602 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965003Ab3HHNyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:54:36 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <stable@vger.kernel.org>
CC: <noamc@ezchip.com>, <Anton.Kolesov@synopsys.com>,
        <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/2] ARC: gdbserver breakage in Big-Endian configuration #1
Date: Thu, 8 Aug 2013 19:22:37 +0530
Message-ID: <1375969958-16454-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exception handling keeps additional state (whether exception was Trap
and if it was due to a breakpoint) in pt_regs->event, a bitfield member

        unsigned long orig_r8:16, event:16;

A bitfield esentially has an "offset" and a "length". What I wasn't
aware of was that, bitfields in a union loose the "offset" attribute
and all of them are laid out at offset 0.

This obviously means that both @event and @orig_r8 will be incorrectly
referenced to at same "0" offset by "C" generated code which is
certainly wrong, not because both members are accessed, but because asm
code updates it at different address.

In Little Endian config, @event is at offset 0 and @orig_r8 (not
actively used at all) clashing with it is OK. However in Big Endian
config,

	ST 0xNNNN_EEEE, [addr]

writes 0xEEEE to @event (offset 2 in memory) while "C" code references
it from 0.

Needless to say, this causes ptrace machinery to not detect the breakpoint
scenario (and incorrect stop_pc returned to gdbserver).

------>8---------------
Thi issue is already fixed in mainline 3.11 kernel as part of commit:
502a0c775c7f0a "ARC: pt_regs update #5"

However that patch has lot more changes than I would like backporting,
hence this seperate change.
------>8---------------

Reported-by: Noam Camus <noamc@ezchip.com>
Cc: <stable@vger.kernel.org> # [3.9 and 3.10 only]
Tested-by: Anton Kolesov <akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/ptrace.h | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
1.8.1.2

