Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaI3H1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:27:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52766 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbaI3H1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:27:31 -0400
Date: Tue, 30 Sep 2014 09:27:27 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "'Heiko =?UTF-8?B?U3TDvGJuZXIn?=" <heiko@sntech.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, b29396@freescale.com,
        lee.jones@linaro.org, tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        kgene.kim@samsung.com, Li.Xiubo@freescale.com, geert+renesas@glider.be,
        swarren@nvidia.com, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v6] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20140930092727.12c34f05@bbrezillon>
In-Reply-To: <000d01cfdc63$99576bb0$cc064310$@samsung.com>
References: <1411980458-32329-1-git-send-email-pankaj.dubey@samsung.com>
	<1617081.XFKIz4hM4O@phil>
	<000d01cfdc63$99576bb0$cc064310$@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On Tue, 30 Sep 2014 09:33:38 +0530
Pankaj Dubey <pankaj.dubey@samsung.com> wrote:

> Hi,
> 
> On Monday, September 29, 2014 9:38 PM, Heiko Stübner wrote,
> > Am Montag, 29. September 2014, 14:17:38 schrieb Pankaj Dubey:
> > > Currently a syscon entity can be only registered directly through a
> > > platform device that binds to a dedicated syscon driver. However in
> > > certain use cases it is desirable to make a device used with another
> > > driver a syscon interface provider.
> > >
> > > For example, certain SoCs (e.g. Exynos) contain system controller
> > > blocks which perform various functions such as power domain control,
> > > CPU power management, low power mode control, but in addition contain
> > > certain IP integration glue, such as various signal masks, coprocessor
> > > power control, etc. In such case, there is a need to have a dedicated
> > > driver for such system controller but also share registers with other
> > > drivers. The latter is where the syscon interface is helpful.
> > >
> > > In case of DT based platforms, this patch decouples syscon object from
> > > syscon platform driver, and allows to create syscon objects first time
> > > when it is required by calling of syscon_regmap_lookup_by APIs and
> > > keep a list of such syscon objects along with syscon provider
> > > device_nodes and regmap handles.
> > >
> > > For non-DT based platforms, this patch keeps syscon platform driver
> > > structure where is can be probed and such non-DT based drivers can use
> > > syscon_regmap_lookup_by_pdev API and get access to regmap handles.
> > > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > > we can completely remove platform driver of syscon, and keep only
> > > helper functions to get regmap handles.
> > >
> > > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > ---
> > 
> > On Rockchip boards during core clock init (aka before timers)
> > Tested-by: Heiko Stuebner <heiko@sntech.de>
> > 
> 
> Thanks for testing.
> 
> > Except one issue described inline below
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > 
> > And I'm really looking forward to having this in the kernel :-)

Me too :-).

> > 
> > Thanks for working on this
> > Heiko
> > 
> > 
> 
> [snip]
> 
> > >
> > >  drivers/mfd/syscon.c |  106
> > > +++++++++++++++++++++++++++++++++++++++----------- 1 file
> > changed, 84
> > > insertions(+), 22 deletions(-)
> > >
> > > diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c index
> > > ca15878..00a8410 100644
> > > --- a/drivers/mfd/syscon.c
> > > +++ b/drivers/mfd/syscon.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/err.h>
> > >  #include <linux/io.h>
> > >  #include <linux/module.h>
> > > +#include <linux/list.h>
> > >  #include <linux/of.h>
> > >  #include <linux/of_address.h>
> > >  #include <linux/of_platform.h>
> > > @@ -22,31 +23,104 @@
> > >  #include <linux/platform_device.h>
> > >  #include <linux/regmap.h>
> > >  #include <linux/mfd/syscon.h>
> > > +#include <linux/slab.h>
> > >
> > >  static struct platform_driver syscon_driver;
> > >
> > > +static DEFINE_SPINLOCK(syscon_list_slock);
> > > +static LIST_HEAD(syscon_list);
> > > +
> > >  struct syscon {
> > > +	struct device_node *np;
> > >  	struct regmap *regmap;
> > > +	struct list_head list;
> > > +};
> > > +
> > > +static struct regmap_config syscon_regmap_config = {
> > > +	.reg_bits = 32,
> > > +	.val_bits = 32,
> > > +	.reg_stride = 4,
> > >  };
> > >
> > > -static int syscon_match_node(struct device *dev, void *data)
> > > +static struct syscon *of_syscon_register(struct device_node *np)
> > >  {
> > > -	struct device_node *dn = data;
> > > +	struct syscon *syscon;
> > > +	struct regmap *regmap;
> > > +	void __iomem *base;
> > > +	int ret;
> > > +	enum regmap_endian endian = REGMAP_ENDIAN_DEFAULT;
> > > +
> > > +	if (!of_device_is_compatible(np, "syscon"))
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > > +	if (!syscon)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	base = of_iomap(np, 0);
> > > +	if (!base) {
> > > +		ret = -ENOMEM;
> > > +		goto err_map;
> > > +	}
> > > +
> > > +	/* Parse the device's DT node for an endianness specification */
> > > +	if (of_property_read_bool(np, "big-endian"))
> > > +		endian = REGMAP_ENDIAN_BIG;
> > > +	 else if (of_property_read_bool(np, "little-endian"))
> > > +		endian = REGMAP_ENDIAN_LITTLE;
> > > +
> > > +	/* If the endianness was specified in DT, use that */
> > > +	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > +		syscon_regmap_config.val_format_endian = endian;
> > > +
> > > +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > > +	if (IS_ERR(regmap)) {
> > > +		pr_err("regmap init failed\n");
> > > +		ret = PTR_ERR(regmap);
> > > +		goto err_regmap;
> > > +	}
> > > +
> > > +	syscon->regmap = regmap;
> > > +	syscon->np = np;
> > > +
> > > +	spin_lock(&syscon_list_slock);
> > > +	list_add_tail(&syscon->list, &syscon_list);
> > > +	spin_unlock(&syscon_list_slock);
> > >
> > > -	return (dev->of_node == dn) ? 1 : 0;
> > > +	/* Change back endianness of syscon_regmap_config.
> > > +	 * As this is static config in this file and in one system we may
> > > +	 * have more than one syscon
> > > +	 */
> > > +	syscon_regmap_config.val_format_endian =
> > REGMAP_ENDIAN_DEFAULT;
> > 
> > This should also be done in the error case. Currently when you goto
> err_regmap the
> > overridden value will be left in the struct.
> > 
> 
> Thanks, will handle this in error condition also.
> 
> > While on this, is there a concurrency issue here, aka of_syscon_register
> could be
> > called in parallel and what happens with
> syscon_regmap_config.val_format_endian
> > then?
> 
> I can think of two approaches to solve this.
> 
> 1: Updating syscon_regmap_config, under spin_lock "syscon_list_slock".
> 2: Creation of local copy of syscon_regmap_config in "of_syscon_register"
> and using 
> it. In this case changing back of endianness in syscon_regmap_config, will
> not be needed
> and code will be a bit cleaner.
> 
> I would prefer second one, what is your opinion?

I too prefer the second solution, but it's not my call :-).

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
