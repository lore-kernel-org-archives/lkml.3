Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaICPFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:05:42 -0400
Received: from 8bytes.org ([81.169.241.247]:50834 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaICPFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:05:41 -0400
Date: Wed, 3 Sep 2014 17:05:38 +0200
From: "joro@8bytes.org" <joro@8bytes.org>
To: "Su, Friendy" <Friendy.Su@sony.com.cn>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] iommu/amd: set iommu for early mapped ioapic/hpet
Message-ID: <20140903150538.GJ28786@8bytes.org>
References: <053191AD6E9023439BF3970DE870051856D1EF3AC4@APSHAXMS02.ap.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <053191AD6E9023439BF3970DE870051856D1EF3AC4@APSHAXMS02.ap.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 02:17:44PM +0800, Su, Friendy wrote:
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 3783e0b..148ab61 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -747,7 +747,7 @@ static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
>  	return 0;
>  }
>  
> -static int __init add_early_maps(void)
> +static int __init add_early_maps(struct amd_iommu *iommu)
>  {
>  	int i, ret;
>  
> @@ -758,6 +758,11 @@ static int __init add_early_maps(void)
>  					 early_ioapic_map[i].cmd_line);
>  		if (ret)
>  			return ret;
> +		/*
> +		 * early mapped ioapci overrides ACPI IVRS,
> +		 * they should be always controlled by iommu.
> +		 */
> +		set_iommu_for_device(iommu, early_ioapic_map[i].devid);
>  	}
>  
>  	for (i = 0; i < early_hpet_map_size; ++i) {
> @@ -767,6 +772,11 @@ static int __init add_early_maps(void)
>  					 early_hpet_map[i].cmd_line);
>  		if (ret)
>  			return ret;
> +		/*
> +		 * early mapped hpet overrides ACPI IVRS,
> +		 * they should be always controlled by iommu.
> +		 */
> +		set_iommu_for_device(iommu, early_hpet_map[i].devid);

This doesn't work on machines with multiple IOMMUs in it. Also the
problem only exists if there is no IVHD entry in the IVRS table for the
device containing IOAPIC and HPET.

But if this IVHD entry is not present we can't reliably know which IOMMU
is responsible for a given IOAPIC/HPET.


	Joerg

