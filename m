Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3I0K6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:58:16 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:65337 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3I0K6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:58:14 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: <arc-linux-dev@synopsys.com>, <u.kleine-koenig@pengutronix.de>,
        Noam Camus <noamc@ezchip.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/4] ARC: Handle zero-overhead-loop in unaligned access handler
Date: Fri, 27 Sep 2013 16:27:34 +0530
Message-ID: <1380279457-14299-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380279457-14299-1-git-send-email-vgupta@synopsys.com>
References: <1380279457-14299-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mischa Jonker <mjonker@synopsys.com>

If a load or store is the last instruction in a zero-overhead-loop, and
it's misaligned, the loop would execute only once.

This fixes that problem.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/unaligned.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arc/kernel/unaligned.c b/arch/arc/kernel/unaligned.c
index 28d1700..7ff5b5c 100644
--- a/arch/arc/kernel/unaligned.c
+++ b/arch/arc/kernel/unaligned.c
@@ -245,6 +245,12 @@ int misaligned_fixup(unsigned long address, struct pt_regs *regs,
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
1.8.1.2

