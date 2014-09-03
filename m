Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaICNQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:16:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932411AbaICNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:16:15 -0400
Date: Wed, 3 Sep 2014 15:16:11 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Alexander Shiyan <shc_work@mail.ru>,
        naushad@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        linux-samsung-soc@vger.kernel.org, thomas.ab@samsung.com,
        tomasz.figa@gmail.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        lee.jones@linaro.org, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20140903151611.260a7218@bbrezillon>
In-Reply-To: <6034841.GFrG3XCMdb@wuerfel>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
	<6034841.GFrG3XCMdb@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm joining the thread cause I'm really interested in having a syscon
dev available during early init (I need it to share at91 PMC
registers among several subsystems, one of this subsystem being the CCF
which is called during early ARM boot process to register system
clocks).

On Tue, 02 Sep 2014 17:20:03 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 02 September 2014 20:12:15 Pankaj Dubey wrote:
> > Currently a syscon entity can only be registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain cases it is required to bind a device with it's dedicated
> > driver rather than binding with syscon driver.
> > 
> > For example, certain SoCs (e.g. Exynos) contain system controller
> > blocks which perform various functions such as power domain control,
> > CPU power management, low power mode control, but in addition contain
> > certain IP integration glue, such as various signal masks,
> > coprocessor power control, etc. In such case, there is a need to have
> > a dedicated driver for such system controller but also share registers
> > with other drivers. The latter is where the syscon interface is helpful.
> > 
> > This patch decouples syscon object from syscon platform driver, and
> > allows to create syscon objects first time when it is required by
> > calling of syscon_regmap_lookup_by APIs and keeps a list of such syscon
> > objects along with syscon provider device_nodes and regmap handles.
> > 
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> > V1 of this patchset [1] and related discussion can be found here [1].
> >  
> > Changes since v1:
> >  - Removed of_syscon_unregister function.
> >  - Modified of_syscon_register function and it will be used by syscon.c 
> >    to create syscon objects whenever required. 
> >  - Removed platform device support from syscon.
> >  - Removed syscon_regmap_lookup_by_pdevname API support.
> >  - As there are significant changes w.r.t patchset v1, I am taking over
> >    author for this patchset from Tomasz Figa.
> 
> Note that you got the Signed-off-by: list wrong, you should never have
> any people listed as Signed-off-by after your own name, and they should
> be listed before your name only when you are forwarding their patches.
> 
> > Note: Current kernel has clps711x user of syscon_regmap_lookup_by_pdevname and 
> > will be broken after this patch. As per discussion over here [1], patches 
> > for making these drivers DT based are ready and once that is done they can use
> > syscon_regmap_lookup_by_phandle or syscon_regmap_lookup_by_compatible.
> > 
> > [1]: https://lkml.org/lkml/2014/8/22/81
> 
> Adding Alexander Shiyan to Cc here, so we can make sure this is well
> coordinated.
> 
> I'm also adding Michal Simek, since here was involved in earlier discussions
> about doing this.
> 
> >  drivers/mfd/syscon.c       |  143 +++++++++++++-------------------------------
> >  include/linux/mfd/syscon.h |    1 +
> >  2 files changed, 44 insertions(+), 100 deletions(-)
> 
> I certainly like the diffstat ;-)
> 
> >  struct syscon {
> > +	struct device_node *np;
> >  	struct regmap *regmap;
> > +	struct list_head list;
> >  };
> 
> Right
> 
> > @@ -68,27 +72,6 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> >  }
> >  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> >  
> > -static int syscon_match_pdevname(struct device *dev, void *data)
> > -{
> > -	return !strcmp(dev_name(dev), (const char *)data);
> > -}
> > -
> > -struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
> > -{
> > -	struct device *dev;
> > -	struct syscon *syscon;
> > -
> > -	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > -				 syscon_match_pdevname);
> > -	if (!dev)
> > -		return ERR_PTR(-EPROBE_DEFER);
> > -
> > -	syscon = dev_get_drvdata(dev);
> > -
> > -	return syscon->regmap;
> > -}
> > -EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> 
> I think this can actually be left intact if that helps with clps71xx.
> It could be done in a hacky way using bus_find_device_by_name()
> to keep it simple, or in a somewhat nicer way by keeping the 
> syscon platform_driver around for the non-DT case.
> 
> 
> > +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		pr_err("regmap init failed\n");
> > +		return ERR_CAST(regmap);
> > +	}
> 
> The last time I looked over this code, I think it was not safe to
> call regmap_init_mmio() with a NULL device pointer, and we decided
> that should be fixed. Have you checked whether it is ok now?

I checked that part, and it appears most of the code is already there
(see usage of regmap_attach_dev function here [1]).

The only problem I see is that errors are still printed with dev_err,
which, AFAIK, will trigger a kernel panic if dev is NULL.
This is an issue in both the regmap_init function itself and the
regcache_init function (which is called by regmap_init).

BTW, maybe we should remove this line [2], as this is now part of the
regmap_attach_dev function [3] which is called at the end of
regmap_init if dev is not NULL [4].

Adding Mark in Cc.

Best Regards,

Boris

[1]http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L826
[2]http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L511
[3]http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L434
[4]http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L826


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
