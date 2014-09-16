Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaIPVUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:20:54 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58438 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaIPVUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:20:53 -0400
Date: Tue, 16 Sep 2014 15:20:48 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Prevent NULL dereference during pciehp probe
Message-ID: <20140916212048.GA5050@google.com>
References: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:03:32PM +0200, Andreas Noever wrote:
> pciehp assumes that dev->subordinate exists. But we do not assign a bus
> if we run out of bus numbers during enumeration. This leads to a NULL
> dereference in init_slot (and other places).
> 
> Change pciehp_probe to return -ENODEV when no subordinate bus is
> present.
> 
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>

Applied to pci/hotplug for v3.18, thanks!

> ---
>  drivers/pci/hotplug/pciehp_core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 0e0a2ff..e5abcaf 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -255,6 +255,13 @@ static int pciehp_probe(struct pcie_device *dev)
>  	else if (pciehp_acpi_slot_detection_check(dev->port))
>  		goto err_out_none;
>  
> +	if (!dev->port->subordinate) {
> +		/* Can happen if we run out of bus numbers during probe */
> +		dev_err(&dev->device,
> +			"Hotplug bridge without secondary bus, ignoring\n");
> +		goto err_out_none;
> +	}
> +
>  	ctrl = pcie_init(dev);
>  	if (!ctrl) {
>  		dev_err(&dev->device, "Controller initialization failed\n");
> -- 
> 2.0.0
> 
