Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbaLKA0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:26:37 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36802 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397AbaLKA0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:26:35 -0500
Date: Wed, 10 Dec 2014 17:26:30 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH v2] PCI: pciehp: Check link state before accessing device
 during removal
Message-ID: <20141211002630.GC22886@google.com>
References: <546E7120.5080505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E7120.5080505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:54:24PM -0800, Rajat Jain wrote:
> While removing a card, we can't assume the presence to mean that the
> access to card is OK. That is because the cause of removal may be a
> link down event, and the card may still be physically present. Thus,
> instead of presence, use the link state to decide whether or not it is
> OK to access the card devices.
> 
> Here are the problem symptoms:
> During the removal of a card due to link down, sometimes the following
> error is seen (because pciehp_unconfigure_device() reads 0xFF from
> bridge control register as the link is down, which cause it to assume
> that the VGA bit is set):
> 
> pciehp 0000:21:05.0:pcie24: pcie_isr: intr_loc 100
> pciehp 0000:21:05.0:pcie24: Data Link Layer State change
> pciehp 0000:21:05.0:pcie24: slot(5): Link Down event
> pciehp 0000:21:05.0:pcie24: Disabling domain:bus:device=0000:60:00
> pciehp 0000:21:05.0:pcie24: pciehp_unconfigure_device: domain:bus:dev = 0000:60:00
> pciehp 0000:21:05.0:pcie24: Cannot remove display device 0000:60:00.0
> 
> Ofcourse, when the link comes back up, the device addition fails too:
> 
> pciehp 0000:21:05.0:pcie24: pcie_isr: intr_loc 100
> pciehp 0000:21:05.0:pcie24: Data Link Layer State change
> pciehp 0000:21:05.0:pcie24: pciehp_check_link_active: lnk_status = 6011
> pciehp 0000:21:05.0:pcie24: slot(5): Link Up event
> pciehp 0000:21:05.0:pcie24: Enabling domain:bus:device=0000:60:00
> pciehp 0000:21:05.0:pcie24: pciehp_check_link_active: lnk_status = 6011
> pciehp 0000:21:05.0:pcie24: pciehp_check_link_status: lnk_status = 6011
> pciehp 0000:21:05.0:pcie24: Device 0000:60:00.0 already exists at 0000:60:00, cannot hot-add
> pciehp 0000:21:05.0:pcie24: Cannot add device at 0000:60:00
> 
> The problem is not seen with this patch applied. The device removal and
> insertion works as expected.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> ---
> v2: Use the already initialized "ctrl" instead of "p_slot->ctrl"
> 
>  drivers/pci/hotplug/pciehp_pci.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
> index 9e69403..911f85b 100644
> --- a/drivers/pci/hotplug/pciehp_pci.c
> +++ b/drivers/pci/hotplug/pciehp_pci.c
> @@ -77,7 +77,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>  {
>  	int rc = 0;
>  	u8 bctl = 0;
> -	u8 presence = 0;
> +	bool link_active = false;
>  	struct pci_dev *dev, *temp;
>  	struct pci_bus *parent = p_slot->ctrl->pcie->port->subordinate;
>  	u16 command;
> @@ -85,7 +85,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>  
>  	ctrl_dbg(ctrl, "%s: domain:bus:dev = %04x:%02x:00\n",
>  		 __func__, pci_domain_nr(parent), parent->number);
> -	pciehp_get_adapter_status(p_slot, &presence);
> +	link_active = pciehp_check_link_active(ctrl);
>  
>  	pci_lock_rescan_remove();
>  
> @@ -98,7 +98,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>  	list_for_each_entry_safe_reverse(dev, temp, &parent->devices,
>  					 bus_list) {
>  		pci_dev_get(dev);
> -		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE && presence) {
> +		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE && link_active) {
>  			pci_read_config_byte(dev, PCI_BRIDGE_CONTROL, &bctl);
>  			if (bctl & PCI_BRIDGE_CTL_VGA) {
>  				ctrl_err(ctrl,

Why do we even have this code to check for VGA devices?  I looked (briefly)
and couldn't find anything in the spec that prohibits removal of VGA
devices.

If we do need it (and it looks like most or all hotplug drivers copied it),
isn't there still a race?  Can't we have the following sequence?

  - pciehp_check_link_active()		# returns true
  - Link goes down
  - pci_read_config_byte()		# fails because link is down

Bjorn

> @@ -114,7 +114,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>  		 * Ensure that no new Requests will be generated from
>  		 * the device.
>  		 */
> -		if (presence) {
> +		if (link_active) {
>  			pci_read_config_word(dev, PCI_COMMAND, &command);
>  			command &= ~(PCI_COMMAND_MASTER | PCI_COMMAND_SERR);
>  			command |= PCI_COMMAND_INTX_DISABLE;
> -- 
> 1.7.9.5
> 
