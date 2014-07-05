Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaGES5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:57:43 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52975 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbaGES5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:57:40 -0400
Date: Sat, 5 Jul 2014 12:57:36 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Vidya Sagar <vidyas@nvidia.com>
Cc: rjw@sisk.pl, nagananda.chumbalkar@hp.com, thierry.reding@gmail.com,
        swarren@nvidia.com, kthota@nvidia.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Message-ID: <20140705185736.GD28871@google.com>
References: <1404198978-26593-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404198978-26593-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Matthew]

On Tue, Jul 01, 2014 at 12:46:18PM +0530, Vidya Sagar wrote:
> commit 1a680b7c moved pcie_aspm_powersave_config_link() out of
> pci_raw_set_power_state() to pci_set_power_state() which would enable
> ASPM. But, with commit db288c9c, which re-introduced the following check
> ./drivers/pci/pci.c: pci_set_power_state()
> +   /* Check if we're already there */
> +   if (dev->current_state == state)
> +       return 0;
> in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is never
> made leaving ASPM broken.
> Fix it by not returning from when the above condition is true, rather, jump to
> ASPM configuration code and exit from there eventually.

Rafael, Matthew, any comments?  We have vacillated on this before and
the web is already pretty tangled.

Vidya, can you give more details about the bug fixed by this change?
What's the scenario?  Are we resuming and the device is powered up but
ASPM isn't enabled?  Maybe you could collect more details in a
http://bugzilla.kernel.org report?

> Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
> ---
>  drivers/pci/pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 1c8592b..ded24c4 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -804,7 +804,7 @@ EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
>   */
>  int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  {
> -	int error;
> +	int error = 0;
>  
>  	/* bound the state we're entering */
>  	if (state > PCI_D3cold)
> @@ -821,7 +821,7 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  
>  	/* Check if we're already there */
>  	if (dev->current_state == state)
> -		return 0;
> +		goto config_aspm;
>  
>  	__pci_start_power_transition(dev, state);
>  
> @@ -839,6 +839,8 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  
>  	if (!__pci_complete_power_transition(dev, state))
>  		error = 0;
> +
> +config_aspm:
>  	/*
>  	 * When aspm_policy is "powersave" this call ensures
>  	 * that ASPM is configured.
> -- 
> 1.8.1.5
> 
