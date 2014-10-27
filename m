Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaJ0MBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:01:21 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48937 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaJ0MBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:01:18 -0400
Date: Mon, 27 Oct 2014 12:01:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt
 bus_range filtering
Message-ID: <20141027120111.GP8768@arm.com>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:23:06PM +0100, Lorenzo Pieralisi wrote:
> The number of windows allocated for the host bridge depends on the
> bus resource. Instead of first allocating the windows and then
> limit the bus resource, this patch reshuffles the code so that if any
> limitation is applied to the bus resource it is taken into account in
> the windows allocation.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> ---
>  drivers/pci/host/pci-host-generic.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

Will

> diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
> index 3d2076f..1e1a80f 100644
> --- a/drivers/pci/host/pci-host-generic.c
> +++ b/drivers/pci/host/pci-host-generic.c
> @@ -276,17 +276,17 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
>  		return err;
>  	}
>  
> -	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
> -				    sizeof(*pci->cfg.win), GFP_KERNEL);
> -	if (!pci->cfg.win)
> -		return -ENOMEM;
> -
>  	/* Limit the bus-range to fit within reg */
>  	bus_max = pci->cfg.bus_range.start +
>  		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
>  	pci->cfg.bus_range.end = min_t(resource_size_t, pci->cfg.bus_range.end,
>  				       bus_max);
>  
> +	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
> +				    sizeof(*pci->cfg.win), GFP_KERNEL);
> +	if (!pci->cfg.win)
> +		return -ENOMEM;
> +
>  	/* Map our Configuration Space windows */
>  	if (!devm_request_mem_region(dev, pci->cfg.res.start,
>  				     resource_size(&pci->cfg.res),
> -- 
> 2.1.2
> 
