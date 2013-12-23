Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3LWQmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:42:35 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33077 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3LWQmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:42:33 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: traps: fix opcode endianness when read from user memory
Date: Mon, 23 Dec 2013 18:42:07 +0200
Message-Id: <1387816927-4313-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently code has an inverted logic: opcode from user memory
is swapped to a proper endianness only in case of read error.
While normally opcode should be swapped only if it was read
correctly from user memory.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/kernel/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 7940241..36a844e 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -425,9 +425,10 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
 			instr2 = __mem_to_opcode_thumb16(instr2);
 			instr = __opcode_thumb32_compose(instr, instr2);
 		}
-	} else if (get_user(instr, (u32 __user *)pc)) {
+	} else {
+		if (get_user(instr, (u32 __user *)pc))
+			goto die_sig;
 		instr = __mem_to_opcode_arm(instr);
-		goto die_sig;
 	}
 
 	if (call_undef_hook(regs, instr) == 0)
-- 
1.7.9.5

