Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaJ1NaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:30:04 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:59066 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaJ1NaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <1414497280-3126-19-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com> <1414497280-3126-19-git-send-email-ray.huang@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Oct 2014 07:29:39 -0600
Message-ID: <CAErSpo44qsS_PBaia+Hy86XPsuik_x+u-8Ec2M73j36f1KNzig@mail.gmail.com>
Subject: Re: [PATCH v3 18/19] PCI: Add quirk to prevent AMD NL USB3 DRD to
 bind with xHCI driver
To: Huang Rui <ray.huang@amd.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suggest a subject like this:

PCI: Prevent xHCI driver from claiming AMD Nolan USB3 DRD device

On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> The AMD Nolan (NL) SoC contains a DesignWare USB3 Dual-Role Device that can
> be operated either as a USB Host or a USB Device.  In the AMD NL platform,
> this device ([1022:7912]) has a class code of PCI_CLASS_SERIAL_USB_XHCI
> (0x0c0330), which means the xhci driver will claim it.
>
> But the dwc3 driver is a more specific driver for this device, and we'd
> prefer to use it instead of xhci.  To prevent xhci from claiming the
> device, change the class code to 0x0c03fe, which the PCI r3.0 spec defines
> as "USB device (not host controller)".  The dwc3 driver can then claim it
> based on its Vendor and Device ID.
>
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Please merge along with the rest of your series.

> Cc: Jason Chang <jason.chang@amd.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/pci/quirks.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 90acb32..1152bef 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -379,6 +379,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,     PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
>
>  /*
> + * In the AMD NL platform, this device ([1022:7912]) has a class code of
> + * PCI_CLASS_SERIAL_USB_XHCI (0x0c0330), which means the xhci driver will
> + * claim it.
> + * But the dwc3 driver is a more specific driver for this device, and we'd
> + * prefer to use it instead of xhci. To prevent xhci from claiming the
> + * device, change the class code to 0x0c03fe, which the PCI r3.0 spec
> + * defines as "USB device (not host controller)". The dwc3 driver can then
> + * claim it based on its Vendor and Device ID.
> + */
> +static void quirk_amd_nl_class(struct pci_dev *pdev)
> +{
> +       /*
> +        * Use 'USB Device' (0x0x03fe) instead of PCI header provided
> +        */
> +       pdev->class = 0x0c03fe;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB,
> +               quirk_amd_nl_class);
> +
> +/*
>   * Let's make the southbridge information explicit instead
>   * of having to worry about people probing the ACPI areas,
>   * for example.. (Yes, it happens, and if you read the wrong
> --
> 1.9.1
>
