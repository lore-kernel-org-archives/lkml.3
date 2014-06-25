Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaFYJWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:22:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:28043 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaFYJWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:22:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="560659894"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Index: AQHPj6ks5BxdJArRXUevrLYTW6T4oZuBb7PQ
Date: Wed, 25 Jun 2014 09:22:18 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E946EBC@SHSMSX101.ccr.corp.intel.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
 <53A9713A.3020202@cogentembedded.com>
In-Reply-To: <53A9713A.3020202@cogentembedded.com>
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

See my comments below:

> > +	/* Reset the threshold limit */
> > +	if(unlikely(usb_is_intel_qrk(pdev)))
> 
>     Please run your patch thru scripts/checkpatch.pl -- space needed after
> *if*.
OK, I will improve it in the PATCH v2.

> 
> > +		usb_set_qrk_bulk_thresh(pdev);
> > +
> >   	return 0;
> >   }
> >
> > diff --git a/drivers/usb/host/pci-quirks.c
> > b/drivers/usb/host/pci-quirks.c index 00661d3..1ea8803 100644
> > --- a/drivers/usb/host/pci-quirks.c
> > +++ b/drivers/usb/host/pci-quirks.c
> > @@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask,
> u32 done,
> >   	return -ETIMEDOUT;
> >   }
> >
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +bool usb_is_intel_qrk(struct pci_dev *pdev) {
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(usb_is_intel_qrk);
> 
>     Why not use DECLARE_PCI_FIXUP_FINAL() instead?
> 
Alan Stern suggests me to move 'usb_is_intel_qrk' and 'usb_set_qrk_bulk_thresh' to ehci-pci.c. 
Since no other modules call these two functions, I will move them to ehci-pci.c as static functions, so no necessary to export them out.

> > +
> > +#define EHCI_INSNREG01		0x84
> > +#define EHCI_INSNREG01_THRESH	0x007F007F	/* Threshold value */
> > +void usb_set_qrk_bulk_thresh(struct pci_dev *pdev) {
> > +	void __iomem *base, *op_reg_base;
> > +	u8 cap_length;
> > +	u32 val;
> > +
> > +	if (!mmio_resource_enabled(pdev, 0))
> > +		return;
> > +
> > +	base = pci_ioremap_bar(pdev, 0);
> > +	if (base == NULL)
> > +		return;
> > +
> > +	cap_length = readb(base);
> > +	op_reg_base = base + cap_length;
> > +
> > +	val = readl(op_reg_base + EHCI_INSNREG01);
> > +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
> > +
> > +	val = EHCI_INSNREG01_THRESH;
> > +
> > +	writel(val, op_reg_base + EHCI_INSNREG01);
> > +
> > +	val = readl(op_reg_base + EHCI_INSNREG01);
> > +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
> 
>     I doubt these dev_printk() calls are really useful. But if the are, it's worth
> merging them into one call.
Actually, the dev_printk calls is not necessary, I will remove them in the PATCH v2.

> 
> WBR, Sergei

