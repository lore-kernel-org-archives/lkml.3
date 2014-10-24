Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbaJXQfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:35:36 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35098 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbaJXQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:35:33 -0400
Date: Fri, 24 Oct 2014 10:35:29 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Huang Rui <ray.huang@amd.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/16] pci: quirks: add quirk to avoid AMD NL to bind
 with xhci
Message-ID: <20141024163529.GA7075@google.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-3-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413536021-4886-3-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 04:53:27PM +0800, Huang Rui wrote:
> The dwc3 controller is the PCI-E device in AMD NL platform, but the class code
> of PCI header is 0x0c0330, the same with xHC. That's because it needs to meet
> the windows enviroment. The dwc3 controller acted as only host mode to bind with
> windows xhci driver.
> But on linux, sometimes, it would auto-bind with xhci driver as well (class code
> 0x0c0330) despite it uses Pid/Vid on dwc3 driver.

This changelog really doesn't make any sense unless the reader already
knows everything.  I think you mean something like this:

  The AMD NL (please explain what "NL" is; Google has no clue) SoC contains
  a DesignWare USB3 Dual-Role Device that can be operated either as a USB
  Host or a USB Device.  In the AMD NL platform, this device ([1022:7912])
  has a class code of PCI_CLASS_SERIAL_USB_XHCI (0x0c0330), which means the
  xhci driver will claim it.

  But the dwc3 driver is a more specific driver for this device, and we'd
  prefer to use it instead of xhci.  To prevent xhci from claiming the
  device, change the class code to 0x0c03fe, which the PCI r3.0 spec
  defines as "USB device (not host controller)".  The dwc3 driver can then
  claim it based on its Vendor and Device ID.

Obviously, this means the device won't work at all unless dwc3 is enabled.
Previously, it probably would work as a host controller with the xhci
driver.  I assume this change is what you want.

> Heikki suggested to use the quirk to fix this issue, and the detailed discussion
> is at below thread:
> http://marc.info/?l=linux-usb&m=141197934712824&w=2

This changelog needs to be wrapped so no line is longer than 75 characters.

Please run "git log --oneline --no-merges drivers/pci/quirks.c" and make
your subject line match the rest.  In particular, "PCI" (not "pci"), drop
the "quirks:" part, and capitalize "Add".

> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/pci/quirks.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 90acb32..3c911b7 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -378,6 +378,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
>  
> +/* FIXME should define in <linux/pci_ids.h> */
> +#define PCI_DEVICE_ID_AMD_NL	0x7912

If you KNOW this should be in linux/pci_ids.h (and it looks like it COULD
go there, since you do use the same definition in patch [01/16]), why don't
you just do it?  Why are you wasting our time reviewing trivial stuff like
this?

> +
> +/*
> + * AMD NL SoC 7912 PCI device is dwc3 controller, but the class code of PCI
> + * header is 0x0c0330, the same with xHC. That's because it need to meet the
> + * windows enviroment. The dwc3 controller acted as only host mode to bind with
> + * windows xhci driver. But on linux, sometimes, we auto-bind with xhci driver
> + * as well (class code 0x0c0330) despite we use Pid/Vid on dwc3 driver. So this
> + * quirk used a dummy class code to avoid to bind with xhci driver at booting
> + * phase.
> + */
> +static void quirk_amd_nl_class(struct pci_dev *pdev)
> +{
> +	/* Use a dummy class value instead of PCI header provided */

When you say "dummy class value," that makes it sound like you just chose
a random invalid value.  But this value is actually defined by the spec, so
you should use the description from the spec, namely, "USB device (not host
controller)".

Bjorn

> +	pdev->class = 0x0c03fe;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL,
> +		quirk_amd_nl_class);
> +
>  /*
>   * Let's make the southbridge information explicit instead
>   * of having to worry about people probing the ACPI areas,
> -- 
> 1.9.1
> 
