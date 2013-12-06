Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab3LFW0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:26:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161171Ab3LFVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 3.12 70/83] iommu: Remove stack trace from broken irq remapping warning
Date: Fri,  6 Dec 2013 13:52:00 -0800
Message-Id: <20131206214646.563945194@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel_irq_remapping.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -525,12 +525,13 @@ static int __init intel_irq_remapping_su
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


