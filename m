Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbaGXJrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:47:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbaGXJrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/128] MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region
Date: Thu, 24 Jul 2014 10:44:43 +0100
Message-Id: <1406195177-8656-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit ab6c15bc6620ebe220970cc040b29bcb2757f373 upstream.

Previously, the lower limit for the MIPS SC initialization loop was
set incorrectly allowing one extra loop leading to writes
beyond the MSC ioremap'd space. More precisely, the value of the 'imp'
in the last loop increased beyond the msc_irqmap_t boundaries and
as a result of which, the 'n' variable was loaded with an incorrect
value. This value was used later on to calculate the offset in the
MSC01_IC_SUP which led to random crashes like the following one:

CPU 0 Unable to handle kernel paging request at virtual address e75c0200,
epc == 8058dba4, ra == 8058db90
[...]
Call Trace:
[<8058dba4>] init_msc_irqs+0x104/0x154
[<8058b5bc>] arch_init_irq+0xd8/0x154
[<805897b0>] start_kernel+0x220/0x36c

Kernel panic - not syncing: Attempted to kill the idle task!

This patch fixes the problem

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7118/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/kernel/irq-msc01.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/irq-msc01.c b/arch/mips/kernel/irq-msc01.c
index fab40f7d2e03..ac9facc08694 100644
--- a/arch/mips/kernel/irq-msc01.c
+++ b/arch/mips/kernel/irq-msc01.c
@@ -131,7 +131,7 @@ void __init init_msc_irqs(unsigned long icubase, unsigned int irqbase, msc_irqma
 
 	board_bind_eic_interrupt = &msc_bind_eic_interrupt;
 
-	for (; nirq >= 0; nirq--, imp++) {
+	for (; nirq > 0; nirq--, imp++) {
 		int n = imp->im_irq;
 
 		switch (imp->im_type) {
-- 
1.9.1

