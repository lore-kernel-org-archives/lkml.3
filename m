Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3EBA2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:28:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:30954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3EBA2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:28:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,592,1363158000"; 
   d="scan'208";a="235599682"
Message-ID: <1367454625.2093.6.camel@ymzhang.sh.intel.com>
Subject: Re: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: "Zhang, LongX" <longx.zhang@intel.com>
Cc: "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@Emulex.Com>
Date: Thu, 02 May 2013 08:30:25 +0800
In-Reply-To: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 06:28 +0000, Zhang, LongX wrote:
> From: Zhang Long <longx.zhang@intel.com>
> 
> Specific pci device drivers might have many functions to call
> pci_channel_offline to check device states. When slot_reset happens,
> drivers' slot_reset callback might call such functions and eventually
> abort the reset.
> 
> The patch resets pdev->error_state to pci_channel_io_normal at
> the begining of report_slot_reset.
> 
> Thank Liu Joseph for pointing it out.
Linas, Bjorn,

Would you like to merge the patch to your testing tree?
The patch resolves one issue pointed out by Joseph.

Thanks,
Yanmin


> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> Signed-off-by: Zhang Long <longx.zhang@intel.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
>  drivers/pci/pcie/portdrv_pci.c     |   12 +++++-------
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 564d97f..c61fd44 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -286,6 +286,7 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
>  	result_data = (struct aer_broadcast_data *) data;
>  
>  	device_lock(&dev->dev);
> +	dev->error_state = pci_channel_io_normal;
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
>  		!dev->driver->err_handler->slot_reset)
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index ed4d094..7abefd9 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
>  	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
>  	int retval;
>  
> -	/* If fatal, restore cfg space for possible link reset at upstream */
> -	if (dev->error_state == pci_channel_io_frozen) {
> -		dev->state_saved = true;
> -		pci_restore_state(dev);
> -		pcie_portdrv_restore_config(dev);
> -		pci_enable_pcie_error_reporting(dev);
> -	}
> +	/* restore cfg space for possible link reset at upstream */
> +	dev->state_saved = true;
> +	pci_restore_state(dev);
> +	pcie_portdrv_restore_config(dev);
> +	pci_enable_pcie_error_reporting(dev);
>  
>  	/* get true return value from &status */
>  	retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);


