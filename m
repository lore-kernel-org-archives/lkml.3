Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3KSKZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:25:41 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:36972 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3KSKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:25:38 -0500
Date: Tue, 19 Nov 2013 11:25:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: swarren@nvidia.com, will.deacon@arm.com, grant.likely@linaro.org,
        swarren@wwwdotorg.org, galak@codeaurora.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Message-ID: <20131119102506.GG31504@ulmo.nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
 <1384853593-32202-3-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2NLGdgz3UMHa/lqP"
Content-Disposition: inline
In-Reply-To: <1384853593-32202-3-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2013 at 11:33:06AM +0200, Hiroshi Doyu wrote:
> IOMMU devices on the bus need to be poplulated first, then iommu
> master devices are done later.
>=20
> With CONFIG_OF_IOMMU, "iommus=3D" DT binding would be used to identify
> whether a device can be an iommu msater or not. If a device can, we'll
> defer to populate that device till an iommu device is populated. Once
> an iommu device is populated, "dev->bus->iommu_ops" is set in the
> bus. Then, those defered iommu master devices are populated and
> configured for IOMMU with help of the already populated iommu device
> via iommu_ops->add_device(). Multiple IOMMUs can be listed on this
> "iommus" binding so that a device can have multiple IOMMUs attached.
>=20
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
> v5:
> Use "iommus=3D" binding instread of arm,smmu's "#stream-id-cells".
>=20
> v4:
> This is newly added, and the successor of the following RFC:
>   [RFC][PATCHv3+ 1/2] driver/core: Add of_iommu_attach()
>   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006914.h=
tml
> ---
>  drivers/base/dd.c        |  5 +++++
>  drivers/iommu/of_iommu.c | 22 ++++++++++++++++++++++
>  include/linux/of_iommu.h |  7 +++++++
>  3 files changed, 34 insertions(+)
>=20
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 35fa368..6e892d4 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -25,6 +25,7 @@
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pinctrl/devinfo.h>
> +#include <linux/of_iommu.h>
> =20
>  #include "base.h"
>  #include "power/power.h"
> @@ -273,6 +274,10 @@ static int really_probe(struct device *dev, struct d=
evice_driver *drv)
> =20
>  	dev->driver =3D drv;
> =20
> +	ret =3D of_iommu_attach(dev);
> +	if (ret)
> +		goto probe_failed;
> +
>  	/* If using pinctrl, bind pins now before probing */
>  	ret =3D pinctrl_bind_pins(dev);
>  	if (ret)
> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
> index ee249bc..4aef2b2 100644
> --- a/drivers/iommu/of_iommu.c
> +++ b/drivers/iommu/of_iommu.c
> @@ -20,6 +20,8 @@
>  #include <linux/export.h>
>  #include <linux/limits.h>
>  #include <linux/of.h>
> +#include <linux/device.h>
> +#include <linux/iommu.h>
> =20
>  /**
>   * of_get_dma_window - Parse *dma-window property and returns 0 if found.
> @@ -88,3 +90,23 @@ int of_get_dma_window(struct device_node *dn, const ch=
ar *prefix, int index,
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(of_get_dma_window);
> +
> +int of_iommu_attach(struct device *dev)
> +{
> +	int i;
> +	struct of_phandle_args args;
> +	struct iommu_ops *ops =3D dev->bus->iommu_ops;
> +
> +	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
> +					       "#iommu-cells", i, &args) {
> +		pr_debug("%s(i=3D%d) ops=3D%p %s\n",
> +			 __func__, i, ops, dev_name(dev));
> +
> +		if (!ops)
> +			return -EPROBE_DEFER;
> +	}
> +
> +	if (i && ops->add_device)
> +		return ops->add_device(dev);
> +	return 0;
> +}

I don't think this does what it's supposed to do. As far as I can tell
there's no way the above loop won't run to parse all phandles and their
arguments unless the DT is actually wrong.

=46rom earlier discussions I thought the goal was to actually defer this
until all nodes referred to by the iommus property were actually
registered. The above only checks that the phandles can be resolved to
valid struct device_node:s. That doesn't mean that an actual IOMMU has
been registered for it, only that the devices have been created.

I think within that loop you need to look up the IOMMU corresponding to
the struct device_node in args.np. If no match is found, then return
-EPROBE_DEFER.

If you really only rely on dev->bus->iommu_ops to be present, then there
is no need to go through the loop in the first place, since you have
access to it immediately through the struct device that's passed into
the function.

Furthermore, relying on dev->bus->iommu_ops will prevent multiple IOMMUs
=66rom being used at all, since only one IOMMU can register iommu_ops with
the bus, right? So I think what we really need here is a way to resolve
the IOMMU using a phandle and return the associated struct iommu_ops.

I also have some trouble understanding how the current IOMMU framework
is supposed to work together with multiple IOMMUs for one device. The
=2Eadd_device() callback seems to be missing crucial information to help
decide whether the device to be added is actually one that it covers.
Also with an of_iommu_attach() function, doesn't that become more or
less redundant?

Thierry

--2NLGdgz3UMHa/lqP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSizyCAAoJEN0jrNd/PrOhijEQAI5eezs+iulpHrq+OkISmNDT
As9PLVCa8gfPFUElMCBzZYs9xMNOICtPnFbPfGBx1Fo/ukmpXDbSbuQ8KOeTPcSY
gXk4eJyXIDLZtKRdHjNj20Cb215QjJqnPIT0b2qlah0MEIyeAMZ5VQbCOymABn15
ciTJUvIqkJJsdYr3jQf5NV65oINNP+ydCHhz2LLRwQYeC2BqCF4a/5a/CRzsCskA
576TRR3l4zxFh/b1jr+urzHm9d3/9uuqNIX1lmYWx0kipn/3Fy8VJUjSSJdqzevr
63JaL2Q0VWBImk7tJRFsiADsmylR0GZnlC+vfbiwbGZY+Wlm/c4pmV+KSgDbYjA6
plvH71+viVZrESVFmB7w6L2EbJ1Wtkwivf330+LwRl2ip7F71jMZAaLhm3TurJ4v
t6WKSuwSkxLNw9c/Zs5pYpudmCXJHa+CIeuqMQTFYtiHFDfFskg/+lbWduP/w0FG
2tqUei9YbnTR0TpmGIB+Bj6s3RRmazGBDFE2cPp0mAXc8sUNTmCMf2xEbsNJ2Mct
uYa4Tbowz2RBzS3AASXUeOc6wObQx6i1auWtE2Mc85hYhIuPEdkexrRlnSQ+W9tL
ld9eWEAjfJIlJ0BeJ9q/TMRK9GrOqqOTcyPm0ka9MKxdajXXWhfWVAnnia8NBOzp
blvcPvnwdAa4HoK852nU
=eubF
-----END PGP SIGNATURE-----

--2NLGdgz3UMHa/lqP--
