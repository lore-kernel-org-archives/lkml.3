Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab3GCTTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:19:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab3GCTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:09 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=MLwaGan4V8YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CSw8tP_EkO0A:10 a=wMNdZWldAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184109.853154786@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [139/141] powerpc: Fix missing/delayed calls to irq_work
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0139-powerpc-Fix-missing-delayed-calls-to-irq_work.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 230b3034793247f61e6a0b08c44cf415f6d92981 ]

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

CC: <stable@vger.kernel.org> [v3.4+]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/irq.c |    2 +-
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
1.7.10.4


