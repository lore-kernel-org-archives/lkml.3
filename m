Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaJJSAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:00:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55866 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaJJSAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:00:40 -0400
Date: Fri, 10 Oct 2014 12:59:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] rtc: omap: fix class-device registration
Message-ID: <20141010175919.GO31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-4-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZaW/dtY/7oMe/vLp"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-4-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZaW/dtY/7oMe/vLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:25PM +0200, Johan Hovold wrote:
> Make sure not to register the class device until after it has been
> configured and interrupt handlers registered at probe.
>=20
> Currently, the device is not fully configured (e.g. 24-hour mode) when
> the class device is registered, something which involves driver
> callbacks for example to read the current time.
>=20
> This reordering also prevents user space from enabling an alarm before
> an interrupt handler has been registered.
>=20
> Note that the interrupts are now registered using the platform-device
> rather than class-device name.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/rtc/rtc-omap.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index 828cb9983cc2..2eca141e784e 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -147,8 +147,9 @@ static void rtc_wait_not_busy(void)
>  	/* now we have ~15 usec to read/write various registers */
>  }
> =20
> -static irqreturn_t rtc_irq(int irq, void *rtc)
> +static irqreturn_t rtc_irq(int irq, void *dev_id)
>  {
> +	struct rtc_device	*rtc =3D platform_get_drvdata(dev_id);
>  	unsigned long		events =3D 0;
>  	u8			irq_data;
> =20
> @@ -164,7 +165,8 @@ static irqreturn_t rtc_irq(int irq, void *rtc)
>  	if (irq_data & OMAP_RTC_STATUS_1S_EVENT)
>  		events |=3D RTC_IRQF | RTC_UF;
> =20
> -	rtc_update_irq(rtc, 1, events);
> +	if (rtc)
> +		rtc_update_irq(rtc, 1, events);
> =20
>  	return IRQ_HANDLED;
>  }
> @@ -416,17 +418,6 @@ static int __init omap_rtc_probe(struct platform_dev=
ice *pdev)
>  		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
>  	}
> =20
> -	device_init_wakeup(&pdev->dev, true);
> -
> -	rtc =3D devm_rtc_device_register(&pdev->dev, pdev->name,
> -			&omap_rtc_ops, THIS_MODULE);
> -	if (IS_ERR(rtc)) {
> -		pr_debug("%s: can't register RTC device, err %ld\n",
> -			pdev->name, PTR_ERR(rtc));
> -		goto fail0;
> -	}
> -	platform_set_drvdata(pdev, rtc);
> -
>  	/* clear pending irqs, and set 1/second periodic,
>  	 * which we'll use instead of update irqs
>  	 */
> @@ -450,14 +441,14 @@ static int __init omap_rtc_probe(struct platform_de=
vice *pdev)
> =20
>  	/* handle periodic and alarm irqs */
>  	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
> -			dev_name(&rtc->dev), rtc)) {
> +			dev_name(&pdev->dev), pdev)) {
>  		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
>  			pdev->name, omap_rtc_timer);
>  		goto fail0;
>  	}
>  	if ((omap_rtc_timer !=3D omap_rtc_alarm) &&
>  		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
> -			dev_name(&rtc->dev), rtc))) {
> +			dev_name(&pdev->dev), pdev))) {

i don't get it. Why pass pdev as cookie when all you need is rtc ?
Doesn't sound very good to me. Also, IRQ handler *must* be registered
only after RTC is registered. That's because if you request an IRQ here,
you could already have a pending interrupt and since you won't have a
valid rtc pointer you won't be able to clear the interrupt line.

--=20
balbi

--ZaW/dtY/7oMe/vLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB6CAAoJEIaOsuA1yqREvtsP/00wO4uD4+Wd2+Oc35cZIktB
oUT5yAm+9sh46csWXLnr3iAfx107oNkpe7OrilU8i/xXvoPnkxsg2LYom9+vnkad
bl+VxVTANt2vf9AotE9gLlXF6jN22M6F0Zz/uXq4narXSbxqgk7TZndUPoNT1pdd
jom/XPeIrVy+HGciBBOQIGEvJnRLjYxr4rnJSzT446fZ/ZDlSBJm6mpCaOBST9wr
2vYGLPsNAs0zw7dy3+e78RBXUeyD+A7r/WbfjAoknlF8zWdy2W0RDWz2uYZTcYSI
MiuJzxI/afYGqIZeSIPKNQw9lByct1FY7W5sLDwXNoF3VuWjRSkwL3bjaT6t/GjO
TOjQCyDH7P8LfvqmecLiKIlTa6fD0mkwPDsvtzx5f8riSyXn0ztYljXP3+tXOo7w
qyXdMTldyv4QFQVBfBYU4m+bmTBusXGUxW1BwCZAd6owxMvZW/zi5TJi9Lj39x0Q
tEwCWFJ54yj5vauKFUOcsTsLAnQk6P8tekfW79lH3mvCTrLDo1kwshnmBJBYgSOh
bd1NFFBwHF6XO12AyThB3nd0dCVQzsVy9DhbrYKl3mV/6qgYq2cMUrBCR9eas92o
n3JCgKr0uwAQ2WniKa9WvXlForEncz4AvPM2wLlxbTq1LCdB/K+ExQvoT+UI+pN/
gJP1vxNGHf2GkDUtIEXY
=UKD1
-----END PGP SIGNATURE-----

--ZaW/dtY/7oMe/vLp--
