Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaKDQM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:12:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbaKDQMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:12:52 -0500
Message-ID: <1415117537.27420.428.camel@ul30vt.home>
Subject: Re: [PATCH 2/2] iommu/vt-d: Only remove domain when device is
 removed
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        iommu@lists.linux-foundation.org, jroedel@suse.de,
        linux-kernel@vger.kernel.org, Myron Stowe <mstowe@redhat.com>
Date: Tue, 04 Nov 2014 09:12:17 -0700
In-Reply-To: <1412074923-6342-3-git-send-email-joro@8bytes.org>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
	 <1412074923-6342-3-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 13:02 +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This makes sure any RMRR mappings stay in place when the
> driver is unbound from the device.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/intel-iommu.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 5619f26..eaf825a 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3865,16 +3865,7 @@ static int device_notifier(struct notifier_block *nb,
>  	if (iommu_dummy(dev))
>  		return 0;
>  
> -	if (action != BUS_NOTIFY_UNBOUND_DRIVER &&
> -	    action != BUS_NOTIFY_DEL_DEVICE)
> -		return 0;
> -
> -	/*
> -	 * If the device is still attached to a device driver we can't
> -	 * tear down the domain yet as DMA mappings may still be in use.
> -	 * Wait for the BUS_NOTIFY_UNBOUND_DRIVER event to do that.
> -	 */
> -	if (action == BUS_NOTIFY_DEL_DEVICE && dev->driver != NULL)
> +	if (action != BUS_NOTIFY_REMOVED_DEVICE)

I haven't tested it, but I'm concerned whether this has introduced a
domain leak.  If we think about the case of unbinding a device from a
host driver and attaching it to a domain through the IOMMU API, I think
we used to count on this path to call domain_exit(), which made the
domain_context_mapped() in intel_iommu_attach_device() "unlikely".  With
this change, isn't the test in intel_iommu_attach_device() now neither
likely nor unlikely and we're only removing the dev_info from the domain
and not destroying the domain itself?  Thanks,

Alex

