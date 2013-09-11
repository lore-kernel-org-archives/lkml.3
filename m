Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3IKFjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:39:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3IKE5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:16 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=h3jhJEscC8wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YMxImB4VbhIA:10 a=vmLDa1wCAAAA:8 a=QyXUC8HyAAAA:8 a=iox4zFpeAAAA:8 a=20KFwNOVAAAA:8 a=tA7aZXjiAAAA:8 a=tHz9FfFoAAAA:8 a=VwQbUJbxAAAA:8 a=Jj8e7MOrIgyRfe2jykwA:9 a=swZZ4HxajxcA:10 a=gv_BBZfBKR8A:10 a=n9GBPR9yFnkA:10 a=jEp0ucaQiEUA:10 a=qM0ISud-tAQA:10 a=6O0IECtVFhoA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=uKUZYumxWQRgBHFT:21 a=1sFwl8HfWKWMgBAf:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042918.360610115@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Jan Beulich <jbeulich@suse.com>,
        Donald Dutile <ddutile@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Malcolm Crossley <malcolm.crossley@citrix.com>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [156/251] x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58
 chipset
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0156-x86-iommu-vt-d-Expand-interrupt-remapping-quirk-to-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 803075dba31c17af110e1d9a915fe7262165b213 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Small edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/early-quirks.c |   14 ++++++++++++--
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
1.7.10.4


