Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbaIBEOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:14:52 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:34323 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaIBEOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:14:50 -0400
MIME-Version: 1.0
In-Reply-To: <53FFA54D.9000907@gmail.com>
References: <53FFA54D.9000907@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Sep 2014 22:14:29 -0600
Message-ID: <CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
Subject: Re: [PATCH] pci/probe: Enable CRS for Intel Haswell root ports
To: Rajat Jain <rajatxjain@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Linus (author of ad7edfe04908), Matthew (author of 07ff9220908c
from full history), Yinghai (author of 2f5d8e4ff947), Richard]

On Thu, Aug 28, 2014 at 3:55 PM, Rajat Jain <rajatxjain@gmail.com> wrote:
> The PCIe root port of the Intel Haswell CPU, has a behavior to endlessly
> retry the configuration cycles, if an endpoint responds with a CRS
> (Configuration Request Retry Status), and the "CRS Software Visibility"
> flag is not set at the root port. This results in a CPU hang, when the
> kernel tries to enumerate the device that responds with CRS.

Help me understand this.  I thought a config read of Vendor ID would see:

  - 0xffff if no device is present, or
  - 0x0001 if the device is present but not ready yet, and the OS
should retry the read.  This only happens when Software Visibility is
enabled.
  - Normal Vendor ID if device is present and ready.  If Software
Visibility is disabled (as it is in Linux today) and the endpoint
responds with CRS, the Root Complex may retry the config read
invisibly to software.

I suppose these retries are causing your hang, but since the device is
actually present, I would think the CPU would see a read that took a
very long time to complete, but that did eventually complete.  Is this
causing a CPU timeout?  Is the endpoint broken and returning CRS
endlessly?

