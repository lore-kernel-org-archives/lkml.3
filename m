Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaGDKyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:54:36 -0400
Received: from 8bytes.org ([85.214.48.195]:42363 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaGDKye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:54:34 -0400
Date: Fri, 4 Jul 2014 12:54:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alex.williamson@redhat.com
Subject: Re: [PATCH 2/3] iommu/fsl: Fix the device domain attach condition.
Message-ID: <20140704105430.GE13434@8bytes.org>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <1403618237-26248-3-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403618237-26248-3-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 12:54:32 2014
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b687e820861067219228
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm,

On Tue, Jun 24, 2014 at 07:27:16PM +0530, Varun Sethi wrote:
> -	old_domain_info = find_domain(dev);
> +	old_domain_info = dev->archdata.iommu_domain;
>  	if (old_domain_info && old_domain_info->domain != dma_domain) {
>  		spin_unlock_irqrestore(&device_domain_lock, flags);
>  		detach_device(dev, old_domain_info->domain);

Wouldn't this set dev->archdata.iommu_domain to NULL anyway, so that ...

> @@ -399,7 +394,7 @@ static void attach_device(struct fsl_dma_domain *dma_domain, int liodn, struct d
>  	 * the info for the first LIODN as all
>  	 * LIODNs share the same domain
>  	 */
> -	if (!old_domain_info)
> +	if (!dev->archdata.iommu_domain)
>  		dev->archdata.iommu_domain = info;

We already know that it _must_ be NULL here?

>  	spin_unlock_irqrestore(&device_domain_lock, flags);

This would shrink down the patch to:

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 93072ba..d21b554 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -399,8 +399,7 @@ static void attach_device(struct fsl_dma_domain *dma_domain, int liodn, struct d
 	 * the info for the first LIODN as all
 	 * LIODNs share the same domain
 	 */
-	if (!old_domain_info)
-		dev->archdata.iommu_domain = info;
+	dev->archdata.iommu_domain = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 }


