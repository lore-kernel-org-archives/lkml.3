Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3CRGiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 02:38:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13084 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3CRGiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 02:38:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 17 Mar 2013 23:31:03 -0700
Subject: Re: [PATCH] ARM: tegra114: add speedo-based process identification
From: Danny Huang <dahuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Joseph Lo <josephl@nvidia.com>, Prashant Gaikwad <pgaikwad@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <51435C08.2030402@wwwdotorg.org>
References: <1363246822-14597-1-git-send-email-dahuang@nvidia.com>
	 <51435C08.2030402@wwwdotorg.org>
Date: Mon, 18 Mar 2013 14:38:02 +0800
Message-ID: <1363588682.4994.223.camel@dahuang-vm>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 01:36 +0800, Stephen Warren wrote:
> On 03/14/2013 01:40 AM, Danny Huang wrote:
> > Add speedo-based process identifictaion for Tegra114.
> > 
> > Based on the work by:
> > Alex Frid <afrid@nvidia.com>
> 
> This code is surprisingly quite a bit simpler than the existing
> tegra30_speedo.c. Are you sure it's complete?

It's complete and working for now. But It may need update if we have
more sku/chip revision in the future.

> > diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
> 
> > @@ -137,6 +138,9 @@ void tegra_init_fuse(void)
> >  		tegra_fuse_spare_bit = TEGRA30_FUSE_SPARE_BIT;
> >  		tegra_init_speedo_data = &tegra30_init_speedo_data;
> >  		break;
> > +	case TEGRA114:
> > +		tegra_init_speedo_data = &tegra114_init_speedo_data;
> > +		break;
> 
> Don't you need to set tegra_fuse_spare_bit there just like all the other
> paths do?
> 

There is no need of spare fuse access for Tegra114 for now.

> > diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c
> 
> > +#define CORE_PROCESS_CORNERS_NUM	2
> > +#define CPU_PROCESS_CORNERS_NUM		2
> > +
> > +enum {
> > +	THRESHOLD_INDEX_0,
> > +	THRESHOLD_INDEX_1,
> > +	THRESHOLD_INDEX_COUNT,
> > +};
> > +
> > +static const u32 core_process_speedos[THRESHOLD_INDEX_COUNT]
> > +	[CORE_PROCESS_CORNERS_NUM] = {
> > +	{1123,     UINT_MAX},
> > +	{0,        UINT_MAX},
> > +};
> > +
> > +static const u32 cpu_process_speedos[THRESHOLD_INDEX_COUNT]
> > +	[CPU_PROCESS_CORNERS_NUM] = {
> > +	{1695,     UINT_MAX},
> > +	{0,        UINT_MAX},
> > +};
> 
> Those enums/tables are a lot smaller than Tegra30. I'm surprised if we
> end up making new chips simpler rather than more complex in this area.
> Are those tables complete?

That's currently all I have. I think we can add some more data in the
future when needed.

> 
> > +static void rev_sku_to_speedo_ids(int rev, int sku, int *threshold)
> > +{
> > +	u32 tmp;
> > +
> > +	switch (sku) {
> > +	case 0x00:
> > +	case 0x10:
> > +	case 0x05:
> > +	case 0x06:
> > +		tegra_cpu_speedo_id = 1;
> > +		tegra_soc_speedo_id = 0;
> > +		*threshold = THRESHOLD_INDEX_0;
> > +		break;
> > +
> > +	case 0x03:
> > +	case 0x04:
> > +		tegra_cpu_speedo_id = 2;
> > +		tegra_soc_speedo_id = 1;
> > +		*threshold = THRESHOLD_INDEX_1;
> > +		break;
> > +
> > +	default:
> > +		pr_err("Tegra114 Unknown SKU %d\n", sku);
> > +		tegra_cpu_speedo_id = 0;
> > +		tegra_soc_speedo_id = 0;
> > +		*threshold = THRESHOLD_INDEX_0;
> > +		break;
> > +	}
> > +
> > +	if (rev == TEGRA_REVISION_A01) {
> > +		tmp = tegra_fuse_readl(0x270) << 1;
> > +		tmp |= tegra_fuse_readl(0x26c);
> > +		if (!tmp)
> > +			tegra_cpu_speedo_id = 0;
> > +	}
> > +}
> 
> That's also a lot simpler than Tegra30. Are all those SKUs really valid
> for all chip revisions including A01 where the 0x270/0x26c fuses are clear?

Yes, currently the 0x26c/0x270 value affects all sku of A01 chips.

> If life really is this simple, then I should be happy:-) But I just want
> to check that this code really is accurate.
> 
> > +void tegra114_init_speedo_data(void)
> 
> The Tegra30 code has a couple BUILD_BUG_ON() here to ensure that the
> size of the {cpu,core}_process_speedos arrays match
> THRESHOLD_INDEX_COUNT. It'd be good to be consistent here.

I'll put the BUILD_BUG_ON back and make them consistent with Tegra30 in
next version. Thanks.

> 
> In general, the implementation of tegra114_init_speedo_data() is quite
> different from that of the existing tegra30_init_speedo_data(). It'd be
> nice if they were as similar as possible in structure so they could be
> easily compared. Can you take a look at the two and see if any changes
> are warranted in this patch?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


