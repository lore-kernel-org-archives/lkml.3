Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaEHQpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:45:32 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:10625
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755102AbaEHQpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:45:01 -0400
X-WSS-ID: 0N59L6E-07-DX6-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V4 3/4] ACPI/PCI: Warn if we have to "guess" host bridge node information
Date: Thu, 8 May 2014 11:44:20 -0500
Message-ID: <1399567461-15928-4-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(46034005)(199002)(189002)(33646001)(84676001)(2009001)(99396002)(80022001)(4396001)(50466002)(50226001)(68736004)(48376002)(97736001)(50986999)(64706001)(19580395003)(87286001)(62966002)(20776003)(19580405001)(76176999)(87936001)(83322001)(89996001)(83072002)(85852003)(53416003)(93916002)(575784001)(46102001)(86362001)(92566001)(86152002)(47776003)(21056001)(77982001)(101416001)(74662001)(77156001)(36756003)(81542001)(31966008)(76482001)(15975445006)(88136002)(44976005)(92726001)(79102001)(81342001)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB124;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <myron.stowe@redhat.com>

The vast majority of platforms are not supplying ACPI _PXM (proximity)
information corresponding to host bridge (PNP0A03/PNP0A08) devices
resulting in sysfs "numa_node" values of -1 (NUMA_NO_NODE) [1]:
  # for i in /sys/devices/pci0000\:00/*/numa_node; do cat $i; done | uniq
  -1

  # find /sys/ -name "numa_node" | while read fname; do cat $fname; \
    done | uniq
  -1

AMD based platforms provide a fall-back for this situation via amd_bus.c.
These platforms snoop out the information by directly reading specific
registers from the Northbridge and caching them via 'alloc_pci_root_info'.

Later during boot processing when host bridges are discovered -
'pci_acpi_scan_root' - the kernel looks for their corresponding ACPI _PXM
method - drivers/acpi/numa.c::acpi_get_node().  If the BIOS supplied a
_PXM method then that node (proximity) value is associated.  If the BIOS
did not supply a _PXM method *and* the platform is AMD based, the
fall-back cached values obtained directly from the Northbridge are used;
otherwise, "NUMA_NO_NODE" is associated.

There are a number of issues with this fall-back mechanism the most
notable being that amd_bus.c extracts a 3-bit number from a CPU register
and uses it as the node number.  The node numbers used by Linux are
logical and there's no reason they need to be identical to settings in the
CPU registers.  So if we have some node information obtained in the normal
way (from _PXM, SLIT, SRAT, etc.) and some from amd_bus.c, there's no
reason to believe they will be compatible.

This patch warns when this situation occurs:
  pci_root PNP0A08:00: [Firmware Bug]: no _PXM; falling back to node 0 from hardware (may be inconsistent with ACPI node numbers)

[1] https://bugzilla.kernel.org/show_bug.cgi?id=72051

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/x86/pci/acpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 01edac6..5075371 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -489,8 +489,12 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	}
 
 	node = acpi_get_node(device->handle);
-	if (node == NUMA_NO_NODE)
+	if (node == NUMA_NO_NODE) {
 		node = x86_pci_root_bus_node(busnum);
+		if (node != 0 && node != NUMA_NO_NODE)
+			dev_info(&device->dev, FW_BUG "no _PXM; falling back to node %d from hardware (may be inconsistent with ACPI node numbers)\n",
+				node);
+	}
 
 	if (node != NUMA_NO_NODE && !node_online(node))
 		node = NUMA_NO_NODE;
-- 
1.9.0

