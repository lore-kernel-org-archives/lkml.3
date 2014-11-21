Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaKUKc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:32:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36333 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKUKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:32:24 -0500
Date: Fri, 21 Nov 2014 10:32:14 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141121103213.GB19783@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <1535751.CcvIi3DN4F@wuerfel>
 <546D58B1.60108@huawei.com>
 <2522857.bNQToYpBNt@wuerfel>
 <20141121093509.GA19783@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121093509.GA19783@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:35:10AM +0000, Catalin Marinas wrote:
> @@ -88,11 +89,24 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  {
>  	if (!dev->dma_mask || !dma_supported(dev, mask))
>  		return -EIO;
> +	/* if asking for bigger dma mask, limit it to the bus dma ranges */
> +	if (mask > *dev->dma_mask)
> +		mask &= of_dma_get_range_mask(dev);
>  	*dev->dma_mask = mask;
>  
>  	return 0;
>  }

I wonder whether mask &= of_dma_get_range_mask(dev) limiting should
actually be done before actually checking dma_supported(). That's
because a device may try to set a 64-bit mask but being connected to a
more limiting bus, we should check the dma_supported() on the resulting
mask.

-- 
Catalin
