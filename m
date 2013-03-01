Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab3CAKx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:53:58 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:53851 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3CAKx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:53:57 -0500
Date: Fri, 1 Mar 2013 11:53:46 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>
Subject: Re: [PATCH] usb: correctly enable interrupts for xhci
Message-ID: <20130301105346.GA4050@hardeman.nu>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
	Oliver Neukum <oneukum@suse.de>, Thomas Renninger <trenn@suse.de>,
	Yinghai Lu <yinghai@kernel.org>, Frederik Himpe <fhimpe@vub.ac.be>
References: <1362127974-24487-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362127974-24487-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 09:52:54AM +0100, Hannes Reinecke wrote:
>xhci might run with MSI/MSI-X only, with no support for legacy
>interrupts. On these devices the request_irq() call in usb_add_hcd()
>will fail, causing the entire device to fail.
>For xhci this is especially painful as the driver will enable
>interrupts during xhci_run(), so the initial call to request_irq()
>is not required anyway.
>
>This patch adds a flag 'msix_supported' to struct usb_hcd, which
>will cause usb_add_hcd() to skip interrupt setup. This flag is
>set in xhci-pci, so the registration will skip the first request_irq()
>and can proceed.
>
>Cc: Bjorn Helgaas <bhelgaas@google.com>
>Cc: Oliver Neukum <oneukum@suse.de>
>Cc: Thomas Renninger <trenn@suse.de>
>Cc: Yinghai Lu <yinghai@kernel.org>
>Cc: Frederik Himpe <fhimpe@vub.ac.be>
>Cc: David Haerdeman <david@hardeman.nu>
>Signed-off-by: Hannes Reinecke <hare@suse.de>

It doesn't seem to work. I just tried applying the patch to the 3.8
kernel in Debian experimental and this was the result during boot:

[    1.203390] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    1.203393] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    1.203419] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.203423] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.203429] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.203533] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.203535] xhci_hcd 0000:00:14.0: request interrupt 255 failed
[    1.203580] xhci_hcd 0000:00:14.0: USB bus 1 deregistered
[    1.203598] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    1.203600] xhci_hcd 0000:00:14.0: init 0000:00:14.0 fail, -22
[    1.203643] xhci_hcd: probe of 0000:00:14.0 failed with error -22

Regards,
David

