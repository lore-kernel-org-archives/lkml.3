Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaEUXSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:18:18 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:40959 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaEUXSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:18:13 -0400
Subject: [PATCH V5 2/4] x86/PCI: Work around AMD Fam15h BIOSes that fail to
 provide _PXM
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Robert Richter <rric@kernel.org>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        linux-pci@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Myron Stowe <myron.stowe@redhat.com>
Date: Wed, 21 May 2014 17:18:10 -0600
Message-ID: <20140521231810.26447.62482.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

The BIOS is supposed to provide ACPI _PXM methods for PCI host bridges if
it cares about platform topology.  But some BIOSes do not, so add Fam15h
to the list of CPUs for which we fall back to reading node numbers from the
hardware.

Note that pci_acpi_scan_root() warns about the BIOS bug if we use this
information because (1) the hardware node numbers are not necessarily
compatible with other logical node numbers from ACPI, and (2) the lack of
_PXM forces OS updates that would not otherwise be required.

[bhelgaas: changelog, comments]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=72051
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Robert Richter <rric@kernel.org>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>
---
 arch/x86/pci/amd_bus.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e88f4c53d7f6..aa936e3a2019 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -24,10 +24,11 @@ struct pci_hostbridge_probe {
 };
 
 static struct pci_hostbridge_probe pci_probes[] __initdata = {
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 }, /* K8 */
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 }, /* Fam10h */
+	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 }, /* Fam10h */
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 }, /* Fam11h */
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 }, /* Fam15h */
 };
 
 #define RANGE_NUM 16
@@ -96,6 +97,11 @@ static int __init early_fill_mp_bus_info(void)
 	if (!found)
 		return 0;
 
+	/*
+	 * We should learn topology and routing information from _PXM and
+	 * _CRS methods in the ACPI namespace.  We extract node numbers
+	 * here to work around BIOSes that don't supply _PXM.
+	 */
 	for (i = 0; i < 4; i++) {
 		int min_bus;
 		int max_bus;
@@ -113,6 +119,17 @@ static int __init early_fill_mp_bus_info(void)
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
 	}
 
+	/*
+	 * The following code extracts routing information for use on old
+	 * systems where Linux doesn't automatically use host bridge _CRS
+	 * methods (or when the user specifies "pci=nocrs").
+	 *
+	 * We only do this through Fam11h, because _CRS should be enough on
+	 * newer systems.
+	 */
+	if (boot_cpu_data.x86 > 0x11)
+		return 0;
+
 	/* get the default node and link for left over res */
 	reg = read_pci_config(bus, slot, 0, 0x60);
 	def_node = (reg >> 8) & 0x07;

