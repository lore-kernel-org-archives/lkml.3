Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaF3OlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:41:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40716 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753223AbaF3OlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:41:14 -0400
Date: Mon, 30 Jun 2014 10:41:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Chen, Alvin" <alvin.chen@intel.com>
cc: Jingoo Han <jg1.han@samsung.com>, David Laight <David.Laight@ACULAB.COM>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v3] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
In-Reply-To: <1404147960-17596-2-git-send-email-alvin.chen@intel.com>
Message-ID: <Pine.LNX.4.44L0.1406301029190.1550-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Chen, Alvin wrote:

> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000
> USB host controller, and the default value is 0x20 dwords. The in/out threshold
> can be programmed to 0x80 dwords (512 Bytes) to maximize the perfomrance,
> but only when isochronous/interrupt transactions are not initiated by the USB
> host controller. This patch is to reconfigure the packet buffer in/out
> threshold as maximal as possible to maximize the performance, and 0x7F dwords
> (508 Bytes) should be used because the USB host controller initiates
> isochronous/interrupt transactions.
> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>

This is getting a lot better.

> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..78f1622 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -35,11 +35,35 @@ static const char hcd_name[] = "ehci-pci";
>  #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
>  
>  /*-------------------------------------------------------------------------*/
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +}

Whether to put this test directly into ehci_pci_reset() or leave it as
a separate subroutine is up to you.  I don't care either way.

> +
> +/*
> +	* The offset of in/out threshold register is 0x84.
> +	* And it is the register of 'hostpc'
> +	* in memory-mapped EHCI controller.
> +*/

0x84 is the same as offset of the hostpc register in the Intel
Moorestown controller.  hostpc is not present in general EHCI 
controllers.

> +#define	intel_quark_x1000_insnreg01	hostpc
> +
> +/* The maximal ehci packet buffer size is 512 bytes */
> +#define INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE	512
> +
> +/* The threshold value set the register is in DWORD */
> +#define INTEL_QUARK_X1000_EHCI_THRESHOLD(size)	((size)/4u)
> +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT	16
> +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT	0
> +
>  /* called after powerup, by probe or system-pm "wakeup" */
>  static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  {
>  	int			retval;
> +	u32			val;
> +	u32			thr;
>  
>  	/* we expect static quirk code to handle the "extended capabilities"
>  	 * (currently just BIOS handoff) allowed starting with EHCI 0.96
> @@ -50,6 +74,22 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  	if (!retval)
>  		ehci_dbg(ehci, "MWI active\n");
>  
> +	/* Reset the threshold limit */
> +	if (is_intel_quark_x1000(pdev)) {
> +		/*
> +			* In order to support the isochronous/interrupt
> +			* transactions, 508 bytes should be used as
> +			* max threshold values to maximize the
> +			* performance
> +		*/
> +		thr = INTEL_QUARK_X1000_EHCI_THRESHOLD(
> +			INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE - 4
> +			);
> +		val = thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT |
> +				thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT;
> +		ehci_writel(ehci, val, ehci->regs->intel_quark_x1000_insnreg01);

I saw what other people told you about the original patch version, and 
I disagree with them.  It is not necessary to include a detailed 
calculation like this, it only makes the code harder to read.  It will 
be better to have a single #define with a comment explaining it, like 
this:

/* Maximum usable threshold value is 0x7f dwords for both IN and OUT */
#define INTEL_QUARK_X1000_EHCI_MAX_THRESHOLD	0x007f007f

Then here, just use INTEL_QUARK_X1000_EHCI_MAX_THRESHOLD instead of 
val.  The comment can simply say:

	/*
	 * For the Intel QUARK X1000, raise the I/O threshold to the 
	 * maximum usable value in order to improve performance.
	 */

Alan Stern

