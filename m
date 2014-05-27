Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaE0VSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:18:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaE0VSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:18:34 -0400
Date: Tue, 27 May 2014 14:22:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 3/3] mei: add WPT second mei interface
Message-ID: <20140527212207.GB26089@kroah.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
 <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399969321-6512-4-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:22:01AM +0300, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> Add WPT second mei interface.
> In order for correct device numbering we add mei device interface id
> to to mei_cfg structure
> 
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/hw-me-regs.h | 1 +
>  drivers/misc/mei/hw-me.c      | 5 +++++
>  drivers/misc/mei/hw-me.h      | 1 +
>  drivers/misc/mei/main.c       | 2 +-
>  drivers/misc/mei/mei_dev.h    | 2 ++
>  drivers/misc/mei/pci-me.c     | 1 +
>  6 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
> index a7856c0..c5feafd 100644
> --- a/drivers/misc/mei/hw-me-regs.h
> +++ b/drivers/misc/mei/hw-me-regs.h
> @@ -115,6 +115,7 @@
>  #define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
>  
>  #define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
> +#define MEI_DEV_ID_WPT_LP_2   0x9CBB  /* Wildcat Point LP 2 */
>  
>  /* Host Firmware Status Registers in PCI Config Space */
>  #define PCI_CFG_HFS_1         0x40
> diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
> index 6a2d272..9066bb1 100644
> --- a/drivers/misc/mei/hw-me.c
> +++ b/drivers/misc/mei/hw-me.c
> @@ -844,6 +844,11 @@ const struct mei_cfg mei_me_pch_cfg = {
>  	MEI_CFG_PCH_HFS,
>  };
>  
> +/* PCH devices MEI 2 interface */
> +const struct mei_cfg mei_me_pch_2_cfg = {
> +	MEI_CFG_PCH_HFS,
> +	.mei_id = 1

That's going to be a recipe for disaster.  Have the MEI core allocate
the id numbers as things are registered, don't have the individual
drivers create their id.

> +};
>  
>  /* PCH Cougar Point and Patsburg with quirk for Node Manager exclusion */
>  const struct mei_cfg mei_me_pch_cpt_pbg_cfg = {
> diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
> index 12b0f4b..6fb841f 100644
> --- a/drivers/misc/mei/hw-me.h
> +++ b/drivers/misc/mei/hw-me.h
> @@ -41,6 +41,7 @@ struct mei_me_hw {
>  extern const struct mei_cfg mei_me_legacy_cfg;
>  extern const struct mei_cfg mei_me_ich_cfg;
>  extern const struct mei_cfg mei_me_pch_cfg;
> +extern const struct mei_cfg mei_me_pch_2_cfg;
>  extern const struct mei_cfg mei_me_pch_cpt_pbg_cfg;
>  extern const struct mei_cfg mei_me_lpt_cfg;
>  
> diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> index c58e059..cf4ed5a 100644
> --- a/drivers/misc/mei/main.c
> +++ b/drivers/misc/mei/main.c
> @@ -667,7 +667,7 @@ int mei_register(struct mei_device *dev)
>  {
>  
>  	int ret, devno;
> -	int id = 0; /* FIXME: retrieve interface version*/
> +	int id = dev->cfg->mei_id;

Why can't you do this in patch 01 of this series?


>  
>  	/* Fill in the data structures */
>  	devno = MKDEV(MAJOR(mei_devt), id);
> diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
> index a418565..a521783 100644
> --- a/drivers/misc/mei/mei_dev.h
> +++ b/drivers/misc/mei/mei_dev.h
> @@ -384,10 +384,12 @@ enum mei_pg_state {
>   *
>   * @fw_status - FW status
>   * @quirk_probe - device exclusion quirk
> + * @mei_id - id of mei device
>   */
>  struct mei_cfg {
>  	const struct mei_fw_status fw_status;
>  	bool (*quirk_probe)(struct pci_dev *pdev);
> +	int mei_id;

This should be part of the device, not the configuration, for the reason
specified above.

thanks,

greg k-h
