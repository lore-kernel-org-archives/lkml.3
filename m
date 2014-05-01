Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaEAPou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaEAPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:44:49 -0400
Date: Thu, 1 May 2014 18:43:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcel Apfelbaum <marcel.a@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew@wil.cx
Subject: Re: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
Message-ID: <20140501154339.GC9180@redhat.com>
References: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 05:35:48PM +0300, Marcel Apfelbaum wrote:
> When a board is added, the shpchp driver checks if there
> is a mismatch between the bridge's adapter and the bus speed.
> If there is, it sets the subordinate speed (if there is no device on it).
> 
> However, it takes the reference of the board speed from the primary bus
> and not from the subordinate. If the primary bus is PCI and not PCIX/PCIe,
> its speed is not updated and remains 0xff. As a result hotplug fails
> with error: "Speed of bus ff and adapter 0 mismatch".
> 
> Fixed that by checking the speed against the subordinate bus.
> 
> Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Looking at git history, I suspect this is a regression
introduced by
	commit 3749c51ac6c1560aa1cb1520066bed84c6f8152a
	Author: Matthew Wilcox <matthew@wil.cx>
	Date:   Sun Dec 13 08:11:32 2009 -0500
	    PCI: Make current and maximum bus speeds part of the PCI core
At least I remember this configuration worked for me early in 2009...

> ---
>  drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
> index 5849927..6efc2ec 100644
> --- a/drivers/pci/hotplug/shpchp_ctrl.c
> +++ b/drivers/pci/hotplug/shpchp_ctrl.c
> @@ -282,8 +282,8 @@ static int board_added(struct slot *p_slot)
>  		return WRONG_BUS_FREQUENCY;
>  	}
>  
> -	bsp = ctrl->pci_dev->bus->cur_bus_speed;
> -	msp = ctrl->pci_dev->bus->max_bus_speed;
> +	bsp = ctrl->pci_dev->subordinate->cur_bus_speed;
> +	msp = ctrl->pci_dev->subordinate->max_bus_speed;
>  
>  	/* Check if there are other slots or devices on the same bus */
>  	if (!list_empty(&ctrl->pci_dev->subordinate->devices))
> -- 
> 1.8.3.1
