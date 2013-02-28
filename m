Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3B1AGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:06:53 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13631 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3B1AGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:06:52 -0500
Message-ID: <1362010005.2808.34.camel@lorien2>
Subject: [PATCH v2 1/4] pci: Add PCI_BUS_NUM() and PCI_DEVID() interfaces to
 return bus number and device id
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, bhelgaas@google.com
Cc: jiang.liu@huawei.com, shemminger@vyatta.com, paulmck@linux.vnet.ibm.com,
        linasvepstas@gmail.com, dhowells@redhat.com, davej@redhat.com,
        tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        wangyijing@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Wed, 27 Feb 2013 17:06:45 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci defines PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces, however,
it doesn't have interfaces to return PCI bus and PCI device id. Drivers
(AMD IOMMU, and AER) implement module specific definitions for PCI_BUS()
and AMD_IOMMU driver also has a module specific interface to calculate PCI
device id from bus number and devfn.

Add PCI_BUS_NUM and PCI_DEVID interfaces to return PCI bus number and PCI
device id respectively to avoid the need for duplicate definitions in other
modules. AER driver code and AMD IOMMU driver define PCI_BUS. AMD IOMMU driver
defines an interface to calculate device id from bus number, and devfn pair.

PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() interfaces are exported to user-space
via uapi/linux/pci.h. However, in the interest to keep the new interfaces as
kernel only and not export them to user-space unnecessarily, added them to
linux/pci.h instead.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 include/linux/pci.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 15472d6..95c105a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -35,6 +35,21 @@
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+/*
+ * The PCI interface treats multi-function devices as independent
+ * devices.  The slot/function address of each device is encoded
+ * in a single byte as follows:
+ *
+ *	7:3 = slot
+ *	2:0 = function
+ * PCI_DEVFN(), PCI_SLOT(), and PCI_FUNC() are defined uapi/linux/pci.h
+ * In the interest of not exposing interfaces to user-space unnecessarily,
+ * the following kernel only defines are being added here.
+ */
+#define PCI_DEVID(bus, devfn)  ((((u16)bus) << 8) | devfn)
+/* return bus from PCI devid = ((u16)bus_number) << 8) | devfn */
+#define PCI_BUS_NUM(x) (((x) >> 8) & 0xff)
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
-- 
1.7.9.5



