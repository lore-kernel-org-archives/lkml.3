Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3ISKTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:19:31 -0400
Received: from d-paulus.de ([37.221.197.252]:37909 "EHLO d-paulus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3ISKT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:19:29 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2013 06:19:29 EDT
Date: Thu, 19 Sep 2013 12:10:41 +0200
From: Dominik Paulus <dominik@d-paulus.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tobias Polzer <bulsa.t.polzer@studium.uni-erlangen.de>,
        usbip-devel@lists.sourceforge.net,
        Dominik Paulus <dominik.paulus@fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Tobias Polzer <tobias.polzer@fau.de>,
        linux-kernel@vger.kernel.org, Stefan Reif <ke42caxa@cip.cs.fau.de>
Subject: Re: [PATCH] staging: usbip: Fix build on Debian ppc
Message-ID: <20130919101041.GA9196@d-paulus.de>
References: <1379579978-2570-1-git-send-email-dominik.paulus@fau.de>
 <op.w3nhqgkq423x8j@localhost>
 <20130919091244.GV25896@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919091244.GV25896@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:12:44PM +0300, Dan Carpenter wrote:
> On Thu, Sep 19, 2013 at 10:55:18AM +0200, Tobias Polzer wrote:
> > When testing usbip under powerpc, it (unexpectedly) worked, but only after
> > removing the following lines from vhch_hcd.c:
> > 
> > 1004         /* will be removed */
> > 1005         if (pdev->dev.dma_mask) {
> > 1006                 dev_info(&pdev->dev, "vhci_hcd DMA not supported\n");
> > 1007                 return -EINVAL;
> > 1008         }
> > 
> > We encountered no problems without those lines. Is it safe to remove this
> > check?
> 
> Hehe.  No.
> 
> Also which vhch_hcd.c are you talking about?  "find -name vhch_hcd.c"
> doesn't show anything.

Sorry for the typo, we meant vhci_hcd.c in
drivers/staging/usbip/vhci_hcd.c.

> What the error message?

When modprobing vhci_hcd.ko, vhci_hcd_probe() fails and returns -EINVAL,
resulting in this error message:

[  592.623292] vhci_hcd vhci_hcd: vhci_hcd DMA not supported
[  592.624031] vhci_hcd: probe of vhci_hcd failed with error -22

This leads to the virtual host controller device (vhci) not being
created, so usbip cannot work.
It works after removing the codeblock mentioned above.

We did some research and discovered that dma_mask is only set on PowerPC
at the moment (in arch/powerpc/kernel/setup-common.c,
arch_setup_pdev_archdata()).

All of our testing was done in QEMU emulating Debian on POWER7.

Regards,
	Tobias Polzer and Dominik Paulus
