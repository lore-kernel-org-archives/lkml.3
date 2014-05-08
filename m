Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaEHKzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:55:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbaEHKzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:55:40 -0400
Message-ID: <536B62A1.1040203@ti.com>
Date: Thu, 8 May 2014 13:55:29 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Masami Ichikawa <masami256@gmail.com>, <plagnioj@jcrosoft.com>,
        <udknight@gmail.com>, <gregkh@linuxfoundation.org>,
        <keithp@keithp.com>, <mika.kuoppala@linux.intel.com>,
        <viresh.kumar@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] fbcon: Fix memory leak in con2fb_release_oldinfo()
References: <1398263722-10436-1-git-send-email-masami256@gmail.com>
In-Reply-To: <1398263722-10436-1-git-send-email-masami256@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="m4QCAEJRktne0EnddwceUaI0BafKTh8Ca"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--m4QCAEJRktne0EnddwceUaI0BafKTh8Ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23/04/14 17:35, Masami Ichikawa wrote:
> kmemleak reported a memory leak as below.
>=20
> unreferenced object 0xffff8800dab6d8d8 (size 96):
>   comm "swapper/0", pid 1, jiffies 4294877598 (age 38.483s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 01 00 00 08 00 00 00 10 00 00 00  ................
>     07 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff814e8f2e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff811a0600>] __kmalloc+0x280/0x320
>     [<ffffffff81309b61>] soft_cursor+0x231/0x290
>     [<ffffffff81309393>] bit_cursor+0x613/0x650
>     [<ffffffff8130556b>] fbcon_cursor+0x13b/0x1c0
>     [<ffffffff813755f8>] hide_cursor+0x28/0xa0
>     [<ffffffff81376e98>] redraw_screen+0x168/0x240
>     [<ffffffff81303891>] fbcon_prepare_logo+0x381/0x420
>     [<ffffffff81303c7e>] fbcon_init+0x34e/0x590
>     [<ffffffff81375828>] visual_init+0xb8/0x120
>     [<ffffffff81377c93>] do_bind_con_driver+0x163/0x380
>     [<ffffffff81378494>] do_take_over_console+0x114/0x1c0
>     [<ffffffff81303f23>] do_fbcon_takeover+0x63/0xd0
>     [<ffffffff813086dd>] fbcon_event_notify+0x68d/0x7e0
>     [<ffffffff814ff7ac>] notifier_call_chain+0x4c/0x70
>     [<ffffffff8108c85d>] __blocking_notifier_call_chain+0x4d/0x70
>=20
> This memory leak cause is, fbcon_ops's cursor_src is allocated in
> soft_cursor() but not released in con2fb_release_oldinfo().
> so, cursor_src is needed to be released when oldinfo is going to be
> released.
>=20
> Signed-off-by: Masami Ichikawa <masami256@gmail.com>
> ---
>  drivers/video/console/fbcon.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbco=
n.c
> index f447734..57b1d44 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -748,6 +748,7 @@ static int con2fb_release_oldinfo(struct vc_data *v=
c, struct fb_info *oldinfo,
>  		fbcon_del_cursor_timer(oldinfo);
>  		kfree(ops->cursor_state.mask);
>  		kfree(ops->cursor_data);
> +		kfree(ops->cursor_src);
>  		kfree(ops->fontbuffer);
>  		kfree(oldinfo->fbcon_par);
>  		oldinfo->fbcon_par =3D NULL;
>=20

Thanks, queued for 3.16.

 Tomi



--m4QCAEJRktne0EnddwceUaI0BafKTh8Ca
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTa2KhAAoJEPo9qoy8lh71gLEP/091s9IhDhX/PH7goJGCCSKq
sbI34hWOBWO2tltxX1jAeuH0p4+9t20HKUbaiaKfiOp1HUCI2Xy0Z9rMZmCv0vKB
xSAgrDBfZrkoZhA9xO1MkRu3/MXJA3OH/RWHS0tgpkbGpH1QEvzi2PzF/omYYXh1
wWmllHAQVxiviO8ztCQ1ej6izEETxAYf7ltukcSVapeIKC5trctkWczL2gnCsMLd
kw33/TgM3YvPqHyV0IQaERnYRH1OfRg6ormqIlZcObAiFoNXocm6cP40v4vpd/3v
nN2R1p+KESM/PIFJEzqHfz0btkKHXK0VOrEASXny3/XJcG6whJeV2B38f3BkpdGj
TLS+J7oI6jwvB/2pBKpcvU665jgrXomHrFPUNqV3ohS5cwHHKUHDPO4hxLvdTdnP
sWVv6CWvWAj2fEezy0iZjNH1rPKjeFNkqoCzTSBn5K8STpJtLfwbvSS5epWH10iN
kho3ZP7Q3DHZCdgCl1Brof1YECGdWhWAdHypoLt9Y9EOw2D9iUreXKvCjkUHGt5K
QQ77giqXIm+wngHLG8ijAixjwXUXp7czEtTVaz8C3hnp9FFoismUErfqFEWhad+l
6cfpqeMXQ7yZC8ghZ2nCKOpz4Loa8gEN8tDTVT62nz9srOIk0j7l4ylsdOfJjG8Y
dZllATq7DUJ5XP+ZeySi
=/b6Z
-----END PGP SIGNATURE-----

--m4QCAEJRktne0EnddwceUaI0BafKTh8Ca--