> Please note that this root port behavior (of endless retries) is still
> compliant with PCIe spec as the spec leaves the behavior open to
> implementation, on how many retries to do if "CRS visibility flag" is
> not enabled and it receives a CRS. (Intel has chosen to retry indefinitely)
>
> Ref1:
> https://www.pcisig.com/specifications/pciexpress/ECN_CRS_Software_Visibility_No27.pdf
>
> Ref2:
> PCIe spec V3.0, pg119, pg127 for "Configuration Request Retry Status"
>
> Following CPUs are affected:
> http://ark.intel.com/products/codename/42174/Haswell#@All
>
> Thus we need to enable the CRS visibility flag for such root ports. The
> commit ad7edfe04908 ("[PCI] Do not enable CRS Software Visibility by
> default") suggests to maintain a whitelist of the systems for which CRS
> should be enabled. This patch does the same.

I'm not a fan of adding a whitelist for devices that work correctly.
I don't think that's a maintainable solution.  Since we haven't had
many systems yet that care about CRS, some kind of "enable CRS on
machines newer than X" might work.

>From Linus' email (https://lkml.org/lkml/2007/12/27/92), the only
detailed data I found was from Ciaran McCreesh
(https://lkml.org/lkml/2007/10/29/500).  That case is interesting
because RootCap claims CRSVisible is not supported, but RootCtl claims
it is enabled:

  00:04.0 PCI bridge: ATI Technologies Inc Unknown device 7934
(prog-if 00 [Normal decode])
      Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
      Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
          RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
CRSVisible+
          RootCap: CRSVisible-
  02:00.0 Ethernet controller: Unknown device 0001:8168 (rev 01)

The Linux code removed by ad7edfe04908 doesn't bother to check the
RootCap bit; it simply tries to set the RootCtl enable.  Per spec,
that would be safe because the RootCtl enable bit should be hardwired
to 0 if the Root Port doesn't implement the capability, but I can
imagine a hardware bug where CRSVisible is partly implemented and the
designer assumes it won't be used because he doesn't advertise that
it's supported.

I think you should add that RootCap test to your patch.  It would be
very interesting to test that on some of these machines where we found
problems.

> Note: Looking at the spec and reading about the CRS, IMHO the "CRS
> visibility" looks like a good thing to me that should always be enabled
> on the root ports that support it. And may be we should always enable
> it if supported and maintain a blacklist of devices on which should be
> disabled (because of known issues).
>
> How I stumbled upon this and tested the fix:
>
> Root port: PCI bridge: Intel Corporation Device 2f02 (rev 01)
>
> I have a PCIe endpoint (a PLX 8713 NT bridge) that will keep on responding
> with CRS for a long time when the kernel tries to enumerate the
> endpoint, trying to indicate that the device is not yet ready. This is
> because it needs some configuration over I2C in order to complete its
> reset sequence. This results in a CPU hang during enumeration.

Is the I2C configuration something the OS needs to do?  If so, I
suppose we will always get CRS after reset, and we'll always have to
wait for a timeout, then do that I2C configuration, then somehow try
to re-enumerate the device?  That seems like a broken usage model.  I
guess maybe the I2C configurator could initiate a rescan to sort of
patch things up, but it still seems wrong that we have the timeout and
generate a warning.

> I used this setup to fix and test this issue. After enabling the CRS
> visibility flag at the root port, I see that CPU moves on as expected
> declaring the following (instead of freezing):
>
> pci 0000:30:00.0 id reading try 50 times with interval 20 ms to get
> ffff0001

This message is from pci_bus_check_dev() (added by 2f5d8e4ff947).
pci_bus_read_dev_vendor_id() already has an internal timeout mechanism
with a message that makes sense.  I don't understand why we need
another one with a different, unintelligible, message in
pci_bus_check_dev().

> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> ---
> Hi Bjorn / folks,
>
> I had also saught suggestions on how this patch should be modelled.
> Please find a suggestive alternative here:
>
> https://lkml.org/lkml/2014/8/1/186
>
> Please let me know your thoughts.
>
> Thanks,
>
> Rajat
>
>
>
>
>  drivers/pci/probe.c |   28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index e3cf8a2..909ca75 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -740,6 +740,32 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
>  }
>  EXPORT_SYMBOL(pci_add_new_bus);
>
> +static const struct pci_device_id crs_whitelist[] = {
> +       { PCI_VDEVICE(INTEL, 0x2f00), },
> +       { PCI_VDEVICE(INTEL, 0x2f01), },
> +       { PCI_VDEVICE(INTEL, 0x2f02), },
> +       { PCI_VDEVICE(INTEL, 0x2f03), },
> +       { PCI_VDEVICE(INTEL, 0x2f04), },
> +       { PCI_VDEVICE(INTEL, 0x2f05), },
> +       { PCI_VDEVICE(INTEL, 0x2f06), },
> +       { PCI_VDEVICE(INTEL, 0x2f07), },
> +       { PCI_VDEVICE(INTEL, 0x2f08), },
> +       { PCI_VDEVICE(INTEL, 0x2f09), },
> +       { PCI_VDEVICE(INTEL, 0x2f0a), },
> +       { PCI_VDEVICE(INTEL, 0x2f0b), },
> +       { },
> +};
> +
> +static void pci_enable_crs(struct pci_dev *dev)
> +{
> +       /* Enable CRS Software visibility only for whitelisted systems */
> +       if (pci_is_pcie(dev) &&
> +           pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT &&
> +           pci_match_id(crs_whitelist, dev))
> +               pcie_capability_set_word(dev, PCI_EXP_RTCTL,
> +                                        PCI_EXP_RTCTL_CRSSVE);
> +}
> +
>  /*
>   * If it's a bridge, configure it and scan the bus behind it.
>   * For CardBus bridges, we don't scan behind as the devices will
> @@ -787,6 +813,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>         pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
>                               bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
>
> +       pci_enable_crs(dev);
> +
>         if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
>             !is_cardbus && !broken) {
>                 unsigned int cmax;
> --
> 1.7.9.5
>
