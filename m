Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3F1S7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:59:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42023 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3F1S7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:59:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 051/105] powerpc: Fix missing/delayed calls to irq_work
Date: Fri, 28 Jun 2013 11:51:13 -0700
Message-Id: <1372445527-24414-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 71413f4..a58f4ca 100644
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

