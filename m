Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaEDNsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 09:48:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaEDNsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 09:48:20 -0400
Message-ID: <5366451E.1050800@redhat.com>
Date: Sun, 04 May 2014 16:48:14 +0300
From: Ronen Hod <rhod@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Apfelbaum <marcel.a@redhat.com>, linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org, bhelgaas@google.com, matthew@wil.cx,
        mst@redhat.com
Subject: Re: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
References: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
In-Reply-To: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 05:35 PM, Marcel Apfelbaum wrote:
> When a board is added, the shpchp driver checks if there
> is a mismatch between the bridge's adapter and the bus speed.
> If there is, it sets the subordinate speed (if there is no device on it).

Since the speed is irrelevant when running in a VM, I suggest that
you either ignore it altogether, or "normalize" the speed of all the
devices/bridges/buses in QEMU in order to avoid any conflicts
in the first place.

Thanks, Ronen.

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
> ---
>   drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
> index 5849927..6efc2ec 100644
> --- a/drivers/pci/hotplug/shpchp_ctrl.c
> +++ b/drivers/pci/hotplug/shpchp_ctrl.c
> @@ -282,8 +282,8 @@ static int board_added(struct slot *p_slot)
>   		return WRONG_BUS_FREQUENCY;
>   	}
>   
> -	bsp = ctrl->pci_dev->bus->cur_bus_speed;
> -	msp = ctrl->pci_dev->bus->max_bus_speed;
> +	bsp = ctrl->pci_dev->subordinate->cur_bus_speed;
> +	msp = ctrl->pci_dev->subordinate->max_bus_speed;
>   
>   	/* Check if there are other slots or devices on the same bus */
>   	if (!list_empty(&ctrl->pci_dev->subordinate->devices))

