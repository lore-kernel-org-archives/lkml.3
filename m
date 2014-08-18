Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaHRJg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaHRJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/137] sparc64: Handle 32-bit tasks properly in compute_effective_address().
Date: Mon, 18 Aug 2014 10:32:59 +0100
Message-Id: <1408354398-10226-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit d037d16372bbe4d580342bebbb8826821ad9edf0 upstream.

If we have a 32-bit task we must chop off the top 32-bits of the
64-bit value just as the cpu would.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

