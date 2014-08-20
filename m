Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaHTMDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:03:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58928 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/104] sparc64: Handle 32-bit tasks properly in compute_effective_address().
Date: Wed, 20 Aug 2014 13:43:09 +0200
Message-Id: <8f4cc46e28a981cc366800527ba35dd8c20bd505.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit d037d16372bbe4d580342bebbb8826821ad9edf0 ]

If we have a 32-bit task we must chop off the top 32-bits of the
64-bit value just as the cpu would.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/unaligned_64.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index 8201c25e7669..4db8898199f7 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -163,17 +163,23 @@ static unsigned long *fetch_reg_addr(unsigned int reg, struct pt_regs *regs)
 unsigned long compute_effective_address(struct pt_regs *regs,
 					unsigned int insn, unsigned int rd)
 {
+	int from_kernel = (regs->tstate & TSTATE_PRIV) != 0;
 	unsigned int rs1 = (insn >> 14) & 0x1f;
 	unsigned int rs2 = insn & 0x1f;
-	int from_kernel = (regs->tstate & TSTATE_PRIV) != 0;
+	unsigned long addr;
 
 	if (insn & 0x2000) {
 		maybe_flush_windows(rs1, 0, rd, from_kernel);
-		return (fetch_reg(rs1, regs) + sign_extend_imm13(insn));
+		addr = (fetch_reg(rs1, regs) + sign_extend_imm13(insn));
 	} else {
 		maybe_flush_windows(rs1, rs2, rd, from_kernel);
-		return (fetch_reg(rs1, regs) + fetch_reg(rs2, regs));
+		addr = (fetch_reg(rs1, regs) + fetch_reg(rs2, regs));
 	}
+
+	if (!from_kernel && test_thread_flag(TIF_32BIT))
+		addr &= 0xffffffff;
+
+	return addr;
 }
 
 /* This is just to make gcc think die_if_kernel does return... */
-- 
2.0.4

