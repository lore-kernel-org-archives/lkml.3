Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaF0Obv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:31:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35205 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752845AbaF0Obu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:31:50 -0400
Date: Fri, 27 Jun 2014 10:31:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Chen, Alvin" <alvin.chen@intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
In-Reply-To: <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
Message-ID: <Pine.LNX.4.44L0.1406271016280.875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, Chen, Alvin wrote:

> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000 USB host
> controller, and the default value is 0x20 dwords. The in/out threshold can be programmed
> to 0x80 dwords, but only when isochronous/interrupt transactions are not initiated by
> the USB host controller. This patch is to reconfigure the packet buffer in/out threshold
> as maximal as possible, and it is 0x7F dwords since the USB host controller initiates
> isochronous/interrupt transactions.

This is still incomplete.  _Why_ do you want to increase the threshold?  
Does it fix a problem?  Does it improve performance?

Also, the lines are too long.  They should be wrapped before 80 
columns.

> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
> changelog v2:
> *Change the function name from 'usb_is_intel_qrk' to 'usb_is_intel_quark_x1000'.
> *Move the functions 'usb_is_intel_quark_x1000' and 'usb_set_qrk_bulk_thresh'
>  from 'pci-quirks.c' to 'ehci-pci.c'.
> *Remove unnecessary kernel message in the function of 'usb_set_qrk_bulk_thresh'.
> *Remove 'unlikely' in the functions of 'ehci_pci_reinit'.
> *Add white space after 'if'.
> *Update the descriptions to make it more clearly.
> *Add Micros to avoid magic number.
> 
>  drivers/usb/host/ehci-pci.c |   45 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..ca29f34 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -35,6 +35,47 @@ static const char hcd_name[] = "ehci-pci";
>  #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
>  
>  /*-------------------------------------------------------------------------*/
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +static inline bool usb_is_intel_quark_x1000(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +
> +}

The "usb_" prefix in the name isn't needed, because this is a static 
routine.

> +
> +/* Register offset of in/out threshold */
> +#define EHCI_INSNREG01		    0x84
> +/* The maximal threshold is 0x80 Dword */
> +#define EHCI_MAX_THRESHOLD      0X80
> +/* Lower word is 'in' threshold, and higher word is 'out' threshold*/
> +#define EHCI_INSNREG01_THRESH \
> +	((EHCI_MAX_THRESHOLD - 1)<<16 | (EHCI_MAX_THRESHOLD - 1))

This looks a little peculiar, because someone reading the code would
expect you to use the maximal threshold.

Also the formatting isn't quite right.  There should be a space before 
the closing */ of a comment, and there should be spaces around the << 
operator.

> +static void usb_set_qrk_bulk_thresh(struct pci_dev *pdev)
> +{
> +	void __iomem *base, *op_reg_base;
> +	u8 cap_length;
> +	u32 val;
> +	u16 cmd;
> +
> +	if (!pci_resource_start(pdev, 0))
> +		return;
> +
> +	if (pci_read_config_word(pdev, PCI_COMMAND, &cmd)
> +		|| !(cmd & PCI_COMMAND_MEMORY))
> +		return;
> +
> +	base = pci_ioremap_bar(pdev, 0);
> +	if (base == NULL)
> +		return;
> +
> +	cap_length = readb(base);
> +	op_reg_base = base + cap_length;
> +
> +	val = EHCI_INSNREG01_THRESH;
> +	writel(val, op_reg_base + EHCI_INSNREG01);
> +
> +	iounmap(base);
> +}

This is much more complicted that it needs to be.  When this routine 
runs, the controller has already been memory-mapped.  All you need to 
do is:

	ehci_writel(ehci, EHCI_INSNREG01_THRESH,
			ehci->regs->insnreg01_thresh);

Since it's only one statement, you don't even need to put this in a
separate function.  It can go directly into ehci_pci_reinit().

Also, in include/linux/usb/ehci_defs.h, you'll have to add:

#define insnreg01_thresh	hostpc[0]

with an explanatory comment, near the definition of the HOSTPC 
register.

>  /* called after powerup, by probe or system-pm "wakeup" */
>  static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
> @@ -50,6 +91,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  	if (!retval)
>  		ehci_dbg(ehci, "MWI active\n");
>  
> +	/* Reset the threshold limit */
> +	if (usb_is_intel_quark_x1000(pdev))
> +		usb_set_qrk_bulk_thresh(pdev);
> +
>  	return 0;
>  }

Alan Stern

