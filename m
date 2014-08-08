Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbaHHVgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:36:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaHHVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 14/24] sparc64: Handle 32-bit tasks properly in compute_effective_address().
Date: Fri,  8 Aug 2014 14:35:07 -0700
Message-Id: <20140808213336.007759528@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213335.421758947@linuxfoundation.org>
References: <20140808213335.421758947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit d037d16372bbe4d580342bebbb8826821ad9edf0 ]

If we have a 32-bit task we must chop off the top 32-bits of the
64-bit value just as the cpu would.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/unaligned_64.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -163,17 +163,23 @@ static unsigned long *fetch_reg_addr(uns
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


