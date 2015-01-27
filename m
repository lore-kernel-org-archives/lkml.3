Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbbA0Vqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:46:30 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:64624 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923AbbA0VqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:46:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Robert Richter <rric@kernel.org>, <oprofile-list@lists.sf.net>
Subject: [PATCH 8/9] MIPS: OProfile: Allow sharing IRQ with timer
Date: Tue, 27 Jan 2015 21:45:54 +0000
Message-ID: <1422395155-16511-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting the performance counter overflow interrupt, pass flags
which are compatible with the cevt-r4k driver, in particular
IRQF_SHARED so that the two handlers can share the same IRQ. This is
possible since release 2 of the architecture where there are separate
pending interrupt bits for the timer interrupt and the performance
counter interrupt.

This will be necessary since the FDC interrupt can also be arbitrarily
routed to a CPU interrupt, possibly sharing with the timer, the
performance counters, or both, and it isn't scalable to have all the
handlers able to call other handlers that may be on the same IRQ line.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Robert Richter <rric@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: oprofile-list@lists.sf.net
---
 arch/mips/oprofile/op_model_mipsxx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index 24729f023d93..d6b9e69e7c69 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -442,7 +442,10 @@ static int __init mipsxx_init(void)
 
 	if (perfcount_irq >= 0)
 		return request_irq(perfcount_irq, mipsxx_perfcount_int,
-			0, "Perfcounter", save_perf_irq);
+				   IRQF_PERCPU | IRQF_NOBALANCING |
+				   IRQF_NO_THREAD | IRQF_NO_SUSPEND |
+				   IRQF_SHARED,
+				   "Perfcounter", save_perf_irq);
 
 	return 0;
 }
-- 
2.0.5

