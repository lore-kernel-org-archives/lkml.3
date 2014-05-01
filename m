Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaEASDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:03:12 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59063 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaEASDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:03:10 -0400
MIME-Version: 1.0
In-Reply-To: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
References: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 1 May 2014 12:02:49 -0600
Message-ID: <CAErSpo4KLq7m8PXzAEhv20e29Wk=sAtageDf3CgziDLno0JUCw@mail.gmail.com>
Subject: Re: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
To: Marcel Apfelbaum <marcel.a@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 8:35 AM, Marcel Apfelbaum <marcel.a@redhat.com> wrote:
> When a board is added, the shpchp driver checks if there
> is a mismatch between the bridge's adapter and the bus speed.
> If there is, it sets the subordinate speed (if there is no device on it).
>
> However, it takes the reference of the board speed from the primary bus
> and not from the subordinate. If the primary bus is PCI and not PCIX/PCIe,
> its speed is not updated and remains 0xff. As a result hotplug fails
> with error: "Speed of bus ff and adapter 0 mismatch".

It'd be cool to have a bugzilla for this with lspci and dmesg output.
I'll also have to check the other hotplug drivers for similar issues,
unless you've already done that.

> Fixed that by checking the speed against the subordinate bus.
>
> Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/pci/hotplug/shpchp_ctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
> index 5849927..6efc2ec 100644
> --- a/drivers/pci/hotplug/shpchp_ctrl.c
> +++ b/drivers/pci/hotplug/shpchp_ctrl.c
> @@ -282,8 +282,8 @@ static int board_added(struct slot *p_slot)
>                 return WRONG_BUS_FREQUENCY;
>         }
>
> -       bsp = ctrl->pci_dev->bus->cur_bus_speed;
> -       msp = ctrl->pci_dev->bus->max_bus_speed;
> +       bsp = ctrl->pci_dev->subordinate->cur_bus_speed;
> +       msp = ctrl->pci_dev->subordinate->max_bus_speed;
>
>         /* Check if there are other slots or devices on the same bus */
>         if (!list_empty(&ctrl->pci_dev->subordinate->devices))
> --
> 1.8.3.1
>
