Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaFZBQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:16:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:6661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbaFZBQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="450081001"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Index: Ac+PgeFF5BxdJArRXUevrLYTW6T4oQAj3wJQADH4evA=
Date: Thu, 26 Jun 2014 01:16:08 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E94729E@SHSMSX101.ccr.corp.intel.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
 <000301cf9012$49d34f70$dd79ee50$%han@samsung.com>
In-Reply-To: <000301cf9012$49d34f70$dd79ee50$%han@samsung.com>
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

> > This patch is to enable USB host controller for Intel Quark X1000. Add
> > pci quirks to adjust the packet buffer in/out threshold value, and
> > ensure EHCI packet buffer i/o threshold value is reconfigured to half.
> 
> Please add more detailed description. For example, why is it necessary to
> reconfigure the threshold value?
> 
This patch try to reconfigure the threshold value as maximal (0x7F DWord) as possible since the default value is just 0x20 DWord, and I will update the description.

> >
> > +
> > +#define EHCI_INSNREG01		0x84
> > +#define EHCI_INSNREG01_THRESH	0x007F007F	/* Threshold value */
> 
> What does this magic number mean?
> Would you make it more readable?
0x84 is the register offset, and the high word of '0x007F007F' is the out threshold and the low word is the in threshold. I will use some micros to make it more readable to avoid magic number in PATCH v2.



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
> As Alan Stern said, These INFO message are noisy.
> DEBUG level looks better.
These messages are not necessary, I will remove them.



> Best regards,
> Jingoo Han
> 
> > +
> > --
> > 1.7.9.5

