Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaD0RsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:48:00 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41812 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaD0Rr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:47:58 -0400
Date: Sun, 27 Apr 2014 19:47:53 +0200
From: Levente Kurusa <levex@linux.com>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/rtl8192e: userspace ptr deref + incorrect
 declarations
Message-ID: <20140427174753.GA25594@linux.com>
References: <1398618676-31095-1-git-send-email-domdevlin@free.fr>
 <1398618676-31095-2-git-send-email-domdevlin@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1398618676-31095-2-git-send-email-domdevlin@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Apr 27, 2014 at 07:11:16PM +0200, Dominique van den Broeck wrote:
> . userspace pointer dereference ;
> . missing inclusions of needed header files ;
> . unrequired static function declaration (confusing another *.c file).
>=20
> Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
> ---
> I submit this patch as a result for Task #16 of the Eudyptula Challenge.
>=20
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging=
/rtl8192e/rtl8192e/rtl_wx.c
> index 498995d..d87cdfa 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -17,8 +17,10 @@
>   * wlanfae <wlanfae@realtek.com>
>  ************************************************************************=
******/
> =20
> +#include <linux/uaccess.h>
>  #include <linux/string.h>
>  #include "rtl_core.h"
> +#include "rtl_wx.h"
> =20
>  #define RATE_COUNT 12
>  static u32 rtl8192_rates[] =3D {
> @@ -1130,11 +1132,18 @@ static int r8192_wx_set_PromiscuousMode(struct ne=
t_device *dev,
>  	struct r8192_priv *priv =3D rtllib_priv(dev);
>  	struct rtllib_device *ieee =3D priv->rtllib;
> =20
> -	u32 *info_buf =3D (u32 *)(wrqu->data.pointer);
> +	u32 info_buf[3];
> =20
> -	u32 oid =3D info_buf[0];
> -	u32 bPromiscuousOn =3D info_buf[1];
> -	u32 bFilterSourceStationFrame =3D info_buf[2];
> +	u32 oid;
> +	u32 bPromiscuousOn;
> +	u32 bFilterSourceStationFrame;
> +
> +	if (copy_from_user(info_buf, wrqu->data.pointer, sizeof(info_buf)))
> +		return -EFAULT;
> +
> +	oid =3D info_buf[0];
> +	bPromiscuousOn =3D info_buf[1];
> +	bFilterSourceStationFrame =3D info_buf[2];

I guess it would be better to have defines for those instead of
hard-coding the offsets. Also the size of the info_buf array
might change depending on the size of wrqu->data.pointer, right?
Maybe create a new define for that as well?

Let's just be safe and create new defines to prevent headaches in
the future, if not for futher expansion then for the sake of
legibility.

Thanks,
Levente Kurusa

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJTXULJAAoJELBqK2lO9dZBB10H/1pMYuUkLMURv0mDMuTrA8cG
o0h05QMtxKcfA8bJz3bqLfBmNBztEZ4acckK2bN733zN6Aa+fFq//UvhsOFn76iv
28oOYZ50JZkxiyI8ukrr7Ulo6IpB6wyL+Pr2Iccpv7eZLg98JzMlc/ja9RSLUREF
Zk7fMWdF16QCqetqLPQ8NUpaG8DvKVkFOGXgGjXPWoh5T6yfwDiaL+i2QcddWyfT
W9XMfcl1UYTfg7j9OtAmksXI9dkwyzzPktCYViC5D/7fA4cjIEHgIYUFMmvbVvDF
xv5YoqBaaQaEuL2/24dFuNR9rzfwbtTWsuLrFGpDajerfwEiFDDX5AA+VrrFQ7Q=
=kcv+
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
