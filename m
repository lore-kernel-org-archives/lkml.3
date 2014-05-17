Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbaEQSse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaEQSsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:48:33 -0400
Date: Sat, 17 May 2014 21:47:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Marcel Apfelbaum <marcel.a@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
Message-ID: <20140517184720.GE9363@redhat.com>
References: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
 <20140515184146.GA14506@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515184146.GA14506@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:41:46PM -0600, Bjorn Helgaas wrote:
> On Thu, May 01, 2014 at 05:35:48PM +0300, Marcel Apfelbaum wrote:
> > When a board is added, the shpchp driver checks if there
> > is a mismatch between the bridge's adapter and the bus speed.
> > If there is, it sets the subordinate speed (if there is no device on it).
> > 
> > However, it takes the reference of the board speed from the primary bus
> > and not from the subordinate. If the primary bus is PCI and not PCIX/PCIe,
> > its speed is not updated and remains 0xff. As a result hotplug fails
> > with error: "Speed of bus ff and adapter 0 mismatch".
> > 
> > Fixed that by checking the speed against the subordinate bus.
> > 
> > Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I think cpqphp has similar issues.  But I can't test it and I don't know if
> anybody even uses it any more, so I'm just going to leave it alone.
> 
> I reworked the changelog because I got confused about the bridge, adapter,
> board, and what was what.  Let me know if the one below is inaccurate.

It's accurate I think. I only wish someone reworked the actual
shpchp code to avoid the confusing adapter/board terminology.

> I'll include this for v3.15 since it's a regression fix.
> 
> Thanks,
>   Bjorn
> 
> commit be219b7f518a36f62d67f057e9d31ebe9674814f
> Author: Marcel Apfelbaum <marcel.a@redhat.com>
> Date:   Thu May 1 17:35:48 2014 +0300
> 
>     PCI: shpchp: Check bridge's secondary (not primary) bus speed
>     
>     When a new device is added below a hotplug bridge, the bridge's secondary
>     bus speed and the device's bus speed must match.  The shpchp driver
>     previously checked the bridge's *primary* bus speed, not the secondary bus
>     speed.
>     
>     This caused hot-add errors like:
>     
>       shpchp 0000:00:03.0: Speed of bus ff and adapter 0 mismatch
>     
>     Check the secondary bus speed instead.
>     
>     [bhelgaas: changelog]
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=75251
>     Fixes: 3749c51ac6c1 ("PCI: Make current and maximum bus speeds part of the PCI core")
>     Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Acked-by: Michael S. Tsirkin <mst@redhat.com>
>     CC: stable@vger.kernel.org	# v2.6.34+
> 
> diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
> index 58499277903a..6efc2ec5e4db 100644
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
