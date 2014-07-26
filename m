Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaGZIOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaGZIOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:14:15 -0400
Date: Sat, 26 Jul 2014 09:22:27 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 12/23] lpfc: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Message-ID: <20140726082227.GF21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <ea1bf102a3ce0471996e2ddaaa498b088ac791c8.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea1bf102a3ce0471996e2ddaaa498b088ac791c8.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:16PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hi James,

Could you please review this patch?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: James Smart <james.smart@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/lpfc/lpfc_init.c |   38 +++++++++++++++++---------------------
>  1 files changed, 17 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index a5769a9..d9caed9 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8211,9 +8211,9 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
>   * @phba: pointer to lpfc hba data structure.
>   *
>   * This routine is invoked to enable the MSI-X interrupt vectors to device
> - * with SLI-3 interface specs. The kernel function pci_enable_msix() is
> - * called to enable the MSI-X vectors. Note that pci_enable_msix(), once
> - * invoked, enables either all or nothing, depending on the current
> + * with SLI-3 interface specs. The kernel function pci_enable_msix_exact()
> + * is called to enable the MSI-X vectors. Note that pci_enable_msix_exact(),
> + * once invoked, enables either all or nothing, depending on the current
>   * availability of PCI vector resources. The device driver is responsible
>   * for calling the individual request_irq() to register each MSI-X vector
>   * with a interrupt handler, which is done in this function. Note that
> @@ -8237,8 +8237,8 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
>  		phba->msix_entries[i].entry = i;
>  
>  	/* Configure MSI-X capability structure */
> -	rc = pci_enable_msix(phba->pcidev, phba->msix_entries,
> -				ARRAY_SIZE(phba->msix_entries));
> +	rc = pci_enable_msix_exact(phba->pcidev, phba->msix_entries,
> +				   ARRAY_SIZE(phba->msix_entries));
>  	if (rc) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  				"0420 PCI enable MSI-X failed (%d)\n", rc);
> @@ -8775,15 +8775,13 @@ out:
>   * @phba: pointer to lpfc hba data structure.
>   *
>   * This routine is invoked to enable the MSI-X interrupt vectors to device
> - * with SLI-4 interface spec. The kernel function pci_enable_msix() is called
> - * to enable the MSI-X vectors. Note that pci_enable_msix(), once invoked,
> - * enables either all or nothing, depending on the current availability of
> - * PCI vector resources. The device driver is responsible for calling the
> - * individual request_irq() to register each MSI-X vector with a interrupt
> - * handler, which is done in this function. Note that later when device is
> - * unloading, the driver should always call free_irq() on all MSI-X vectors
> - * it has done request_irq() on before calling pci_disable_msix(). Failure
> - * to do so results in a BUG_ON() and a device will be left with MSI-X
> + * with SLI-4 interface spec. The kernel function pci_enable_msix_range()
> + * is called to enable the MSI-X vectors. The device driver is responsible
> + * for calling the individual request_irq() to register each MSI-X vector
> + * with a interrupt handler, which is done in this function. Note that later
> + * when device is unloading, the driver should always call free_irq() on all
> + * MSI-X vectors it has done request_irq() on before calling pci_disable_msix()
> + * Failure to do so results in a BUG_ON() and a device will be left with MSI-X
>   * enabled and leaks its vectors.
>   *
>   * Return codes
> @@ -8805,18 +8803,16 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>  		phba->sli4_hba.msix_entries[index].entry = index;
>  		vectors++;
>  	}
> -enable_msix_vectors:
> -	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
> -			     vectors);
> -	if (rc > 1) {
> -		vectors = rc;
> -		goto enable_msix_vectors;
> -	} else if (rc) {
> +
> +	rc = pci_enable_msix_range(phba->pcidev, phba->sli4_hba.msix_entries,
> +				   2, vectors);
> +	if (rc < 0) {
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>  				"0484 PCI enable MSI-X failed (%d)\n", rc);
>  		goto vec_fail_out;
>  	}
>  
> +	vectors = rc;
>  	/* Log MSI-X vector assignment */
>  	for (index = 0; index < vectors; index++)
>  		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
