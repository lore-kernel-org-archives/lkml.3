Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaIBPU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:20:28 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55404 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIBPU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:20:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, tomasz.figa@gmail.com,
        Tomasz Figa <t.figa@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform devices
Date: Tue, 02 Sep 2014 17:20:03 +0200
Message-ID: <6034841.GFrG3XCMdb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KE5lXrZ3HNqxqpKbbnk4n0gF8Vt4DcBREz3grPE5sbB
 DKR3KZW+hkSfE6DpzdPr5QTXwJ1V9ajLU2QWnTeJl56se6Qnc6
 jhsuLuTJwZYYhiT1lkjo2M/LJI5uX6MO+eM2Rkm8qY8wn+BEjl
 ewh3kZCR69o6LkqDarnK9gAs/nlURJPLpIys+VqxXFkkpsLpv7
 OTR8T8xr2UgZDwHefvIpZuXS2MGUZrni43Deq7+Q5ZxEpdSCKA
 OzSNMLmmW/XOqbnvbTStbCiUc8UONjI3qz1n6uKBnkfVWVeqTH
 kJg0/Et6+0kaaZ7BhIzlMzwxYZg7jkd5ctZPQjoSgRZvORuHst
 iquACpVfMn32YJLt9Wic=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2014 20:12:15 Pankaj Dubey wrote:
> Currently a syscon entity can only be registered directly through a
> platform device that binds to a dedicated syscon driver. However in
> certain cases it is required to bind a device with it's dedicated
> driver rather than binding with syscon driver.
> 
> For example, certain SoCs (e.g. Exynos) contain system controller
> blocks which perform various functions such as power domain control,
> CPU power management, low power mode control, but in addition contain
> certain IP integration glue, such as various signal masks,
> coprocessor power control, etc. In such case, there is a need to have
> a dedicated driver for such system controller but also share registers
> with other drivers. The latter is where the syscon interface is helpful.
> 
> This patch decouples syscon object from syscon platform driver, and
> allows to create syscon objects first time when it is required by
> calling of syscon_regmap_lookup_by APIs and keeps a list of such syscon
> objects along with syscon provider device_nodes and regmap handles.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
> V1 of this patchset [1] and related discussion can be found here [1].
>  
> Changes since v1:
>  - Removed of_syscon_unregister function.
>  - Modified of_syscon_register function and it will be used by syscon.c 
>    to create syscon objects whenever required. 
>  - Removed platform device support from syscon.
>  - Removed syscon_regmap_lookup_by_pdevname API support.
>  - As there are significant changes w.r.t patchset v1, I am taking over
>    author for this patchset from Tomasz Figa.

Note that you got the Signed-off-by: list wrong, you should never have
any people listed as Signed-off-by after your own name, and they should
be listed before your name only when you are forwarding their patches.

> Note: Current kernel has clps711x user of syscon_regmap_lookup_by_pdevname and 
> will be broken after this patch. As per discussion over here [1], patches 
> for making these drivers DT based are ready and once that is done they can use
> syscon_regmap_lookup_by_phandle or syscon_regmap_lookup_by_compatible.
> 
> [1]: https://lkml.org/lkml/2014/8/22/81

Adding Alexander Shiyan to Cc here, so we can make sure this is well
coordinated.

I'm also adding Michal Simek, since here was involved in earlier discussions
about doing this.

>  drivers/mfd/syscon.c       |  143 +++++++++++++-------------------------------
>  include/linux/mfd/syscon.h |    1 +
>  2 files changed, 44 insertions(+), 100 deletions(-)

I certainly like the diffstat ;-)

>  struct syscon {
> +	struct device_node *np;
>  	struct regmap *regmap;
> +	struct list_head list;
>  };

Right

> @@ -68,27 +72,6 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
>  
> -static int syscon_match_pdevname(struct device *dev, void *data)
> -{
> -	return !strcmp(dev_name(dev), (const char *)data);
> -}
> -
> -struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
> -{
> -	struct device *dev;
> -	struct syscon *syscon;
> -
> -	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> -				 syscon_match_pdevname);
> -	if (!dev)
> -		return ERR_PTR(-EPROBE_DEFER);
> -
> -	syscon = dev_get_drvdata(dev);
> -
> -	return syscon->regmap;
> -}
> -EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);

I think this can actually be left intact if that helps with clps71xx.
It could be done in a hacky way using bus_find_device_by_name()
to keep it simple, or in a somewhat nicer way by keeping the 
syscon platform_driver around for the non-DT case.


> +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		pr_err("regmap init failed\n");
> +		return ERR_CAST(regmap);
> +	}

The last time I looked over this code, I think it was not safe to
call regmap_init_mmio() with a NULL device pointer, and we decided
that should be fixed. Have you checked whether it is ok now?

	Arnd
