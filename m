Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab3IZNpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:45:09 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:59940 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3IZNpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:45:06 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet.Gupta1@synopsys.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        arc-linux-dev@synopsys.com
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH 1/2] ARC: Handle zero-overhead-loop in unaligned access handler
Date: Thu, 26 Sep 2013 15:44:56 +0200
Message-Id: <1380203096-5842-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a load or store is the last instruction in a zero-overhead-loop, and
it's misaligned, the loop would execute only once.

This fixes that problem.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/kernel/unaligned.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arc/kernel/unaligned.c b/arch/arc/kernel/unaligned.c
index c0f832f..00ad070 100644
--- a/arch/arc/kernel/unaligned.c
+++ b/arch/arc/kernel/unaligned.c
@@ -233,6 +233,12 @@ int misaligned_fixup(unsigned long address, struct pt_regs *regs,
 		regs->status32 &= ~STATUS_DE_MASK;
 	} else {
 		regs->ret += state.instr_len;
+
+		/* handle zero-overhead-loop */
+		if ((regs->ret == regs->lp_end) && (regs->lp_count)) {
+			regs->ret = regs->lp_start;
+			regs->lp_count--;
+		}
 	}
 
 	return 0;
-- 
1.7.9.5

