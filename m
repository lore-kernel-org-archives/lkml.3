Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3HPWjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3HPWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Malcolm Crossley <malcolm.crossley@citrix.com>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 083/133] x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
Date: Fri, 16 Aug 2013 15:33:45 -0700
Message-Id: <1376692475-28413-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 803075dba31c17af110e1d9a915fe7262165b213 upstream.

Recently we added an early quirk to detect 5500/5520 chipsets
with early revisions that had problems with irq draining with
interrupt remapping enabled:

  commit 03bbcb2e7e292838bb0244f5a7816d194c911d62
  Author: Neil Horman <nhorman@tuxdriver.com>
  Date:   Tue Apr 16 16:38:32 2013 -0400

      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

It turns out this same problem is present in the intel X58
chipset as well. See errata 69 here:

  http://www.intel.com/content/www/us/en/chipsets/x58-express-specification-update.html

This patch extends the pci early quirk so that the chip
devices/revisions specified in the above update are also covered
in the same way:

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Malcolm Crossley <malcolm.crossley@citrix.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1374059639-8631-1-git-send-email-nhorman@tuxdriver.com
[ Small edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/early-quirks.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 94ab6b9..63bdb29 100644
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
 
@@ -239,6 +247,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
 	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	{ PCI_VENDOR_ID_INTEL, 0x3405, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{}
-- 
1.8.1.2

