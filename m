Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaBJLvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:51:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37669 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBJLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:51:00 -0500
Date: Mon, 10 Feb 2014 12:50:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: Re: [Nouveau] [PATCH] drm/nouveau: support for platform devices
Message-ID: <20140210115055.GC20143@ulmo.nvidia.com>
References: <1392011580-28093-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <1392011580-28093-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 02:53:00PM +0900, Alexandre Courbot wrote:
[...]
> diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/=
gpu/drm/nouveau/core/engine/device/base.c
[...]
> +resource_size_t
> +nv_device_resource_start(struct nouveau_device *device, unsigned int bar)
> +{
> +	if (nv_device_is_pci(device)) {
> +		return pci_resource_start(device->pdev, bar);
> +	} else {
> +		struct resource *res;
> +		res =3D platform_get_resource(device->platformdev,
> +					    IORESOURCE_MEM, bar);
> +		if (!res)
> +			return 0;
> +		return res->start;
> +	}
> +}
> +
> +resource_size_t
> +nv_device_resource_len(struct nouveau_device *device, unsigned int bar)
> +{
> +	if (nv_device_is_pci(device)) {
> +		return pci_resource_len(device->pdev, bar);
> +	} else {
> +		struct resource *res;
> +		res =3D platform_get_resource(device->platformdev,
> +					    IORESOURCE_MEM, bar);
> +		if (!res)
> +			return 0;
> +		return resource_size(res);
> +	}
> +}

