Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3FRLpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:45:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab3FRLpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 89/93] powerpc: Fix missing/delayed calls to irq_work
Date: Tue, 18 Jun 2013 12:43:37 +0100
Message-Id: <1371555821-12820-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 230b3034793247f61e6a0b08c44cf415f6d92981 upstream.

When replaying interrupts (as a result of the interrupt occurring
while soft-disabled), in the case of the decrementer, we are exclusively
testing for a pending timer target. However we also use decrementer
interrupts to trigger the new "irq_work", which in this case would
be missed.

This change the logic to force a replay in both cases of a timer
boundary reached and a decrementer interrupt having actually occurred
while disabled. The former test is still useful to catch cases where
a CPU having been hard-disabled for a long time completely misses the
interrupt due to a decrementer rollover.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 1f017bb..86cb68e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(void)
 	 * in case we also had a rollover while hard disabled
 	 */
 	local_paca->irq_happened &= ~PACA_IRQ_DEC;
-	if (decrementer_check_overflow())
+	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
 		return 0x900;
 
 	/* Finally check if an external interrupt happened */
-- 
1.8.1.2

