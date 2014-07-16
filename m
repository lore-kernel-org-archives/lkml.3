Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaGPTgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:36:43 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48324 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGPTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:36:41 -0400
Date: Wed, 16 Jul 2014 13:36:37 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Vidya Sagar <sagar.tv@gmail.com>
Cc: matthew.garrett@nebula.com, rjw@rjwysocki.net, nchumbalkar@lenovo.com,
        thierry.reding@gmail.com, swarren@nvidia.com,
        linux-pci@vger.kernel.org, kthota@nvidia.com,
        linux-kernel@vger.kernel.org, vidyas@nvidia.com
Subject: Re: [PATCH v3] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Message-ID: <20140716193637.GA14366@google.com>
References: <1405505022-7593-1-git-send-email-vidyas@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405505022-7593-1-git-send-email-vidyas@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:33:42PM +0530, Vidya Sagar wrote:
> From: Vidya Sagar <sagar.tv@gmail.com>
> 
> Commit 1a680b7c3258 ("PCI: PCIe links may not get configured for ASPM
>  under POWERSAVE mode") moved pcie_aspm_powersave_config_link() out of
> pci_raw_set_power_state() to pci_set_power_state() which would enable
> ASPM. But, with Commit db288c9c5f9d ("PCI / PM: restore the original
>  behavior of pci_set_power_state()"), which re-introduced the following check
> ./drivers/pci/pci.c: pci_set_power_state()
> 
> +	/* Check if we're already there */
> +	if (dev->current_state == state)
> +	   return 0;
> 
> in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is never
> made leaving ASPM broken.
> Fix it by configuring links for ASPM in do_pci_enable_device() instead of
> pci_set_power_state()
> 
> Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>

I applied this to pci/misc for v3.17 with the following changelog:

It would still make me feel better if Matthew and/or Rafael acked this.

    PCI: Configure ASPM when enabling device
    
    We can't do ASPM configuration at enumeration-time because enabling it
    makes some defective hardware unresponsive, even if ASPM is disabled later
    (see 41cd766b0659 ("PCI: Don't enable aspm before drivers have had a chance
    to veto it").  Therefore, we have to do it after a driver claims the
    device.
    
    We previously configured ASPM in pci_set_power_state(), but that's not a
    very good place because it's not really related to setting the PCI device
    power state, and doing it there means:
    
      - We incorrectly skipped ASPM config when setting a device that's
        already in D0 to D0.
    
      - We unnecessarily configured ASPM when setting a device to a low-power
        state (the ASPM feature only applies when the device is in D0).
    
      - We unnecessarily configured ASPM when called from a .resume() method
        (ASPM configuration needs to be restored during resume, but I think
        pci_restore_pcie_state() should already do this).
    
    Move ASPM configuration from pci_set_power_state() to
    do_pci_enable_device() so we do it when a driver enables a device.
    
    [bhelgaas: changelog]
    Link: https://bugzilla.kernel.org/show_bug.cgi?id=79621

It would still make me feel better if Matthew and/or Rafael chimed in to
make sure this is sane.

Bjorn

> ---
> v3:
> * Modified commit message
>     removed single quotes around commit messages
>     added Suggested-by line
> 
> v2:
> * Calling ASPM config code is moved from pci_set_power_state() to
> * do_pci_enable_device()
> 
>  drivers/pci/pci.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 1c8592b..81d49d3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -839,12 +839,6 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  
>  	if (!__pci_complete_power_transition(dev, state))
>  		error = 0;
> -	/*
> -	 * When aspm_policy is "powersave" this call ensures
> -	 * that ASPM is configured.
> -	 */
> -	if (!error && dev->bus->self)
> -		pcie_aspm_powersave_config_link(dev->bus->self);
>  
>  	return error;
>  }
> @@ -1195,12 +1189,18 @@ int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
>  static int do_pci_enable_device(struct pci_dev *dev, int bars)
>  {
>  	int err;
> +	struct pci_dev *bridge;
>  	u16 cmd;
>  	u8 pin;
>  
>  	err = pci_set_power_state(dev, PCI_D0);
>  	if (err < 0 && err != -EIO)
>  		return err;
> +
> +	bridge = pci_upstream_bridge(dev);
> +	if (bridge)
> +		pcie_aspm_powersave_config_link(bridge);
> +
>  	err = pcibios_enable_device(dev, bars);
>  	if (err < 0)
>  		return err;
> -- 
> 1.8.1.5
> 
