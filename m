Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3JRKNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:13:04 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:36504 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752744Ab3JRKNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:13:02 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2013 06:13:02 EDT
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, Vinayak Kale <vkale@apm.com>
Subject: [PATCH] genirq: error reporting for non-percpu interrupt in request_percpu_irq()
Date: Fri, 18 Oct 2013 15:36:29 +0530
Message-Id: <1382090789-18177-1-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a separate error code when a non-percpu interrupt is passed to
request_percpu_irq().

Suggested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Vinayak Kale <vkale@apm.com>
---
 kernel/irq/manage.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..c2713ae 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1671,10 +1671,12 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		return -EINVAL;
 
 	desc = irq_to_desc(irq);
-	if (!desc || !irq_settings_can_request(desc) ||
-	    !irq_settings_is_per_cpu_devid(desc))
+	if (!desc || !irq_settings_can_request(desc))
 		return -EINVAL;
 
+	if (!irq_settings_is_per_cpu_devid(desc))
+		return -EPERM;
+
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
-- 
1.7.9.5

