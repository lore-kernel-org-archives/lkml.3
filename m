Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaKEVYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:24:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45570 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751447AbaKEVYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:24:03 -0500
Date: Wed, 5 Nov 2014 16:24:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lu Baolu <baolu.lu@linux.intel.com>
cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
In-Reply-To: <1415164036-68517-3-git-send-email-baolu.lu@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1411051621280.1531-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Lu Baolu wrote:

> xhci: clear root port wake on bits if controller isn't allowed to do wakeup
> 
> When system is being suspended, if host device is not allowed to do wakeup,
> xhci_suspend() needs to clear all root port wake on bits. Otherwise, some
> platforms may generate spurious wakeup, even if PCI PME# is disabled.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>

This looks pretty good now.

> +static void xhci_disable_port_wake_on_bits(struct xhci_hcd *xhci)
> +{
> +	int port_index;
> +	__le32 __iomem **port_array;
> +	unsigned long flags;
> +	u32 t1, t2;
> +
> +	spin_lock_irqsave(&xhci->lock, flags);
> +
> +	/* disble usb3 ports Wake bits*/
> +	port_index = xhci->num_usb3_ports;
> +	port_array = xhci->usb3_ports;
> +	while (port_index--) {
> +		t1 = readl(port_array[port_index]);
> +		t2 = xhci_port_state_to_neutral(t1);
> +		t2 &= ~PORT_WAKE_BITS;
> +		t1 = xhci_port_state_to_neutral(t1);
> +		if (t1 != t2)
> +			writel(t2, port_array[port_index]);

Why not just do:

		t1 = readl(port_array[port_index]);
		t1 = xhci_port_state_to_neutral(t1);
		t2 = t1 & ~PORT_WAKE_BITS;
		if (t1 != t2) ...

Apart from that minor point,

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

