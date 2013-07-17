Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3GQLOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:14:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46022 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3GQLOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:14:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Jan Beulich <jbeulich@suse.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Malcolm Crossley <malcolm.crossley@citrix.com>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, stable@vger.kernel.org
Subject: [PATCH] iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
Date: Wed, 17 Jul 2013 07:13:59 -0400
Message-Id: <1374059639-8631-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373397069-8968-1-git-send-email-nhorman@tuxdriver.com>
References: <1373397069-8968-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently we added an early quirk to detect 5500/5520 chipsets with early
revisions that had problems with irq draining with interrupt remapping enabled:

commit 03bbcb2e7e292838bb0244f5a7816d194c911d62
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Tue Apr 16 16:38:32 2013 -0400

    iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

It turns out this same problem is present in the intel X58 chipset as well.  See
errata 69 here:
http://www.intel.com/content/www/us/en/chipsets/x58-express-specification-update.html

This patch extends the pci early quirk so that the chip devices/revisions
specified in the above update are also covered in the same way:

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
CC: Jan Beulich <jbeulich@suse.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Andrew Cooper <andrew.cooper3@citrix.com>
CC: Malcolm Crossley <malcolm.crossley@citrix.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Don Dutile <ddutile@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: stable@vger.kernel.org

---
Note, this a repost of this patch.  Don and I talked about this offline again,
and neither of us have been able to gather any information from intel on the
subject.  While I understand his point that we should try to get confirmation
about inclusive steppings that are affected by this errata, I feel like we
should commit this patch based on the documentation we do have, and we can
always ammend it later if Intel indicates other chips are affected.
---
 arch/x86/kernel/early-quirks.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 94ab6b9..743d583 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -196,15 +196,23 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 static void __init intel_remapping_check(int num, int slot, int func)
 {
 	u8 revision;
+	u16 device;
 
+	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
 
 	/*
-	 * Revision 0x13 of this chipset supports irq remapping
-	 * but has an erratum that breaks its behavior, flag it as such
+ 	 * Revision 13 of all triggering devices id in this quirk have
+	 * a problem draining interrupts when irq remapping is enabled,
+	 * and should be flagged as broken.  Additionally revisions 0x12
+	 * and 0x22 of device id 0x3405 has this problem.
 	 */
 	if (revision == 0x13)
 		set_irq_remapping_broken();
+	else if ((device == 0x3405) &&
+	    ((revision == 0x12) ||
+	     (revision == 0x22))) 
+		set_irq_remapping_broken();
 
 }
 
@@ -239,8 +247,11 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	{ PCI_VENDOR_ID_INTEL, 0x3405, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	
 	{}
 };
 
-- 
1.8.1.4

