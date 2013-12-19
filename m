Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3LSMfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:35:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3LSL5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>, Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/208] iommu: Remove stack trace from broken irq remapping warning
Date: Thu, 19 Dec 2013 11:53:17 +0000
Message-Id: <1387454106-19326-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 05104a4e8713b27291c7bb49c1e7e68b4e243571 upstream.

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
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

