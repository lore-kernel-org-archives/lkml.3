Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaF3Ijs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:39:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:51427 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaF3Ijq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:39:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="565910718"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH v2] USB: ehci-pci: USB host controller support for
 Intel Quark X1000
Thread-Index: AQHPkhSHzWiRva72R+WEYUnwzn5RX5uJV3Hw
Date: Mon, 30 Jun 2014 08:38:47 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9479EF@SHSMSX101.ccr.corp.intel.com>
References: <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
 <Pine.LNX.4.44L0.1406271016280.875-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406271016280.875-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The EHCI packet buffer in/out threshold is programmable for Intel
> > Quark X1000 USB host controller, and the default value is 0x20 dwords.
> > The in/out threshold can be programmed to 0x80 dwords, but only when
> > isochronous/interrupt transactions are not initiated by the USB host
> > controller. This patch is to reconfigure the packet buffer in/out
> > threshold as maximal as possible, and it is 0x7F dwords since the USB host
> controller initiates isochronous/interrupt transactions.
> 
> This is still incomplete.  _Why_ do you want to increase the threshold?
> Does it fix a problem?  Does it improve performance?
Try to set threshold as maximal as possible to maximize the performance. I will update the descriptions.

> Also, the lines are too long.  They should be wrapped before 80 columns.
Got you.
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +static inline bool usb_is_intel_quark_x1000(struct pci_dev *pdev) {
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +
> > +}
> 
> The "usb_" prefix in the name isn't needed, because this is a static routine.

OK, I will remove the 'usb_' prefix.



> > +static void usb_set_qrk_bulk_thresh(struct pci_dev *pdev) {
> > +	void __iomem *base, *op_reg_base;
> > +	u8 cap_length;
> > +	u32 val;
> > +	u16 cmd;
> > +
> > +	if (!pci_resource_start(pdev, 0))
> > +		return;
> > +
> > +	if (pci_read_config_word(pdev, PCI_COMMAND, &cmd)
> > +		|| !(cmd & PCI_COMMAND_MEMORY))
> > +		return;
> > +
> > +	base = pci_ioremap_bar(pdev, 0);
> > +	if (base == NULL)
> > +		return;
> > +
> > +	cap_length = readb(base);
> > +	op_reg_base = base + cap_length;
> > +
> > +	val = EHCI_INSNREG01_THRESH;
> > +	writel(val, op_reg_base + EHCI_INSNREG01);
> > +
> > +	iounmap(base);
> > +}
> 
> This is much more complicted that it needs to be.  When this routine runs, the
> controller has already been memory-mapped.  All you need to do is:
> 
> 	ehci_writel(ehci, EHCI_INSNREG01_THRESH,
> 			ehci->regs->insnreg01_thresh);
> 
> Since it's only one statement, you don't even need to put this in a separate
> function.  It can go directly into ehci_pci_reinit().
OK, I will remove ' usb_set_qrk_bulk_thresh', and change the code as the suggestions.

> Also, in include/linux/usb/ehci_defs.h, you'll have to add:
> 
> #define insnreg01_thresh	hostpc[0]
I will add it in ehci-pci.c instead of /linux/usb/ehci_defs.h, because it is not a generic micro, but just used for Intel Quark X1000.

> with an explanatory comment, near the definition of the HOSTPC register.
> 

