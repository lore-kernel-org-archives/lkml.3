Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaHDLmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:42:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50376 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaHDLmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:42:08 -0400
Date: Mon, 4 Aug 2014 13:42:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] iommu/vt-d: Do not BUG_ON in intel_unmap if no domain
Message-ID: <20140804114205.GA5545@pd.tnic>
References: <1407151386-16467-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1407151386-16467-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 01:23:06PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This BUG_ON is easy to trigger with device-hotplug (e.g.
> SR-IOV). The device_notifier function in the Intel IOMMU
> driver listens to the BUS_NOTIFY_DEL_DEVICE event and frees
> the domain for the device if it is reveived.
> 
> But this event is triggered before the device driver is
> unbound from the device. When the driver core actually
> removes the device the driver may release pending DMA
> resources, which ends up in intel_unmap and triggers the
> BUG_ON.
> 
> Not listening to BUS_NOTIFY_DEL_DEVICE would cause resource
> leakage with devices that have never been assigned to any
> driver, so fix this issue by just making unmap a nop when
> the domain is already released.
> 
> Cc: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/intel-iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index d1f5caa..7d689d7 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3196,7 +3196,8 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr)
>  		return;
>  
>  	domain = find_domain(dev);
> -	BUG_ON(!domain);
> +	if (!domain)
> +		return;

It is always questionable when people remove BUG_ONs because relaxing
assertions sound like a temporary fix more often than not. Sounds to me
that the original commit which deals with BUS_NOTIFY_DEL_DEVICE needs to
try again with the fix. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
