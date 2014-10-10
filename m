Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaJJSB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:01:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60465 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaJJSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:01:57 -0400
Date: Fri, 10 Oct 2014 13:00:54 -0500
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
Subject: Re: [PATCH 07/12] rtc: omap: silence bogus power-up reset message at
 probe
Message-ID: <20141010180054.GS31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-8-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9FEOsnejx470nED"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-8-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--m9FEOsnejx470nED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:29PM +0200, Johan Hovold wrote:
> Some legacy RTC IP revisions has a power-up reset flag in the status
> register that later revisions lack.
>=20
> As this flag is always read back as set on later revisions (or is
> overloaded with a different flag), make sure to only clear the flag and
> print the info message on legacy platforms.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/rtc/rtc-omap.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index 1c58920b0c88..0ef016553a97 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -118,6 +118,12 @@
>   */
>  #define OMAP_RTC_HAS_32KCLK_EN		BIT(2)
> =20
> +/*
> + * Some legacy RTC IP revisions has a power-up reset flag which later
> + * revisions lack.
> + */
> +#define OMAP_RTC_HAS_POWER_UP_RESET	BIT(3)
> +
>  static void __iomem	*rtc_base;
> =20
>  #define rtc_read(addr)		readb(rtc_base + (addr))
> @@ -347,6 +353,7 @@ static int omap_rtc_timer;
>  static struct platform_device_id omap_rtc_devtype[] =3D {
>  	{
>  		.name	=3D DRIVER_NAME,
> +		.driver_data =3D OMAP_RTC_HAS_POWER_UP_RESET,
>  	},
>  	[OMAP_RTC_DATA_AM3352_IDX] =3D {
>  		.name	=3D "am3352-rtc",
> @@ -376,7 +383,7 @@ static int __init omap_rtc_probe(struct platform_devi=
ce *pdev)
>  {
>  	struct resource		*res;
>  	struct rtc_device	*rtc;
> -	u8			reg, new_ctrl;
> +	u8			reg, mask, new_ctrl;
>  	const struct platform_device_id *id_entry;
>  	const struct of_device_id *of_id;
> =20
> @@ -429,12 +436,16 @@ static int __init omap_rtc_probe(struct platform_de=
vice *pdev)
> =20
>  	/* clear old status */
>  	reg =3D rtc_read(OMAP_RTC_STATUS_REG);
> -	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
> -		dev_info(&pdev->dev, "RTC power up reset detected\n");
> -		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
> +
> +	mask =3D OMAP_RTC_STATUS_ALARM;
> +	if (id_entry->driver_data & OMAP_RTC_HAS_POWER_UP_RESET) {
> +		mask |=3D OMAP_RTC_STATUS_POWER_UP;
> +		if (reg & OMAP_RTC_STATUS_POWER_UP)
> +			dev_info(&pdev->dev, "RTC power up reset detected\n");
>  	}
> -	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
> -		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
> +
> +	if (reg & mask)
> +		rtc_write(reg & mask, OMAP_RTC_STATUS_REG);
> =20
>  	/* handle periodic and alarm irqs */
>  	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
> --=20
> 2.0.4
>=20

--=20
balbi

--m9FEOsnejx470nED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB7WAAoJEIaOsuA1yqREIhsP/3nk3NYTQb7jg3UpknWTojaP
4oMcNxM9Ij5dtFGHe3NZpWW8cjNeyMdNxTftmuEUgWe4BZaK/lgnxfnLaVS+LnPA
0SFqQqvefbJTLUyKenABwZd33nCaUMV7rkPaj7vphUv24eE0TkLG2VTaSMDpvc/t
LCWbu6jhOc2z5t3uDliHWeWGpuwWt/UmcNvY73Ku12Hc5OXDY0Yx72xAaVtzDxk6
uXpbZptM0ycr7rZaLkkCop4y5BiKuClFg+zNaMP9QLuhVB9g5logKHq5SS2WbJBW
vwnhfY5HyvFCIos8n2ZsWrE9h+AaVIdM/K58ZhaqmEFDGfkKArDNp6nlb22fy1nb
3jNv8d8XvYjteilHQh/BOBYHE52mKMIp806/EER/kcpGkK0tsVh1dPawgST3ANKc
a09xjfkEFDQWk5Kj4GGrlpJ64LX0fzQrZyXx7gm9sfsNdDBEfWOs67ZhUaiftYCo
pDACYP6mApt28xQItNRaSkpjFHQ5dN50dnSPg3TFQfiWEwICP5C94i2kY0ituXN2
eu45UuS1DgKIZyOvbtS63xOmsezT3kYkPo8nOtStH47lsyO3vmYQwRpsmQn/BNdr
6ydjnb6kBkAx40iQYcGFweQVQYck+0UB/4nV7I+CbEYJJlzKjlXG/pbAXmrj4U6B
nLUug9R7NIkBty1vfKSw
=yhv6
-----END PGP SIGNATURE-----

--m9FEOsnejx470nED--
