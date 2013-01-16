Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3APQ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:58:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36619 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab3APQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:58:26 -0500
Date: Wed, 16 Jan 2013 18:57:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@linux.intel.com>
CC: <arve@android.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mikechan@google.com>
Subject: Re: [PATCH 02/10] goldfish: add the goldfish virtual bus
Message-ID: <20130116165754.GA6377@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
 <20130116165850.15183.72063.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20130116165850.15183.72063.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 16, 2013 at 04:58:51PM +0000, Alan Cox wrote:
> +static irqreturn_t goldfish_pdev_bus_interrupt(int irq, void *dev_id)
> +{
> +	irqreturn_t ret =3D IRQ_NONE;
> +	while (1) {
> +		u32 op =3D readl(pdev_bus_base + PDEV_BUS_OP);
> +		switch (op) {
> +		case PDEV_BUS_OP_DONE:
> +			return IRQ_NONE;
> +
> +		case PDEV_BUS_OP_REMOVE_DEV:
> +			goldfish_pdev_remove();
> +			break;
> +
> +		case PDEV_BUS_OP_ADD_DEV:
> +			goldfish_new_pdev();
> +			break;
> +		}
> +		ret =3D IRQ_HANDLED;
> +	}

missing a return ret here ?

> +}
> +
> +static int goldfish_pdev_bus_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct resource *r;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (r =3D=3D NULL)
> +		return -EINVAL;
> +
> +	pdev_bus_addr =3D r->start;
> +	pdev_bus_len =3D resource_size(r);
> +
> +	if (request_region(pdev_bus_addr, pdev_bus_len, "goldfish")) {
> +		pr_err("unable to reserve Goldfish MMIO.\n");
> +		return -EBUSY;
> +	}
> +
> +	pdev_bus_base =3D ioremap(pdev_bus_addr, pdev_bus_len);

how about converting the two above to devm_request_and_ioremap() ?

> +	if (pdev_bus_base =3D=3D NULL) {
> +		ret =3D -ENOMEM;
> +		pr_err("unable to map Goldfish MMIO.\n");
> +		goto free_resources;
> +	}
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (r =3D=3D NULL) {
> +		ret =3D -ENOENT;
> +		goto free_map;
> +	}
> +
> +	pdev_bus_irq =3D r->start;
> +
> +	ret =3D request_irq(pdev_bus_irq, goldfish_pdev_bus_interrupt,

and here to devm_request_irq() ...

> +				IRQF_SHARED, "goldfish_pdev_bus", pdev);
> +	if (ret)
> +		goto free_map;
> +
> +	writel(PDEV_BUS_OP_INIT, pdev_bus_base + PDEV_BUS_OP);
> +	return 0;
> +
> +free_map:
> +	iounmap(pdev_bus_base);
> +free_resources:
> +	release_region(pdev_bus_addr, pdev_bus_len);
> +	return ret;
> +}
> +
> +static int goldfish_pdev_bus_remove(struct platform_device *pdev)
> +{
> +	iounmap(pdev_bus_base);
> +	free_irq(pdev_bus_irq, pdev);
> +	release_region(pdev_bus_addr, pdev_bus_len);

your remove would, then, be an empty function.

--=20
balbi

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9twSAAoJEIaOsuA1yqRE6mwP/in7pzaKyKOgVaWAmdeCmhHd
araEO5fmiKooUXdR/VlE5pCf1me9OzzlZu/AEPdL1j7SsYEXRVul4k5uD5bLdhuR
TfcUAlfRZ97Qlra1CwDhpV0JT/SikjcJ4teVWTXMdRCChE1MzN/Dw/pd6UQWNie3
aBgYUPzIzPvFCysbx8LhW/uyoKJvO6FWAZ+8ktPE/DrMd5rRA2/IDHK4q1L2jXjH
04muQECriJ6BuCntKW/LBNReb36f95THuFpUQoIv+dFU6g+drcM4yYylqYEA53qq
wyCtwRDd9X+nA0fMnZBFJkIJtE4nc5r0YTJZv6boLiaqo0MeiotlznVw37MjKiLH
0SycmkHLUnqwSAM6lHQR7JKWQXjFpS+hSQb6ctZ6TmKGfy1PKK3115hvMNAJBLti
553fJ5ii/zArxNl5XxuLx5PuB+O+ictioY2JmYvOIx45zJkCOwmfPXFfrW96RK0s
l0Q3LGxgmBp6d/0ZE80opRMt4qJIkBsHDmN+zugrPbTmuEphYyt10bc/txIL6JIK
0MnOX4vWduxpcfvSWcVRXJrd+XC6f20I1PdkfC3eMMVZc032GhOnBiDgETf10yJu
nl02byC6umuw5BWsCdPYWMKXASyUR3uU7ftJNj5/CYZp7/Km/YrP+CVDbVpyCop/
4KM46Uzd1kgf9uhQycWS
=AH8y
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