Perhaps instead of these two, something like this could be done:

	const struct resource *
	nv_device_resource(struct nouveau_device *device, unsigned int bar)
	{
		if (nv_device_is_pci(device)
			return &device->pdev->resource[bar];
		else
			return platform_get_resource(device->platformdev,
						     IORESOURCE_MEM, bar);
	}

Then the more generic resource_size() can be used directly on the
returned struct resource *. Doing so may come in handy if you ever need
to display the resource for debugging purposes, since you could simply
use the %pR format specifier. It could also be slightly more efficient,
since the structure doesn't have to be looked up twice. But perhaps the
compiler will be clever enough to optimize that away and it's not like
this is called from a hot path.

I do see that pci_resource_len() does additional checking for BARs that
have zero size (start =3D=3D 0 && end =3D=3D start), so it's not exactly the
same, but I think there's another issue with that, see below.

> +int
> +nouveau_device_platform_create_(struct platform_device *pdev, u64 name,
> +				const char *sname, const char *cfg,
> +				const char *dbg, int length, void **pobject)
> +{
> +	struct nouveau_device *device;
> +	int ret =3D -EEXIST;
> +
> +	mutex_lock(&nv_devices_mutex);
> +	list_for_each_entry(device, &nv_devices, head) {
> +		if (device->handle =3D=3D name)
> +			goto done;
> +	}
> +
> +	ret =3D nouveau_engine_create_(NULL, NULL, &nouveau_device_oclass, true,
> +				     "DEVICE", "device", length, pobject);
> +	device =3D *pobject;
> +	if (ret)
> +		goto done;
> +
> +	device->platformdev =3D pdev;
> +	device->handle =3D name;
> +	device->cfgopt =3D cfg;
> +	device->dbgopt =3D dbg;
> +	device->name =3D sname;
> +
> +	nv_subdev(device)->debug =3D nouveau_dbgopt(device->dbgopt, "DEVICE");
> +	nv_engine(device)->sclass =3D nouveau_device_sclass;
> +	list_add(&device->head, &nv_devices);
> +done:
> +	mutex_unlock(&nv_devices_mutex);
> +	return ret;
> +}

I think there's some potential for refactoring here, since the only
difference that I can spot is in whether the pdev or the platformdev
fields are assigned.

> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c b/drivers/g=
pu/drm/nouveau/core/engine/graph/nv20.c
> index b24559315903..d145e080899a 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
> @@ -349,7 +349,7 @@ nv20_graph_init(struct nouveau_object *object)
>  	nv_wr32(priv, NV10_PGRAPH_SURFACE, tmp);
> =20
>  	/* begin RAM config */
> -	vramsz =3D pci_resource_len(nv_device(priv)->pdev, 0) - 1;
> +	vramsz =3D nv_device_resource_len(nv_device(priv), 0) - 1;

In case BAR0 is of size zero (start =3D=3D 0, end =3D=3D start), this will =
cause
underflow in the case of a PCI device, because pci_resource_len() will
return 0. I suspect that this never happens since that code's been there
since the dawn of time.

> diff --git a/drivers/gpu/drm/nouveau/core/include/core/device.h b/drivers=
/gpu/drm/nouveau/core/include/core/device.h
> index 7b8ea221b00d..2a3e24e1d392 100644
> --- a/drivers/gpu/drm/nouveau/core/include/core/device.h
> +++ b/drivers/gpu/drm/nouveau/core/include/core/device.h
> @@ -65,6 +65,7 @@ struct nouveau_device {
>  	struct list_head head;
> =20
>  	struct pci_dev *pdev;
> +	struct platform_device *platformdev;

I'm generally wondering if perhaps a better abstraction would be to
store a struct device * here, perhaps with a struct nouveau_device_ops *
or similar to abstract away the differences between PCI and platform
devices.

nouveau_device_create_() could then take a struct device * and a struct
nouveau_device_ops *, and upcasting can therefore be done within these
operations, rather than sprinkling nv_device_is_pci() code everywhere.

> diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/no=
uveau/nouveau_abi16.c
[...]
>  	case NOUVEAU_GETPARAM_BUS_TYPE:
> +		if (!nv_device_is_pci(device))
> +			getparam->value =3D 3;
> +		else
>  		if (drm_pci_device_is_agp(dev))
>  			getparam->value =3D 0;
>  		else

This is more of a general note since this patch doesn't introduce the
parameter. Perhaps it would be good to expose a symbolic name for the
various types of busses in a public header?

> diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nou=
veau/nouveau_chan.c
> index cc5152be2cf1..19c6e6c9fc45 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_chan.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
> @@ -154,7 +154,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct =
nouveau_cli *cli,
>  			 * nfi why this exists, it came from the -nv ddx.
>  			 */
>  			args.flags =3D NV_DMA_TARGET_PCI | NV_DMA_ACCESS_RDWR;
> -			args.start =3D pci_resource_start(device->pdev, 1);
> +			args.start =3D nv_device_resource_len(device, 1);

Should this have been nv_device_resource_start()?

> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouv=
eau/nouveau_drm.c
[...]
> @@ -345,7 +368,7 @@ nouveau_drm_load(struct drm_device *dev, unsigned lon=
g flags)
>  	/* make sure AGP controller is in a consistent state before we
>  	 * (possibly) execute vbios init tables (see nouveau_agp.h)
>  	 */
> -	if (drm_pci_device_is_agp(dev) && dev->agp) {
> +	if (pdev && drm_pci_device_is_agp(dev) && dev->agp) {

Perhaps move the check for valid PCI device into drm_pci_device_is_agp()
rather than requiring callers to check explicitly?

> @@ -384,8 +407,10 @@ nouveau_drm_load(struct drm_device *dev, unsigned lo=
ng flags)
>  	if (nv_device(drm->device)->chipset =3D=3D 0xc1)
>  		nv_mask(device, 0x00088080, 0x00000800, 0x00000000);
> =20
> -	nouveau_vga_init(drm);
> -	nouveau_agp_init(drm);
> +	if (pdev) {
> +		nouveau_vga_init(drm);
> +		nouveau_agp_init(drm);
> +	}

Same here. And if you make the above change, then nouveau_agp_init()
will do the right thing already.

>  	if (device->card_type >=3D NV_50) {
>  		ret =3D nouveau_vm_new(nv_device(drm->device), 0, (1ULL << 40),
> @@ -398,9 +423,11 @@ nouveau_drm_load(struct drm_device *dev, unsigned lo=
ng flags)
>  	if (ret)
>  		goto fail_ttm;
> =20
> -	ret =3D nouveau_bios_init(dev);
> -	if (ret)
> -		goto fail_bios;
> +	if (pdev) {
> +		ret =3D nouveau_bios_init(dev);
> +		if (ret)
> +			goto fail_bios;
> +	}

nouveau_bios_init() could also check internally and return 0 if the
device isn't a PCI device. One less conditional in this function.

> @@ -963,6 +991,25 @@ nouveau_drm_pci_driver =3D {
>  	.driver.pm =3D &nouveau_pm_ops,
>  };
> =20
> +

This adds a spurious newline.

> +int nouveau_drm_platform_probe(struct platform_device *pdev)
> +{
> +	struct nouveau_device *device;
> +	int ret;
> +
> +	ret =3D nouveau_device_platform_create(pdev, nouveau_platform_name(pdev=
),
> +					   dev_name(&pdev->dev), nouveau_config,
> +					   nouveau_debug, &device);
> +
> +	ret =3D drm_platform_init(&driver, pdev);
> +	if (ret) {
> +		nouveau_object_ref(NULL, (struct nouveau_object **)&device);
> +		return ret;
> +	}
> +
> +	return ret;
> +}

I think we should move the whole of gk20a probing into nouveau. Keeping
one part in tegra-drm and one part in nouveau is confusing, and I can't
see a reason why we'd have to keep it that way.

Thierry

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+L0fAAoJEN0jrNd/PrOhkZIP/1Yo5f7z/PLdfU6pdo/OE4At
+Jyzy6oNOSPxuvNIwKnKd6B/mtjSkrTrTUg4w8TZJjy3IsWPvIs9sDNXiiJ+etSC
HqzXAou57W0u6lA4tyfyZLnNWRFgcZFgD/J8QP4EsEkfJa0/kCdJ5C+6eC8QeUvg
4yBa7+rUxKVPCQm7KNUx8woDzbAwU5o80hdCj62K+lDr2Xu1/C7GAdB8DA2uZLko
8glfnpU/w8W1kCu6jqCsYrc776+wBwSJzHPocKurXq9fPSCyvAxF1WtumqxeYBEw
GtQwtqNxejxEYuAicdD3SpPkRPC3vNKQBIgqWFARCIWMgqKjhKJGuWILTRO3I3MR
XvHnKnZdofGCnEQ4SKc5MhPg3gDCwYrmYYzZIkQyzzD3seV+OY/2oE73CqOvK0AG
zpFEG8haklhQVWFDWowNfKBdn11XSHE1RlF4VinlBivYCccvXh0eqF2Io2np5r24
1+65ISLSd3YtzukuXzdvEgd8Xo0i0bzAk2vnG6iCF6TfRDHqzheaA0yqX6BfmVSH
JoHLjEFVVyjBF4n2YPKUSgHvu+bH2ve4sFOwDr+PjWLrY/t00fuY+2OI3l5nDIyj
NnSdJRpqaucDPHGRKrYaSrADSvoD4OD5AGWZV0H6/HUojZrr1U6q94I9ZXzk+jwl
q1MB7qn70Tdz9ZTG+Su8
=/p9y
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
