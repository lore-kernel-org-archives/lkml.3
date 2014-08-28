Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaH1VzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:55:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39575 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaH1VzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:55:11 -0400
Message-ID: <53FFA54D.9000907@gmail.com>
Date: Thu, 28 Aug 2014 14:55:25 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: rajatjain@juniper.net, groeck@juniper.net
Subject: [PATCH] pci/probe: Enable CRS for Intel Haswell root ports
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe root port of the Intel Haswell CPU, has a behavior to endlessly
retry the configuration cycles, if an endpoint responds with a CRS
(Configuration Request Retry Status), and the "CRS Software Visibility"
flag is not set at the root port. This results in a CPU hang, when the
kernel tries to enumerate the device that responds with CRS.

Please note that this root port behavior (of endless retries) is still
compliant with PCIe spec as the spec leaves the behavior open to
implementation, on how many retries to do if "CRS visibility flag" is
not enabled and it receives a CRS. (Intel has chosen to retry indefinitely)

Ref1:
https://www.pcisig.com/specifications/pciexpress/ECN_CRS_Software_Visibility_No27.pdf

Ref2:
PCIe spec V3.0, pg119, pg127 for "Configuration Request Retry Status"

Following CPUs are affected:
http://ark.intel.com/products/codename/42174/Haswell#@All

Thus we need to enable the CRS visibility flag for such root ports. The
commit ad7edfe04908 ("[PCI] Do not enable CRS Software Visibility by
default") suggests to maintain a whitelist of the systems for which CRS
should be enabled. This patch does the same.

Note: Looking at the spec and reading about the CRS, IMHO the "CRS
visibility" looks like a good thing to me that should always be enabled
on the root ports that support it. And may be we should always enable
it if supported and maintain a blacklist of devices on which should be
disabled (because of known issues).

How I stumbled upon this and tested the fix:

Root port: PCI bridge: Intel Corporation Device 2f02 (rev 01)

I have a PCIe endpoint (a PLX 8713 NT bridge) that will keep on responding
with CRS for a long time when the kernel tries to enumerate the
endpoint, trying to indicate that the device is not yet ready. This is
because it needs some configuration over I2C in order to complete its
reset sequence. This results in a CPU hang during enumeration.

I used this setup to fix and test this issue. After enabling the CRS
visibility flag at the root port, I see that CPU moves on as expected
declaring the following (instead of freezing):

pci 0000:30:00.0 id reading try 50 times with interval 20 ms to get
ffff0001

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
Hi Bjorn / folks,

I had also saught suggestions on how this patch should be modelled.
Please find a suggestive alternative here:

https://lkml.org/lkml/2014/8/1/186

Please let me know your thoughts.

Thanks,

Rajat




 drivers/pci/probe.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e3cf8a2..909ca75 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -740,6 +740,32 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 }
 EXPORT_SYMBOL(pci_add_new_bus);
 
+static const struct pci_device_id crs_whitelist[] = {
+	{ PCI_VDEVICE(INTEL, 0x2f00), },
+	{ PCI_VDEVICE(INTEL, 0x2f01), },
+	{ PCI_VDEVICE(INTEL, 0x2f02), },
+	{ PCI_VDEVICE(INTEL, 0x2f03), },
+	{ PCI_VDEVICE(INTEL, 0x2f04), },
+	{ PCI_VDEVICE(INTEL, 0x2f05), },
+	{ PCI_VDEVICE(INTEL, 0x2f06), },
+	{ PCI_VDEVICE(INTEL, 0x2f07), },
+	{ PCI_VDEVICE(INTEL, 0x2f08), },
+	{ PCI_VDEVICE(INTEL, 0x2f09), },
+	{ PCI_VDEVICE(INTEL, 0x2f0a), },
+	{ PCI_VDEVICE(INTEL, 0x2f0b), },
+	{ },
+};
+
+static void pci_enable_crs(struct pci_dev *dev)
+{
+	/* Enable CRS Software visibility only for whitelisted systems */
+	if (pci_is_pcie(dev) &&
+	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT &&
+	    pci_match_id(crs_whitelist, dev))
+		pcie_capability_set_word(dev, PCI_EXP_RTCTL,
+					 PCI_EXP_RTCTL_CRSSVE);
+}
+
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -787,6 +813,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
 
+	pci_enable_crs(dev);
+
 	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
 	    !is_cardbus && !broken) {
 		unsigned int cmax;
-- 
1.7.9.5

