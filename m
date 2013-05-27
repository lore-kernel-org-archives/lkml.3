Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab3E0VwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 17:52:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:59316 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3E0VwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 17:52:21 -0400
Message-ID: <1369691531.3557.36.camel@pasglop>
Subject: Re: [PATCH] powerpc/pseries: Force 32 bit MSIs when tearing down
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 07:52:11 +1000
In-Reply-To: <20130527162027.GA18182@dhcp-26-207.brq.redhat.com>
References: <20130527162027.GA18182@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 18:20 +0200, Alexander Gordeev wrote:
> This fix just adds a missed call to a new PAPR function
> which should have been done with commit e61133d ("powerpc/
> pseries: Force 32 bit MSIs for devices that require it")

Arguably, PAPR should allow to disable MSIs using either interface,
we shouldn't have to know whether the MSI was a forced-32-bit one to be
able to disable it.

Brian, can you check with Colleen ?

Cheers,
Ben.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/msi.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
> index 40c7db3..2b80a68 100644
> --- a/arch/powerpc/platforms/pseries/msi.c
> +++ b/arch/powerpc/platforms/pseries/msi.c
> @@ -90,6 +90,7 @@ static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
>  static void rtas_disable_msi(struct pci_dev *pdev)
>  {
>  	struct pci_dn *pdn;
> +	int rc;
>  
>  	pdn = get_pdn(pdev);
>  	if (!pdn)
> @@ -98,7 +99,12 @@ static void rtas_disable_msi(struct pci_dev *pdev)
>  	/*
>  	 * disabling MSI with the explicit interface also disables MSI-X
>  	 */
> -	if (rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, 0) != 0) {
> +	if (pdn->force_32bit_msi)
> +		rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, 0);
> +	else
> +		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, 0);
> +
> +	if ((rc != 0) && !pdn->force_32bit_msi) {
>  		/* 
>  		 * may have failed because explicit interface is not
>  		 * present
> -- 
> 1.7.7.6
> 
> 


