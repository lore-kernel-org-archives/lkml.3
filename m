Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaF0HQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:16:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:33087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbaF0HQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:16:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,558,1400050800"; 
   d="scan'208";a="450641095"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>,
        "'David Laight'" <David.Laight@ACULAB.COM>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH v2] USB: ehci-pci: USB host controller support for
 Intel Quark X1000
Thread-Index: Ac+Rt9/9zWiRva72R+WEYUnwzn5RXwABGaNAAAEzYAAABUzvEA==
Date: Fri, 27 Jun 2014 07:15:46 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9475E6@SHSMSX101.ccr.corp.intel.com>
References: <1403868276-12558-1-git-send-email-alvin.chen@intel.com>
 <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
 <000401cf91c0$e3a98600$aafc9200$%han@samsung.com>
 <000601cf91c1$5d25fcc0$1771f640$%han@samsung.com>
In-Reply-To: <000601cf91c1$5d25fcc0$1771f640$%han@samsung.com>
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


> > > The EHCI packet buffer in/out threshold is programmable for Intel
> > > Quark X1000 USB host controller, and the default value is 0x20
> > > dwords. The in/out threshold can be programmed to 0x80 dwords, but
> > > only when isochronous/interrupt transactions are not initiated by
> > > the USB host controller. This patch is to reconfigure the packet
> > > buffer in/out threshold as maximal as possible, and it is 0x7F dwords since
> the USB host controller initiates isochronous/interrupt transactions.
> >
> > So, what is the reason to set the value as 0x80?
> >   1. The default value 0x20 makes some problems such as...
> >   2. To maximize the performance, ...
> >   3. Both
> > Please add the reason why 0x80 is necessary, as possible.
> >
> > Then, 0x7F means 508 bytes? 'Intel Quark X1000 USB host controller'
> > can support 0x80 (512bytes), however, in this case,
> > isochronous/interrupt transactions cannot be initiated by 'Intel Quark X1000
> USB host controller'.
> > Right?
> >
> > So, 0x79 (508bytes?) should be used, because the isochronous/interrupt
> > transactions can be initiated by 'Intel Quark X1000 USB host controller'.
> > Right?
> >
Yes, to maximize the performance, we set the threshold as maximal as possible. Intel Quark X1000 can support 0x80 dwords (512Bytes), but 0x7F dwords (508 Bytes) should be used since the isochronous/interrupt
transactions can be initiated by Intel Quark X1000 USB host controller. I will update the descriptions.

> > > /*------------------------------------------------------------------
> > > -------*/
> > > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > > +static inline bool usb_is_intel_quark_x1000(struct pci_dev *pdev) {
> > > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > > +
> >
> > Please don't add this unnecessary line.
OK, I will remove it.

> >
> > > +}
> > > +
> > > +/* Register offset of in/out threshold */
> > > +#define EHCI_INSNREG01		    0x84
> > > +/* The maximal threshold is 0x80 Dword */
> > > +#define EHCI_MAX_THRESHOLD      0X80
> >
> > s/0X80/0x80
> >
> > 0x80 means 512 bytes. So, how about mentioning '0x80 means 512 bytes'
> > in this comment or the commit message?
> >
> > Maybe, how about the following?
> >
> > /* The maximal threshold value is 0x80, which means 512 bytes */
> > #define EHCI_THRESHOLD_512BYTES		0x80
> >
> > > +/* Lower word is 'in' threshold, and higher word is 'out'
> > > +threshold*/ #define EHCI_INSNREG01_THRESH \
> > > +	((EHCI_MAX_THRESHOLD - 1)<<16 | (EHCI_MAX_THRESHOLD - 1))
> >
> > Um, how about the following?
> >
> > /* Register offset of in/out threshold */
> > #define EHCI_INSNREG01			0x84
> > /* The maximal threshold value is 0x80, which means 512 bytes */
> > #define EHCI_THRESHOLD_512BYTES		0x80
> > #define EHCI_THRESHOLD_508BYTES		0x79
> > #define EHCI_THRESHOLD_OUT_SHIFT		16
> > #define EHCI_THRESHOLD_IN_SHIFT		0
> >
> > 	......
> >
> > 	/*
> > 	 * In order to support the isochronous/interrupt transactions,
> > 	 * 508 bytes should be used as max threshold values */
> > 	 */
> > 	val = 	((EHCI_THRESHOLD_512BYTES - 1) <<
> EHCI_THRESHOLD_OUT_SHIFT |
> > 		(EHCI_THRESHOLD_512BYTES - 1) << EHCI_THRESHOLD_IN_SHIFT);
> > 	writel(val, op_reg_base + EHCI_INSNREG01);
> 
> Sorry, please refer to the following.
> 
> /* Register offset of in/out threshold */
> #define EHCI_INSNREG01			0x84
> /* The maximal threshold value is 0x80, which means 512 bytes */
> #define EHCI_THRESHOLD_512BYTES		0x80
> #define EHCI_THRESHOLD_508BYTES		0x79
> #define EHCI_THRESHOLD_OUT_SHIFT		16
> #define EHCI_THRESHOLD_IN_SHIFT		0
> 
>  	......
> 
>  	/*
> 	 * In order to support the isochronous/interrupt transactions,
> 	 * 508 bytes should be used as max threshold values */
> 	 */
> 	val = 	(EHCI_THRESHOLD_508BYTES <<
> EHCI_THRESHOLD_OUT_SHIFT |
> 		(EHCI_THRESHOLD_508BYTES << EHCI_THRESHOLD_IN_SHIFT);
> 	writel(val, op_reg_base + EHCI_INSNREG01);
> 
I will improve the according to your suggestions.
