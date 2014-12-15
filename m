Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaLOT3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:29:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaLOT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:29:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 48/96] ARM: 8216/1: xscale: correct auxiliary register in suspend/resume
Date: Mon, 15 Dec 2014 11:26:08 -0800
Message-Id: <1418671616-25482-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit ef59a20ba375aeb97b3150a118318884743452a8 upstream.

According to the manuals I have, XScale auxiliary register should be
reached with opc_2 = 1 instead of crn = 1. cpu_xscale_proc_init
correctly uses c1, c0, 1 arguments, but cpu_xscale_do_suspend and
cpu_xscale_do_resume use c1, c1, 0. Correct suspend/resume functions to
also use c1, c0, 1.

The issue was primarily noticed thanks to qemu reporing "unsupported
instruction" on the pxa suspend path. Confirmed in PXA210/250 and PXA255
XScale Core manuals and in PXA270 and PXA320 Developers Guides.

Harware tested by me on tosa (pxa255). Robert confirmed on pxa270 board.

Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mm/proc-xscale.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index d19b1cf..b34b95f 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -535,7 +535,7 @@ ENTRY(cpu_xscale_do_suspend)
 	mrc	p15, 0, r5, c15, c1, 0	@ CP access reg
 	mrc	p15, 0, r6, c13, c0, 0	@ PID
 	mrc	p15, 0, r7, c3, c0, 0	@ domain ID
-	mrc	p15, 0, r8, c1, c1, 0	@ auxiliary control reg
+	mrc	p15, 0, r8, c1, c0, 1	@ auxiliary control reg
 	mrc	p15, 0, r9, c1, c0, 0	@ control reg
 	bic	r4, r4, #2		@ clear frequency change bit
 	stmia	r0, {r4 - r9}		@ store cp regs
@@ -552,7 +552,7 @@ ENTRY(cpu_xscale_do_resume)
 	mcr	p15, 0, r6, c13, c0, 0	@ PID
 	mcr	p15, 0, r7, c3, c0, 0	@ domain ID
 	mcr	p15, 0, r1, c2, c0, 0	@ translation table base addr
-	mcr	p15, 0, r8, c1, c1, 0	@ auxiliary control reg
+	mcr	p15, 0, r8, c1, c0, 1	@ auxiliary control reg
 	mov	r0, r9			@ control register
 	b	cpu_resume_mmu
 ENDPROC(cpu_xscale_do_resume)
-- 
1.9.1

