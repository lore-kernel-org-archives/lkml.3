Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaF3Nnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:43:33 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:63205 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaF3Nna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:43:30 -0400
Message-ID: <53B1697E.8060708@cogentembedded.com>
Date: Mon, 30 Jun 2014 17:43:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Alvin" <alvin.chen@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Jingoo Han <jg1.han@samsung.com>, David Laight <David.Laight@ACULAB.COM>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v3] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
References: <1404147960-17596-1-git-send-email-alvin.chen@intel.com> <1404147960-17596-2-git-send-email-alvin.chen@intel.com>
In-Reply-To: <1404147960-17596-2-git-send-email-alvin.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/30/2014 09:06 PM, Chen, Alvin wrote:

> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>

> The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000
> USB host controller, and the default value is 0x20 dwords. The in/out threshold
> can be programmed to 0x80 dwords (512 Bytes) to maximize the perfomrance,
> but only when isochronous/interrupt transactions are not initiated by the USB
> host controller. This patch is to reconfigure the packet buffer in/out
> threshold as maximal as possible to maximize the performance, and 0x7F dwords
> (508 Bytes) should be used because the USB host controller initiates
> isochronous/interrupt transactions.

> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
> changelog v3:
> *Update the description to explain why set in/out threshold
>   as maximal as possible.
> *Improve the threshold value micros more readable.
> *Remove 'usb_set_qrk_bulk_thresh'.
> *Set threshold value by 'ehci_writel' instead of 'usb_set_qrk_bulk_thresh'.
> *Change the function name from 'usb_is_intel_quark_x1000'
>   to 'is_intel_quark_x1000'.

>   drivers/usb/host/ehci-pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)

> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..78f1622 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -35,11 +35,35 @@ static const char hcd_name[] = "ehci-pci";
>   #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
>
>   /*-------------------------------------------------------------------------*/
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +}

    Why not just put this check inline into ehci_pci_reinit()?

> +
> +/*
> +	* The offset of in/out threshold register is 0x84.
> +	* And it is the register of 'hostpc'
> +	* in memory-mapped EHCI controller.
> +*/

    The preferred multi-line kernel style is this:

/*
  * bla
  * bla
  */

> +#define	intel_quark_x1000_insnreg01	hostpc
> +
> +/* The maximal ehci packet buffer size is 512 bytes */

    s/ehci/EHCI/

> +#define INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE	512
> +
> +/* The threshold value set the register is in DWORD */
> +#define INTEL_QUARK_X1000_EHCI_THRESHOLD(size)	((size)/4u)
> +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT	16
> +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT	0
> +
>

    Too many empty lines...

>   /* called after powerup, by probe or system-pm "wakeup" */
>   static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>   {
>   	int			retval;
> +	u32			val;
> +	u32			thr;

    Why not declare these where they are used?

>
>   	/* we expect static quirk code to handle the "extended capabilities"
>   	 * (currently just BIOS handoff) allowed starting with EHCI 0.96
> @@ -50,6 +74,22 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>   	if (!retval)
>   		ehci_dbg(ehci, "MWI active\n");
>
> +	/* Reset the threshold limit */
> +	if (is_intel_quark_x1000(pdev)) {
> +		/*
> +			* In order to support the isochronous/interrupt
> +			* transactions, 508 bytes should be used as
> +			* max threshold values to maximize the
> +			* performance
> +		*/

    Same comment about the comment style...

> +		thr = INTEL_QUARK_X1000_EHCI_THRESHOLD(
> +			INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE - 4
> +			);
> +		val = thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT |
> +				thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT;

    Please surround << with spaces for consistency.

> +		ehci_writel(ehci, val, ehci->regs->intel_quark_x1000_insnreg01);
> +	}
> +
>   	return 0;
>   }

WBR, Sergei

