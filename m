Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3BDHKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:10:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:7996 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3BDHKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:10:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,597,1355126400"; 
   d="scan'208";a="252202691"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: rjw@sisk.pl, lenb@kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V2 2/3] ACPI: enable ACPI SCI during suspend
Date: Mon,  4 Feb 2013 15:10:10 +0800
Message-Id: <1359961811-978-2-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359961811-978-1-git-send-email-rui.zhang@intel.com>
References: <1359961811-978-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ACPI SCI during suspend so that SCI can be used
as wake events for PM_SUSPEND_FREEZE.

For S3/S4 transition,
We disable all GPEs in suspend_ops->prepare_late() to
fix a problem that GPEs may trigger SCI  before
arch_suspend_disable_irqs() is run.
So it is safe to leave the SCI enabled until
arch_suspend_irq_disable() is run.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3ff2678..3adeb10 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -787,7 +787,7 @@ acpi_os_install_interrupt_handler(u32 gsi, acpi_osd_handler handler,
 
 	acpi_irq_handler = handler;
 	acpi_irq_context = context;
-	if (request_irq(irq, acpi_irq, IRQF_SHARED, "acpi", acpi_irq)) {
+	if (request_irq(irq, acpi_irq, IRQF_SHARED | IRQF_NO_SUSPEND, "acpi", acpi_irq)) {
 		printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
 		acpi_irq_handler = NULL;
 		return AE_NOT_ACQUIRED;
-- 
1.7.9.5

