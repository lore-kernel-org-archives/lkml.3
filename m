Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaBSWHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:07:32 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56244 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaBSWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:07:30 -0500
Date: Wed, 19 Feb 2014 15:07:25 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] pciehp: Remove a non-existent card, regardless of
 "surprise" capability
Message-ID: <20140219220725.GC19233@google.com>
References: <53041C9F.7050801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53041C9F.7050801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 06:53:19PM -0800, Rajat Jain wrote:
> In case a card is physically yanked out, it should immediately be
> removed, regardless of the "surprise" capability bit. Thus:
> 
> * Always handle the physical removal - regardless of the "surprise" bit.
> * Don't use "surprise" capability when making decisions about enabling
> presence detect notifications.
> * Reword the comments to indicate the intent.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>

Applied to pci/pciehp for v3.15, thanks!

Bjorn

> ---
>  drivers/pci/hotplug/pciehp_ctrl.c |    9 ++++++++-
>  drivers/pci/hotplug/pciehp_hpc.c  |    9 +++++----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
> index e027e36..c75e6a6 100644
> --- a/drivers/pci/hotplug/pciehp_ctrl.c
> +++ b/drivers/pci/hotplug/pciehp_ctrl.c
> @@ -534,9 +534,16 @@ static void interrupt_event_handler(struct work_struct *work)
>  		pciehp_green_led_off(p_slot);
>  		break;
>  	case INT_PRESENCE_ON:
> -	case INT_PRESENCE_OFF:
>  		if (!HP_SUPR_RM(ctrl))
>  			break;
> +		ctrl_dbg(ctrl, "Surprise Insertion\n");
> +		handle_surprise_event(p_slot);
> +		break;
> +	case INT_PRESENCE_OFF:
> +		/*
> +		 * Regardless of surprise capability, we need to
> +		 * definitely remove a card that has been pulled out!
> +		 */
>  		ctrl_dbg(ctrl, "Surprise Removal\n");
>  		handle_surprise_event(p_slot);
>  		break;
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index da4b020..d7d058f 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -619,9 +619,10 @@ static void pcie_disable_notification(struct controller *ctrl)
>  
>  /*
>   * pciehp has a 1:1 bus:slot relationship so we ultimately want a secondary
> - * bus reset of the bridge, but if the slot supports surprise removal (or
> - * link state change based hotplug), we need to disable presence detection
> - * (or link state notifications) around the bus reset and clear any spurious
> + * bus reset of the bridge, but at the same time we want to ensure that it is
> + * not seen as a hot-unplug, followed by the hot-plug of the device. Thus,
> + * disable link state notification and presence detection change notification
> + * momentarily, if we see that they could interfere. Also, clear any spurious
>   * events after.
>   */
>  int pciehp_reset_slot(struct slot *slot, int probe)
> @@ -633,7 +634,7 @@ int pciehp_reset_slot(struct slot *slot, int probe)
>  	if (probe)
>  		return 0;
>  
> -	if (HP_SUPR_RM(ctrl) && !ATTN_BUTTN(ctrl)) {
> +	if (!ATTN_BUTTN(ctrl)) {
>  		ctrl_mask |= PCI_EXP_SLTCTL_PDCE;
>  		stat_mask |= PCI_EXP_SLTSTA_PDC;
>  	}
> -- 
> 1.7.9.5
> 
