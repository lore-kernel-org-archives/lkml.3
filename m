Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaH2EEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 00:04:31 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34854 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaH2EE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 00:04:29 -0400
Date: Fri, 29 Aug 2014 12:04:19 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, rajatjain@juniper.net,
        groeck@juniper.net
Subject: Re: [PATCH] pci/probe: Enable CRS for Intel Haswell root ports
Message-ID: <20140829040419.GA11664@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <53FFA54D.9000907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FFA54D.9000907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082904-5140-0000-0000-0000003846A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 02:55:25PM -0700, Rajat Jain wrote:
>The PCIe root port of the Intel Haswell CPU, has a behavior to endlessly
>retry the configuration cycles, if an endpoint responds with a CRS
>(Configuration Request Retry Status), and the "CRS Software Visibility"
>flag is not set at the root port. This results in a CPU hang, when the
>kernel tries to enumerate the device that responds with CRS.
>
>Please note that this root port behavior (of endless retries) is still
>compliant with PCIe spec as the spec leaves the behavior open to
>implementation, on how many retries to do if "CRS visibility flag" is
>not enabled and it receives a CRS. (Intel has chosen to retry indefinitely)
>
>Ref1:
>https://www.pcisig.com/specifications/pciexpress/ECN_CRS_Software_Visibility_No27.pdf
>
>Ref2:
>PCIe spec V3.0, pg119, pg127 for "Configuration Request Retry Status"
>
>Following CPUs are affected:
>http://ark.intel.com/products/codename/42174/Haswell#@All
>
>Thus we need to enable the CRS visibility flag for such root ports. The
>commit ad7edfe04908 ("[PCI] Do not enable CRS Software Visibility by
>default") suggests to maintain a whitelist of the systems for which CRS
>should be enabled. This patch does the same.
>
>Note: Looking at the spec and reading about the CRS, IMHO the "CRS
>visibility" looks like a good thing to me that should always be enabled
>on the root ports that support it. And may be we should always enable
>it if supported and maintain a blacklist of devices on which should be
>disabled (because of known issues).
>
>How I stumbled upon this and tested the fix:
>
>Root port: PCI bridge: Intel Corporation Device 2f02 (rev 01)
>
>I have a PCIe endpoint (a PLX 8713 NT bridge) that will keep on responding
>with CRS for a long time when the kernel tries to enumerate the
>endpoint, trying to indicate that the device is not yet ready. This is
>because it needs some configuration over I2C in order to complete its
>reset sequence. This results in a CPU hang during enumeration.
>
>I used this setup to fix and test this issue. After enabling the CRS
>visibility flag at the root port, I see that CPU moves on as expected
>declaring the following (instead of freezing):
>
>pci 0000:30:00.0 id reading try 50 times with interval 20 ms to get
>ffff0001
>
>Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
>Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>Signed-off-by: Guenter Roeck <groeck@juniper.net>
>---
>Hi Bjorn / folks,
>
>I had also saught suggestions on how this patch should be modelled.
>Please find a suggestive alternative here:
>
>https://lkml.org/lkml/2014/8/1/186
>
>Please let me know your thoughts.
>
>Thanks,
>
>Rajat
>
>
>
>
> drivers/pci/probe.c |   28 ++++++++++++++++++++++++++++
> 1 file changed, 28 insertions(+)
>
>diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>index e3cf8a2..909ca75 100644
>--- a/drivers/pci/probe.c
>+++ b/drivers/pci/probe.c
>@@ -740,6 +740,32 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
> }
> EXPORT_SYMBOL(pci_add_new_bus);
>
>+static const struct pci_device_id crs_whitelist[] = {
>+	{ PCI_VDEVICE(INTEL, 0x2f00), },
>+	{ PCI_VDEVICE(INTEL, 0x2f01), },
>+	{ PCI_VDEVICE(INTEL, 0x2f02), },
>+	{ PCI_VDEVICE(INTEL, 0x2f03), },
>+	{ PCI_VDEVICE(INTEL, 0x2f04), },
>+	{ PCI_VDEVICE(INTEL, 0x2f05), },
>+	{ PCI_VDEVICE(INTEL, 0x2f06), },
>+	{ PCI_VDEVICE(INTEL, 0x2f07), },
>+	{ PCI_VDEVICE(INTEL, 0x2f08), },
>+	{ PCI_VDEVICE(INTEL, 0x2f09), },
>+	{ PCI_VDEVICE(INTEL, 0x2f0a), },
>+	{ PCI_VDEVICE(INTEL, 0x2f0b), },
>+	{ },
>+};
>+
>+static void pci_enable_crs(struct pci_dev *dev)
>+{
>+	/* Enable CRS Software visibility only for whitelisted systems */
>+	if (pci_is_pcie(dev) &&
>+	    pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT &&
>+	    pci_match_id(crs_whitelist, dev))
>+		pcie_capability_set_word(dev, PCI_EXP_RTCTL,
>+					 PCI_EXP_RTCTL_CRSSVE);
>+}
>+
> /*
>  * If it's a bridge, configure it and scan the bus behind it.
>  * For CardBus bridges, we don't scan behind as the devices will
>@@ -787,6 +813,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
> 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
> 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
>
>+	pci_enable_crs(dev);
>+

Rajat,

I am not familiar with the CRS Software Visibility, but I think your code
could fix the problem.

While I have one tiny suggestion. I see the commit 
"ad7edfe04908 [PCI] Do not enable CRS Software Visibility by default" has the
pci_enable_crs() called in pci_scan_bridge(), while I think this may not be a
very good place for this fix.

How about have a early fixup for these intel devices? Since the original code
is called on each bridge, while this fix is just invoked on specific devices.
And sounds we are not planing to have this enabled by default in a short term.
If we have other devices to be in the white list in the future, we would expand
this list. This will make the probe.c not that generic. 

Hmm... to me, enable this in the eary fixup is a different stage as you did in
pci_scan_bridge(). Not sure enable them in a different stage will effect the 
behavior. If this matters, my suggestion is not a good one.

> 	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
> 	    !is_cardbus && !broken) {
> 		unsigned int cmax;
>-- 
>1.7.9.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Richard Yang
Help you, Help me

