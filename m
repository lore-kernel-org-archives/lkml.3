Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3GXD4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:56:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3GXD4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:56:15 -0400
Date: Tue, 23 Jul 2013 20:55:33 -0700
From: tip-bot for Neil Horman <tipbot@zytor.com>
Message-ID: <tip-803075dba31c17af110e1d9a915fe7262165b213@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andrew.cooper3@citrix.com, joro@8bytes.org, jbeulich@suse.com,
        ddutile@redhat.com, malcolm.crossley@citrix.com, nhorman@tuxdriver.com,
        tglx@linutronix.de, prarit@redhat.com, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, joro@8bytes.org, andrew.cooper3@citrix.com,
        ddutile@redhat.com, malcolm.crossley@citrix.com, nhorman@tuxdriver.com,
        tglx@linutronix.de, prarit@redhat.com, dzickus@redhat.com
In-Reply-To: <1374059639-8631-1-git-send-email-nhorman@tuxdriver.com>
References: <1374059639-8631-1-git-send-email-nhorman@tuxdriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/iommu/vt-d:
  Expand interrupt remapping quirk to cover x58 chipset
Git-Commit-ID: 803075dba31c17af110e1d9a915fe7262165b213
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:55:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  803075dba31c17af110e1d9a915fe7262165b213
Gitweb:     http://git.kernel.org/tip/803075dba31c17af110e1d9a915fe7262165b213
Author:     Neil Horman <nhorman@tuxdriver.com>
AuthorDate: Wed, 17 Jul 2013 07:13:59 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 11:29:30 +0200

x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1374059639-8631-1-git-send-email-nhorman@tuxdriver.com
[ Small edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
