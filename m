Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaHBLaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 07:30:23 -0400
Received: from sauhun.de ([89.238.76.85]:45054 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbaHBLaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 07:30:21 -0400
Date: Sat, 2 Aug 2014 13:30:01 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4] i2c: busses: i2c-pxa.c:  Fix for possible null
 pointer dereference
Message-ID: <20140802113001.GC2739@katana>
References: <1405545251-13087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1405545251-13087-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <1405545251-13087-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

>  	res =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	irq =3D platform_get_irq(dev, 0);
> -	if (res =3D=3D NULL || irq < 0) {
> -		ret =3D -ENODEV;
> -		goto eclk;
> -	}
> +	if (res =3D=3D NULL || irq < 0)
> +		return -ENODEV;

No need to check for valid 'res' here...

> =20
> -	if (!request_mem_region(res->start, resource_size(res), res->name)) {
> -		ret =3D -ENOMEM;
> -		goto eclk;
> -	}
> +	if (!devm_request_mem_region(&dev->dev, res->start,
> +				resource_size(res), res->name))
> +		return -ENOMEM;

=2E.. and no need to use 'devm_request_mem_region' ...

> -	i2c->reg_base =3D ioremap(res->start, resource_size(res));
> -	if (!i2c->reg_base) {
> -		ret =3D -EIO;
> -		goto eremap;
> -	}
> +	i2c->reg_base =3D devm_ioremap_resource(&adev->dev, res));
> +	if (IS_ERR(i2c->reg_base))
> +		return -EIO;

=2E.. because devm_ioremap_resource does all that for you. Also, don't
return -EIO but the PTR_ERR given from the function. Just check other
drivers how they do it.

> =20
>  	i2c->reg_ibmr =3D i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
>  	i2c->reg_idbr =3D i2c->reg_base + pxa_reg_layout[i2c_type].idbr;
> @@ -1227,10 +1218,12 @@ static int i2c_pxa_probe(struct platform_device *=
dev)
>  		i2c->adap.algo =3D &i2c_pxa_pio_algorithm;
>  	} else {
>  		i2c->adap.algo =3D &i2c_pxa_algorithm;
> -		ret =3D request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
> -				  dev_name(&dev->dev), i2c);
> -		if (ret)
> -			goto ereqirq;
> +		ret =3D devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
> +				 IRQF_SHARED, dev_name(&dev->dev), i2c);
> +		if (ret) {
> +			clk_disable_unprepare(i2c->clk);
> +			return ret;

Maybe you should make a error path with 'goto' out of it...


> +		}
>  	}
> =20
>  	i2c_pxa_reset(i2c);
> @@ -1244,7 +1237,7 @@ static int i2c_pxa_probe(struct platform_device *de=
v)
>  	ret =3D i2c_add_numbered_adapter(&i2c->adap);
>  	if (ret < 0) {
>  		printk(KERN_INFO "I2C: Failed to add bus\n");
> -		goto eadapt;
> +		return ret;

=2E.. since you forgot disable_unprepare here and could simply reuse it.


>  	}
> =20
>  	platform_set_drvdata(dev, i2c);
> @@ -1257,20 +1250,6 @@ static int i2c_pxa_probe(struct platform_device *d=
ev)
>  	       dev_name(&i2c->adap.dev));
>  #endif
>  	return 0;
> -
> -eadapt:
> -	if (!i2c->use_pio)
> -		free_irq(irq, i2c);
> -ereqirq:
> -	clk_disable_unprepare(i2c->clk);
> -	iounmap(i2c->reg_base);
> -eremap:
> -	clk_put(i2c->clk);
> -eclk:
> -	kfree(i2c);
> -emalloc:
> -	release_mem_region(res->start, resource_size(res));
> -	return ret;
>  }

You forgot to cleanup the remove function.

BTW I forgot, can you test this patch on real hardware? If not, is there
somebody who does?

All the best,

   Wolfram


--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3Mu5AAoJEBQN5MwUoCm2gaAP/2iH9y+g5cexLZS/fDMhiCk4
zayj3HE1sgCU0saveYUuYFTxTZ67YK62jroYsJDV75P7GtRnQQt/VpxngFEIlzXe
W/KZUcab1t24ka1NNwb5RKmHola8d1HcQyHw6R7pv9w7IVrO1bERX06/Ym8Pkdn1
slH6MpWdqEBS1SbbSeqs0FjJmXfCK7o7bGP+KlHyIGbpj/AZlxCJUmgA9v/ihu4e
OPj5QT+99Tcm8apVkQS7hgaZ/fIWMMCcqcbo6wQRT/R3Bmw4t7nxVqpieOTLjqwM
ii96zBUVuUduKVQT06n+UgLJWykzTkBffY/6lwI3iDQB7ob4EIyKR5l2MsODdPIm
vCXXYEHeBssYRf8PfgshSv6GiqsOR33USrSdUS8oghp69xSVrKBmvcXnSRuXNYUO
WUTcBdM19a+ntdpVe2C9SQrfGgNAq8/ngg3j21SDEtbL8GlNHbPNWxBOWFiV1gDp
kRnV9sSt7sBqge0KUQrRoWjLlHxnLgb86ObjIpYyg/T4IMxd9j/X21J+n6p9JM0C
wDckAaPbzDWUa6+clDdo8HGMFvYkZ9GE/JmZjF4pVtStp2PFmFzfRbw9xLGR4XpD
Olp1B5XPyL8Bcxm+x0tkt5gMBuIIraEt4vx76yRRz5XnYk8dFKh+tl98utZmCDSi
Rvkcbbp9qIAopzcR3Ll+
=RcT3
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
