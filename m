Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaBFJLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:11:31 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7020 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaBFJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:11:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Feb 2014 01:09:24 -0800
Date: Thu, 6 Feb 2014 11:11:14 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>, Danny Huang <dahuang@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
Message-ID: <20140206091114.GK19389@tbergstrom-lnx.Nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
 <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com>
 <52F28DE2.1040207@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52F28DE2.1040207@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 08:15:46PM +0100, Stephen Warren wrote:
> On 01/28/2014 04:36 PM, Peter De Schrijver wrote:
> > Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.
> 
> I assume most of this code is simply cut/paste from the existing code in
> arch/arm/mach-tegra/? If so, "git format-patch -C" would have been
> useful to highlight what changed when duplicating the files.
> 

It also has been rewritten slightly. Also the Tegra124 speedo file is new.

> > diff --git a/Documentation/ABI/testing/sysfs-driver-tegra-fuse b/Documentation/ABI/testing/sysfs-driver-tegra-fuse
> > +What:		/sys/devices/*/<our-device>/fuse
> > +Date:		December 2013
> > +Contact:	Peter De Schrijver <pdeschrijver@nvidia.com>
> > +Description:	read-only access to the efuses on Tegra20, Tegra30, Tegra114
> > +		and Tegra124 SoC's from NVIDIA. The efuses contain write once
> > +		data programmed at the factory.
> > +Users:		any user space application which wants to read the efuses on
> > +		Tegra SoC's
> 
> Surely this file should describe the format of the file, since that's
> part of the ABI too, right?
> 

Part of the fuse data is ODM defined so possibly board specific.

> > diff --git a/drivers/misc/fuse/tegra/fuse-tegra20.c b/drivers/misc/fuse/tegra/fuse-tegra20.c
> 
> > +static int tegra20_fuse_probe(struct platform_device *pdev)
> ...
> > +	sku_info.revision = tegra_revision;
> > +	tegra20_init_speedo_data(&sku_info, &pdev->dev);
> ...
> > +}
> > +
> > +static struct platform_driver tegra20_fuse_driver = {
> > +	.probe = tegra20_fuse_probe,
> > +	.driver = {
> > +		.name = "tegra20_fuse",
> > +		.owner = THIS_MODULE,
> > +		.of_match_table = tegra20_fuse_of_match,
> > +	}
> > +};
> > +
> > +static int __init tegra20_fuse_init(void)
> > +{
> > +	return platform_driver_register(&tegra20_fuse_driver);
> > +}
> > +postcore_initcall(tegra20_fuse_init);
> 
> That call to tegra20_init_speedo_data() now happens much later in boot.
> Are you sure there's nothing that relies on data it sets up between when
> tegra_fuse_init() is called (which is where it happens before this
> series), and the somewhat arbitrary later time when this driver probes?
> 

Will check.

> > diff --git a/drivers/misc/fuse/tegra/fuse-tegra30.c b/drivers/misc/fuse/tegra/fuse-tegra30.c
> 
> > +postcore_initcall(tegra30_fuse_init);
> > +
> 
> There's a blank line at the end of the file. I thought checkpatch warned
> about this? But actually it doesn't seem to at least in -f mode.
> 
> > diff --git a/drivers/misc/fuse/tegra/fuse.h b/drivers/misc/fuse/tegra/fuse.h
> 
> > +struct tegra_sku_info {
> > +	int sku_id;
> > +	int cpu_process_id;
> > +	int cpu_speedo_id;
> > +	int cpu_speedo_value;
> > +	int cpu_iddq_value;
> > +	int core_process_id;
> > +	int soc_speedo_id;
> > +	int gpu_speedo_id;
> > +	int gpu_process_id;
> > +	int gpu_speedo_value;
> > +	enum tegra_revision revision;
> > +};
> 
> The only use of this appears to be to pass to tegra_fuse_create_sysfs()
> which prints out the fields. Will there be more users in the future?
> Otherwise, I'd be tempted to just print it out outside/before-calling
> tegra_fuse_create_sysfs().
> 
> That said, I wonder if these values could/should be exposed in the sysfs
> file to make it easier to interpret the fuses?
> 

That could be done I think...

> > diff --git a/drivers/misc/fuse/tegra/tegra114_speedo.c b/drivers/misc/fuse/tegra/tegra114_speedo.c
> 
> It might be nice to make these filenames consistent with the others,
> e.g. fuse-speedo-tegraNNN.c/speedo-tegraNNN.c, or wrap them into
> fuse-tegraNNN.c?
> 

I expect 1 speedo file per new SoC, but at least every SoC since Tegra30 has
used the same way of reading the fuse data. Hence I think it's better to
keep them separate.

> > diff --git a/drivers/misc/fuse/tegra/tegra30_speedo.c b/drivers/misc/fuse/tegra/tegra30_speedo.c
> 
> > +#define FUSE_SPEEDO_CALIB_0	0x14
> > +#define FUSE_PACKAGE_INFO	0XFC
> > +#define FUSE_TEST_PROG_VER	0X28
> 
> In arch/arm/mach-tegra/tegra30_speedo.c, those values are different:
> 
> #define FUSE_SPEEDO_CALIB_0	0x114
> #define FUSE_PACKAGE_INFO	0X1FC
> #define FUSE_TEST_PROG_VER	0X128
> 
> Was this change intentional? Perhaps it should be in a separate patch to
> highlight the change, if it's an intentional bug-fix?

This is intentional. The old files used the offset from the fuse IP block base
address. The new files use the offset in the fuse array.

Cheers,

Peter.
