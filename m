Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaKJUpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:45:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaKJUpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:45:33 -0500
Message-ID: <1415652328.16601.277.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: pciehp: Flush slot control prior to reset
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org, rajatxjain@gmail.com,
        yinghai@kernel.org
Date: Mon, 10 Nov 2014 13:45:28 -0700
In-Reply-To: <20141107225359.1937.61243.stgit@gimli.home>
References: <20141107225359.1937.61243.stgit@gimli.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 15:54 -0700, Alex Williamson wrote:
> Since 3461a068661c we don't automatically do a pcie_wait_cmd() for
> as part of pcie_write_cmd(), it needs to be called explicitly or
> triggered by the next pcie_write_cmd().  However, when we do a
> secondary bus reset and we're using pcie_write_cmd() to make sure
> that we don't see that bus reset as a hotplug event, we really want
> to make sure the update is complete.  Testing on an old Lenovo S20
> system, which sets surprise hotplug for some slots, this failure to
> flush results in a link down event seen by the hotplug controller
> when we issue the bus reset and returns us to the undesireable
> behavior of removing and re-adding the device.  Force a flush by
> adding an explicit call to pcie_wait_cmd().
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org [3.17]
> ---
> 
>  drivers/pci/hotplug/pciehp_hpc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index 0ebf754..e540966 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -660,6 +660,7 @@ int pciehp_reset_slot(struct slot *slot, int probe)
>  		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, 0);
>  	if (pciehp_poll_mode)
>  		del_timer_sync(&ctrl->poll_timer);
> +	pcie_wait_cmd(ctrl);
>  
>  	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
>  
> 

I think we might need a similar change on the other side of the reset,
calling pcie_wait_cmd() explicitly before we re-enable polling.  The
patch above passed about 7000 VM startup/shutdown cycles (up from zero
w/o the patch), but it did eventually get a spurious hotplug.  With the
additional pcie_wait_cmd() I'm thinking about, I've passed 8000 cycles.
TL;DR, I'm probably sending a v2 of this patch.  Thanks,

Alex

