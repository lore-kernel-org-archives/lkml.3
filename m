Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaJ1MGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:06:37 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:62044 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJ1MGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:06:35 -0400
Message-ID: <544F86C7.3060100@cogentembedded.com>
Date: Tue, 28 Oct 2014 15:06:31 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/19] PCI: Add quirk to prevent AMD NL USB3 DRD to
 bind with xHCI driver
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com> <1414497280-3126-19-git-send-email-ray.huang@amd.com>
In-Reply-To: <1414497280-3126-19-git-send-email-ray.huang@amd.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/28/2014 2:54 PM, Huang Rui wrote:

> The AMD Nolan (NL) SoC contains a DesignWare USB3 Dual-Role Device that can
> be operated either as a USB Host or a USB Device.  In the AMD NL platform,
> this device ([1022:7912]) has a class code of PCI_CLASS_SERIAL_USB_XHCI
> (0x0c0330), which means the xhci driver will claim it.

> But the dwc3 driver is a more specific driver for this device, and we'd
> prefer to use it instead of xhci.  To prevent xhci from claiming the
> device, change the class code to 0x0c03fe, which the PCI r3.0 spec defines
> as "USB device (not host controller)".  The dwc3 driver can then claim it
> based on its Vendor and Device ID.

> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jason Chang <jason.chang@amd.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>   drivers/pci/quirks.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)

> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 90acb32..1152bef 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -379,6 +379,26 @@ static void quirk_ati_exploding_mce(struct pci_dev *dev)
>   DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_exploding_mce);
>
>   /*
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
> +	/*
> +	 * Use 'USB Device' (0x0x03fe) instead of PCI header provided

     0x0c03fe, you mean?

> +	 */
> +	pdev->class = 0x0c03fe;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB,

    I'm not sure it was a good idea to declare the ID in pci_ids.h -- it's 
been long discouraged.

WBR, Sergei

