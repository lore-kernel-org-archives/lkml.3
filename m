Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965709Ab3HHNzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:55:39 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:59822 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934208Ab3HHNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:55:36 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <stable@vger.kernel.org>
CC: <noamc@ezchip.com>, <Anton.Kolesov@synopsys.com>,
        <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 2/2] ARC: gdbserver breakage in Big-Endian configuration #2
Date: Thu, 8 Aug 2013 19:22:38 +0530
Message-ID: <1375969958-16454-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375969958-16454-1-git-send-email-vgupta@synopsys.com>
References: <1375969958-16454-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is related to how how different asm instructions write to a
bitfield member.

In BE config, @orig_r8 is at offset 0 while @event is at offset 2.

"ST 0xNNNN_EEEE, [addr]" correctly writes 0xEEEE to @event, however
a half word write, "STW 0xEEEE, [addr]" does not in Big Endian while
works perfectly file for LE config (since @event is at offset 0).

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
 arch/arc/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

