Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030466Ab3DSNlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:41:14 -0400
Received: from mout.gmx.net ([212.227.17.22]:58903 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030356Ab3DSNlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:41:13 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX1+yq1NV40ayS5fR0i1jwo3UDHKzloFEiJgzhBrF5H
	Zfwzt0VMW195nM
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: tglx@linutronix.de
Cc: zonque@gmail.com, linux-kernel@vger.kernel.org,
        Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH] genirq: use irq_mask as fallback for irq_disable.
Date: Fri, 19 Apr 2013 15:41:02 +0200
Message-Id: <1366378862-22359-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.7.10.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in line with irq_enable that uses the same fallback.
When masked, interrupts are still latched into the status register
so when unmasked there is an interrupt straight away.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 kernel/irq/chip.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cbd97ce..21f87b7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -216,10 +216,11 @@ void irq_enable(struct irq_desc *desc)
 void irq_disable(struct irq_desc *desc)
 {
 	irq_state_set_disabled(desc);
-	if (desc->irq_data.chip->irq_disable) {
+	if (desc->irq_data.chip->irq_disable)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
-		irq_state_set_masked(desc);
-	}
+	else
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	irq_state_set_masked(desc);
 }
 
 void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu)
-- 
1.7.10.4

