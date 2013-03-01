Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab3CAOyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:54:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58794 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750709Ab3CAOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:54:43 -0500
Date: Fri, 1 Mar 2013 09:54:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hannes Reinecke <hare@suse.de>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>
Subject: Re: [PATCH] usb: correctly enable interrupts for xhci
In-Reply-To: <1362127974-24487-1-git-send-email-hare@suse.de>
Message-ID: <Pine.LNX.4.44L0.1303010951100.1534-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013, Hannes Reinecke wrote:

> xhci might run with MSI/MSI-X only, with no support for legacy
> interrupts. On these devices the request_irq() call in usb_add_hcd()
> will fail, causing the entire device to fail.
> For xhci this is especially painful as the driver will enable
> interrupts during xhci_run(), so the initial call to request_irq()
> is not required anyway.
> 
> This patch adds a flag 'msix_supported' to struct usb_hcd, which
> will cause usb_add_hcd() to skip interrupt setup. This flag is
> set in xhci-pci, so the registration will skip the first request_irq()
> and can proceed.

I think it might be better to fix this in hcd-pci.c:usb_hcd_pci_probe.  
At that point if we see that MSI/MSI-X is available, the call to 
usb_add_hcd can pass 0 instead of dev->irq.

It may even be possible to do this without adding an extra flag 
anywhere.  It also has the advantage of keeping special knowledge about 
MSI encapsulated in the PCI-specific parts of the code.

Alan Stern

