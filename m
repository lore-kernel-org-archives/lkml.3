Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaG3OY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:24:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38352 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaG3OY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:24:27 -0400
Message-ID: <53D90008.4060908@ti.com>
Date: Wed, 30 Jul 2014 17:24:08 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <olaf@aepfle.de>, <apw@canonical.com>,
        <jasowang@redhat.com>, <kys@microsoft.com>, <haiyangz@microsoft.com>
Subject: Re: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
References: <1404875063-27424-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1404875063-27424-1-git-send-email-decui@microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="aVvRXgTRnjxjuLwnBtHaxCVfO667WmnPc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aVvRXgTRnjxjuLwnBtHaxCVfO667WmnPc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/07/14 06:04, Dexuan Cui wrote:
> Currently the VSC has no chance to notify the VSP of the dirty rectangl=
e on VM
> panic because the notification work is done in a workqueue, and in pani=
c() the
> kernel typically ends up in an infinite loop, and a typical kernel conf=
ig has
> CONFIG_PREEMPT_VOLUNTARY=3Dy and CONFIG_PREEMPT is not set, so a contex=
t switch
> can't happen in panic() and the workqueue won't have a chance to run. A=
s a
> result, the VM Connection window can't refresh until it's closed and we=

> re-connect to the VM.
>=20
> We can register a handler on panic_notifier_list: the handler can notif=
y
> the VSC and switch the framebuffer driver to a "synchronous mode", mean=
ing
> the VSC flushes any future framebuffer change to the VSP immediately.
>=20
> v2: removed the MS-TFS line in the commit message
> v3: remove some 'unlikely' markings
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/video/fbdev/hyperv_fb.c | 58 +++++++++++++++++++++++++++++++++=
+++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hype=
rv_fb.c
> index e23392e..a7b98e1 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -226,11 +226,16 @@ struct hvfb_par {
>  	u8 recv_buf[MAX_VMBUS_PKT_SIZE];
>  };
> =20
> +static struct fb_info *hvfb_info;

Static variables like these are usually a no-no. This prevents you from
having multiple device instances.

>  static uint screen_width =3D HVFB_WIDTH;
>  static uint screen_height =3D HVFB_HEIGHT;
>  static uint screen_depth;
>  static uint screen_fb_size;
> =20
> +/* If true, the VSC notifies the VSP on every framebuffer change */
> +static bool synchronous_fb;
> +

Same comment here.

However, if (and only if) the driver is already designed to work only
with single device instance, then this patch is probably ok. But even
then, I'd prefer this to be handled without static variables so that the
driver could eventually be changed to support multiple device instances.

 Tomi



--aVvRXgTRnjxjuLwnBtHaxCVfO667WmnPc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2QAIAAoJEPo9qoy8lh71KGcP/1q/CPSZCmvv9TczbRM33JPD
EHsIFynqkUMgqapY8/idWLa+cUwUooaTi5Z3taqikrqiJAm8Fn3MBA9K2shmxjxv
oxMMSGf8efI8Li6oOQfs4fqQitbwPDTq8NAbhJDVO4wPbQqw9usGF5gfjXEDrR4m
4YCBFgwzJEGbd2VQ0j+Nfr7hwm44Ez0BfjrYOtQAU5XeAGwKmIae5FhEOde9u5I7
ozcXRvHBmBwRBGi4F8Rcbkofqnjn1rhjeekesMcEdRXSCBmu8BvCDaSJXDwx4AAv
IBB9c+M+TJLEFl1pCzX+FBQcesQY+x6O08wO82B3bfcCSmZdMGti1sgXRaUog1ke
MSJr4pjaX6JkbUlkaEeS+gBSLaw9++bJyMj/MnPgRRBOOSYZXL6Df+YV1End59ck
hXvmQTAWyOwaX45X/h/GQ6M6ZmIVZkJJL73QfkdzFQzO/l8XefbYvYc7dDIJuQZ9
ih3dGBf1njRFPHb4usHoEJ4CpeKUlttzNYzcugj2am0zgAcCiLK2AfbaWUDfXxoy
PYy/gP/bVnB+i2dkRxJweVykgfd4UGXUtXU9BV3aexaG14CuXmt/7OPlULT1LlWS
XKHcq0Bq6BkYYqNsO80o+8NyxV59sv9FGlLsaEpfw7+W9ZEbhIENJkvxUEobp2zl
q5IDpW+iq2OpbbH0up3b
=8/jh
-----END PGP SIGNATURE-----

--aVvRXgTRnjxjuLwnBtHaxCVfO667WmnPc--
