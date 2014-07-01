Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaGABun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:50:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:54684 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaGABul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:50:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,578,1400050800"; 
   d="scan'208";a="555556909"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jingoo Han <jg1.han@samsung.com>, David Laight <David.Laight@ACULAB.COM>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v3] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH v3] USB: ehci-pci: USB host controller support for
 Intel Quark X1000
Thread-Index: AQHPlHFX48LVHsbFaUGVfkhEl9ZAOZuKc/Mg
Date: Tue, 1 Jul 2014 01:50:05 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E947AF9@SHSMSX101.ccr.corp.intel.com>
References: <1404147960-17596-2-git-send-email-alvin.chen@intel.com>
 <Pine.LNX.4.44L0.1406301029190.1550-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406301029190.1550-100000@iolanthe.rowland.org>
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

> >
> > /*--------------------------------------------------------------------
> > -----*/
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +static inline bool is_intel_quark_x1000(struct pci_dev *pdev) {
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +}
> 
> Whether to put this test directly into ehci_pci_reset() or leave it as a separate
> subroutine is up to you.  I don't care either way.
I will just keep it.

> > +
> > +/*
> > +	* The offset of in/out threshold register is 0x84.
> > +	* And it is the register of 'hostpc'
> > +	* in memory-mapped EHCI controller.
> > +*/
> 
> 0x84 is the same as offset of the hostpc register in the Intel Moorestown
> controller.  hostpc is not present in general EHCI controllers.
>
OK, I will improve the comments.

> > +#define	intel_quark_x1000_insnreg01	hostpc
> > +
> > +/* The maximal ehci packet buffer size is 512 bytes */
> > +#define INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE	512
> > +
> > +/* The threshold value set the register is in DWORD */
> > +#define INTEL_QUARK_X1000_EHCI_THRESHOLD(size)	((size)/4u)
> > +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT	16
> > +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT	0
> > +
> >  /* called after powerup, by probe or system-pm "wakeup" */  static
> > int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)  {
> >  	int			retval;
> > +	u32			val;
> > +	u32			thr;
> >
> >  	/* we expect static quirk code to handle the "extended capabilities"
> >  	 * (currently just BIOS handoff) allowed starting with EHCI 0.96 @@
> > -50,6 +74,22 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct
> pci_dev *pdev)
> >  	if (!retval)
> >  		ehci_dbg(ehci, "MWI active\n");
> >
> > +	/* Reset the threshold limit */
> > +	if (is_intel_quark_x1000(pdev)) {
> > +		/*
> > +			* In order to support the isochronous/interrupt
> > +			* transactions, 508 bytes should be used as
> > +			* max threshold values to maximize the
> > +			* performance
> > +		*/
> > +		thr = INTEL_QUARK_X1000_EHCI_THRESHOLD(
> > +			INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE - 4
> > +			);
> > +		val = thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT |
> > +				thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT;
> > +		ehci_writel(ehci, val, ehci->regs->intel_quark_x1000_insnreg01);
> 
> I saw what other people told you about the original patch version, and I
> disagree with them.  It is not necessary to include a detailed calculation like
> this, it only makes the code harder to read.  It will be better to have a single
> #define with a comment explaining it, like
> this:
> 
> /* Maximum usable threshold value is 0x7f dwords for both IN and OUT */
> #define INTEL_QUARK_X1000_EHCI_MAX_THRESHOLD	0x007f007f
> 
> Then here, just use INTEL_QUARK_X1000_EHCI_MAX_THRESHOLD instead of
> val.  The comment can simply say:
> 
> 	/*
> 	 * For the Intel QUARK X1000, raise the I/O threshold to the
> 	 * maximum usable value in order to improve performance.
> 	 */
> 
I think so also. It is not necessary to make so complicated. I will adopt your suggestions, it is more simple and clearly.

> Alan Stern

