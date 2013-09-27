Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3I0Q4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:56:02 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49620 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3I0Qz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:55:59 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] iommu: Remove stack trace from broken irq remapping warning
Date: Fri, 27 Sep 2013 12:53:35 -0400
Message-Id: <1380300815-1864-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning for the irq remapping broken check in intel_irq_remapping.c is
pretty pointless.  We need the warning, but we know where its comming from, the
stack trace will always be the same, and it needlessly triggers things like
Abrt.  This changes the warning to just print a text warning about BIOS being
broken, without the stack trace, then sets the appropriate taint bit.  Since we
automatically disable irq remapping, theres no need to contiue making Abrt jump
at this problem

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/iommu/intel_irq_remapping.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f71673d..b97d70b 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -525,12 +525,13 @@ static int __init intel_irq_remapping_supported(void)
 	if (disable_irq_remap)
 		return 0;
 	if (irq_remap_broken) {
-		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
-			   "This system BIOS has enabled interrupt remapping\n"
-			   "on a chipset that contains an erratum making that\n"
-			   "feature unstable.  To maintain system stability\n"
-			   "interrupt remapping is being disabled.  Please\n"
-			   "contact your BIOS vendor for an update\n");
+		printk(KERN_WARNING
+			"This system BIOS has enabled interrupt remapping\n"
+			"on a chipset that contains an erratum making that\n"
+			"feature unstable.  To maintain system stability\n"
+			"interrupt remapping is being disabled.  Please\n"
+			"contact your BIOS vendor for an update\n");
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
 		disable_irq_remap = 1;
 		return 0;
 	}
-- 
1.8.3.1

