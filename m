Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3CDQLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:11:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3CDQLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:11:09 -0500
From: Thomas Renninger <trenn@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Oliver Neukum <oneukum@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH][v2] xhci: correctly enable interrupts
Date: Mon, 04 Mar 2013 17:11:07 +0100
Message-ID: <2130794.oLej0IcHh2@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.7-1.2-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 04, 2013 10:26:40 AM Alan Stern wrote:
> On Mon, 4 Mar 2013, Hannes Reinecke wrote:
> > xhci has its own interrupt enabling routine, which will try to
> > use MSI-X/MSI if present. So the usb core shouldn't try to enable
> > legacy interrupts; on some machines the xhci legacy IRQ setting
> > is invalid.
> 
> This version of the patch is much better than the first one, IMO.

I also have this issue. Unfortunately pci read only gives an irq of 255
in secure boot mode and I don't want to struggle with kernel/module
signing to test this.

I found one issue with this patch:
For xhci legacy PCI is not tried to be set up now anymore (before MSI(x)
is tried) which is a correct fix.

But in xhci_try_enable_msi() drivers/usb/host/xhci.c if MSI is known broken
(xhci->quirks & XHCI_BROKEN_MSI), it relies on legacy IRQ being enabled
already.
Instead it should use the "enable legacy IRQ" code later in the same function 
which is the fallback if MSI setup does not succeed.

I send an updated version taking care about above and including the "do not 
split string" concern Sergei mentioned.

        Thomas
