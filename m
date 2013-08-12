Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab3HLPaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:30:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56843 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3HLPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:30:27 -0400
Date: Mon, 12 Aug 2013 11:15:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-ID: <20130812151514.GD27408@tuxdriver.com>
References: <20130812115327.7bcbb203ac8614d16d32ba52@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812115327.7bcbb203ac8614d16d32ba52@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I have this slightly different in wireless-testing.  Johannes,
please review and advise...

John

On Mon, Aug 12, 2013 at 11:53:27AM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/iwlwifi/pcie/trans.c between commit eabc4ac5d760
> ("iwlwifi: pcie: disable L1 Active after pci_enable_device") from
> thewireless tree and commit f2532b04b2ec ("iwlwifi: pcie: don't disable
> L1 for newest NICs") from the wireless-next tree.
> 
> I fixed it up (maybe - see below) and can carry the fix as necessary (no
> action is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/net/wireless/iwlwifi/pcie/trans.c
> index 390e2f0,e52d1ce..0000000
> --- a/drivers/net/wireless/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
> @@@ -1502,16 -1400,22 +1400,22 @@@ struct iwl_trans *iwl_trans_pcie_alloc(
>   	spin_lock_init(&trans_pcie->reg_lock);
>   	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
>   
>  +	if (pci_enable_device(pdev)) {
>  +		err = -ENODEV;
>  +		goto out_no_pci;
>  +	}
>  +
> - 	/* W/A - seems to solve weird behavior. We need to remove this if we
> - 	 * don't want to stay in L1 all the time. This wastes a lot of power */
> - 	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
> - 			       PCIE_LINK_STATE_CLKPM);
> + 	if (!cfg->base_params->pcie_l1_allowed) {
> + 		/*
> + 		 * W/A - seems to solve weird behavior. We need to remove this
> + 		 * if we don't want to stay in L1 all the time. This wastes a
> + 		 * lot of power.
> + 		 */
> + 		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> + 				       PCIE_LINK_STATE_L1 |
> + 				       PCIE_LINK_STATE_CLKPM);
> + 	}
>   
>  -	if (pci_enable_device(pdev)) {
>  -		err = -ENODEV;
>  -		goto out_no_pci;
>  -	}
>  -
>   	pci_set_master(pdev);
>   
>   	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
