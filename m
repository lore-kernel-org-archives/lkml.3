Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaBTHJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:09:51 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:59228 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaBTHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:09:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140219003523.GJ29304@obsidianresearch.com>
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
	<CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
	<20140219003523.GJ29304@obsidianresearch.com>
Date: Thu, 20 Feb 2014 12:39:48 +0530
X-Google-Sender-Auth: KSyzim-lcBYCv4T1mbhsrX4xrlE
Message-ID: <CA+mB=1KSxkN+mKce5k1n93pmAA_FnWYaqNweWzxd4GD3Mo4PZA@mail.gmail.com>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Srikanth Thokala <sthokal@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 6:05 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Tue, Feb 18, 2014 at 02:32:58PM -0700, Bjorn Helgaas wrote:
>> [+cc Arnd]
>>
>> On Sun, Feb 16, 2014 at 8:33 AM, Srikanth Thokala <sthokal@xilinx.com> wrote:
>> > This is the driver for Xilinx AXI PCIe Host Bridge Soft IP
>> >
>> > Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> > - Rebased on v3.14.0-rc2
>> >  .../devicetree/bindings/pci/xilinx-pcie.txt        |   43 +
>> >  drivers/pci/host/Kconfig                           |    7 +
>> >  drivers/pci/host/Makefile                          |    1 +
>> >  drivers/pci/host/pci-xilinx.c                      |  985 ++++++++++++++++++++
>> >  4 files changed, 1036 insertions(+)
>> >  create mode 100644 Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>> >  create mode 100644 drivers/pci/host/pci-xilinx.c
>> >
>> > diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>> > new file mode 100644
>> > index 0000000..66a2487
>> > +++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>> > @@ -0,0 +1,43 @@
>> > +* Xilinx AXI PCIe Root Port Bridge DT description
>> > +
>> > +Required properties:
>> > +- #address-cells: Address representation for root ports, set to <3>
>> > +- #size-cells: Size representation for root ports, set to <2>
>> > +- compatible: Should contain "xlnx,axi-pcie-1.00.a"
>> > +- reg: Should contain AXI PCIe registers location and length
>> > +- interrupts: Should contain AXI PCIe interrupt
>> > +- ranges: ranges for the PCI memory regions
>> > +       Please refer to the standard PCI bus binding document for a more
>> > +       detailed explanation
>> > +- xlnx,axibar-num: Number of memory regions configured in the hardware,
>> > +       maximum being three which is configurable in the hardware.
>> > +- xlnx,include-rc: Root Port (=1) or End Point (=0)
>> > +- xlnx,pciebar2axibar-0: Translation address from PCIe to AXI
>> > +       Only one PCIe BAR is applicable in Root port mode, it can be
>> > +       either 32/64-bit. If it is 64-bit BAR, lower 32 bits are present
>> > +       in 'xlnx,pciebar2axibar-0' and Upper 32 bits in 'xlnx,pciebar2
>> > +       axibar-1'. And if it is 32-bit BAR, only 'xlnx,pciebar2axibar-0'
>> > +       is valid
>> > +
>> > +Optional properties
>> > +- xlnx,pciebar-as: PCIe BAR aperture size is 32 (=0) or 64-bit (=1).
>> > +- xlnx,pciebar2axibar-1: Translation address from PCIe to AXI, contains
>> > +       upper 32 bits if PCIe BAR size is 64-bit. When xlnx,pciebar-as
>> > +       is set, this is a required property and should contain a valid
>> > +       value (other than FF's)
>>
>> I hardly know anything about DT, but xlnx,pciebar2axibar-0,
>> xlnx,pciebar-as, and xlnx,pciebar2axibar-1 look strange to me.  Is
>> that really the DT way of dealing with 32/64-bit BARs and host bridge
>> address translation?  I don't see similar things in the other files in
>> Documentation/devicetree/bindings/pci/, even though some of the other
>> drivers/pci/host/*.c files do use pci_add_resource_offset(), which
>> indicates that they support address translation.
>
> I agree Bjorn.
>
> These should use the standard ranges mechanism for translations and
> apertures.

This AXI PCIe bridge IP do have two kind of BARs AXI-to-PCIe BAR and
PCIe-to-AXI BAR.  The former specifies the AXI Base address and are the
memory windows, these are listed in the 'ranges' DT property.  The latter
BAR specifies the addresses that PCI Express should respond to/is
tallowed to write to and these addresses written to configuration space
during the initialization.

>
> Also, IMHO, only root ports should be supported in a host bridge
> driver. A PCI end point is something entirely different.

We are not supporting end point in this driver.  This is a soft IP and can be
configurable as a Root Port/End point while creating a HW design in the
FPGA.  So, the driver use this DT property to first check if it is
configured for
Root Port and bail out if it is not.

Srikanth

>
> I think with those two observations all the xlnx properties should go
> away.
>
> Thanks,
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
