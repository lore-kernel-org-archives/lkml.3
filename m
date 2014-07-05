Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbaGERoF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 13:44:05 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35215 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaGERoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 13:44:03 -0400
Date: Sat, 5 Jul 2014 11:43:58 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        rajatjain.linux@gmail.com
Subject: Re: [PATCH] pciehp: Remove the field controller->no_cmd_completed
Message-ID: <20140705174358.GC26618@google.com>
References: <53AC6D6F.5000308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AC6D6F.5000308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 11:58:55AM -0700, Rajat Jain wrote:
> After following recent cleanups by Bjorn:
> 
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/hotplug
> 
> 2cc56f3 PCI: pciehp: Remove assumptions about which commands cause
> 40b9608 PCI: pciehp: Compute timeout from hotplug command start time
> 3461a06 PCI: pciehp: Wait for hotplug command completion lazily
> 4283c70 PCI: pciehp: Make pcie_wait_cmd() self-contained
> 
> the bitfield no_cmd_complete is not really needed anymore, as there is
> only a single occurance of its use. Hence remove the unnecessary bit
> field, and use existing macro NO_CMD_CMPL() instead.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>

Great, thanks for fixing this!  Applied to pci/hotplug for v3.17.

> ---
> (This is rebased on top of Bjorn's pci/hotplug branch mentioned above)
> 
>  drivers/pci/hotplug/pciehp.h     |    1 -
>  drivers/pci/hotplug/pciehp_hpc.c |   11 +----------
>  2 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index c496258..9e5a9fb 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -96,7 +96,6 @@ struct controller {
>  	struct timer_list poll_timer;
>  	unsigned long cmd_started;	/* jiffies */
>  	unsigned int cmd_busy:1;
> -	unsigned int no_cmd_complete:1;
>  	unsigned int link_active_reporting:1;
>  	unsigned int notification_enabled:1;
>  	unsigned int power_fault_detected;
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index a3a5c65..f7c3709 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -140,7 +140,7 @@ static void pcie_wait_cmd(struct controller *ctrl)
>  	 * If the controller does not generate notifications for command
>  	 * completions, we never need to wait between writes.
>  	 */
> -	if (ctrl->no_cmd_complete)
> +	if (NO_CMD_CMPL(ctrl))
>  		return;
>  
>  	if (!ctrl->cmd_busy)
> @@ -772,15 +772,6 @@ struct controller *pcie_init(struct pcie_device *dev)
>  	init_waitqueue_head(&ctrl->queue);
>  	dbg_ctrl(ctrl);
>  
> -	/*
> -	 * Controller doesn't notify of command completion if the "No
> -	 * Command Completed Support" bit is set in Slot Capabilities.
> -	 * If set, it means the controller can accept hotplug commands
> -	 * with no delay between them.
> -	 */
> -	if (NO_CMD_CMPL(ctrl))
> -		ctrl->no_cmd_complete = 1;
> -
>  	/* Check if Data Link Layer Link Active Reporting is implemented */
>  	pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &link_cap);
>  	if (link_cap & PCI_EXP_LNKCAP_DLLLARC) {
> -- 
> 1.7.9.5
> 
