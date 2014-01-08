Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaAHJxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:53:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33112 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbaAHJxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:53:21 -0500
Message-ID: <52CD2002.30208@ti.com>
Date: Wed, 8 Jan 2014 11:53:06 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masami Ichikawa <masami256@gmail.com>
CC: <plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>,
        <airlied@redhat.com>, <udknight@gmail.com>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <tiwai@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbcon: Fix memory leak in fbcon_exit().
References: <1387982857-14500-1-git-send-email-masami256@gmail.com>
In-Reply-To: <1387982857-14500-1-git-send-email-masami256@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HU8lGjTU08sgF4fotpiPFdbvaDGHqlkwU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HU8lGjTU08sgF4fotpiPFdbvaDGHqlkwU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-12-25 16:47, Masami Ichikawa wrote:
> kmemleak reported a memory leak as below.
>=20
> unreferenced object 0xffff880036ca84c0 (size 16):
>   comm "swapper/0", pid 1, jiffies 4294877407 (age 4434.633s)
>   hex dump (first 16 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff ff  ................
>   backtrace:
>     [<ffffffff814ed01e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff8118913c>] __kmalloc+0x1fc/0x290
>     [<ffffffff81302c9e>] bit_cursor+0x24e/0x6c0
>     [<ffffffff812ff2f4>] fbcon_cursor+0x154/0x1d0
>     [<ffffffff813675d8>] hide_cursor+0x28/0xa0
>     [<ffffffff81368acf>] update_region+0x6f/0x90
>     [<ffffffff81300268>] fbcon_switch+0x518/0x550
>     [<ffffffff813695b9>] redraw_screen+0x189/0x240
>     [<ffffffff8136a0e0>] do_bind_con_driver+0x360/0x380
>     [<ffffffff8136a6e4>] do_take_over_console+0x114/0x1c0
>     [<ffffffff812fdc83>] do_fbcon_takeover+0x63/0xd0
>     [<ffffffff813023e5>] fbcon_event_notify+0x605/0x720
>     [<ffffffff81501dcc>] notifier_call_chain+0x4c/0x70
>     [<ffffffff81087f8d>] __blocking_notifier_call_chain+0x4d/0x70
>     [<ffffffff81087fc6>] blocking_notifier_call_chain+0x16/0x20
>     [<ffffffff812f201b>] fb_notifier_call_chain+0x1b/0x20
>=20
> In this case ops->cursor_state.mask is allocated in bit_cursor() but
> not freed in fbcon_exit(). So, fbcon_exit() needs to free buffer in its=

> process.
> In the case, fbcon_exit() was called from fbcon_deinit() when driver
> called remove_conflicting_framebuffers().
>=20
> Signed-off-by: Masami Ichikawa <masami256@gmail.com>
> ---
>  drivers/video/console/fbcon.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbco=
n.c
> index cd8a802..4f02375 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -3561,6 +3561,7 @@ static void fbcon_exit(void)
> =20
>  				fbcon_del_cursor_timer(info);
>  				kfree(ops->cursor_src);
> +				kfree(ops->cursor_state.mask);
>  				kfree(info->fbcon_par);
>  				info->fbcon_par =3D NULL;
>  			}
>=20

Thanks, queued for 3.14.

 Tomi



--HU8lGjTU08sgF4fotpiPFdbvaDGHqlkwU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzSACAAoJEPo9qoy8lh71PRwQALA5pqu/fR5Mb2VE9RQG0CDa
Z2YlZJuHjBsjjj/PVG5mZAsBuLHfctPhh9UqrK8UNdE0lEBR7jE7hAKX5OrizZ2z
Pe+qqBFcexQbHz0EpafSHyF+31fTaE5BwruBMbTqN16m7odyM1r1QjAUEcixVHUl
/QMgk5KHIWirkLZh4X42uKBDpCh1jmORLRoYWddhquLhngnuisdZY4unyanU4bEb
Ly3HLl4XGFDW6IjgSXNTaKJMPxowPqX9wAAaeq41X103btV1JGvLa1gwm3AEPI2M
kvGSrRgKrPdQJIvh0Yv+c7MxUn90N2XlEvj4VaMqtnzuUtiEMyIa7NOc9F1YMX66
RKg18riAKvRyjErkCuSDEQTRgky2OMtd17Mpn9ui3QitlX7mD0nxau/bdq7vGudA
grJoTwLMAAAnm3QZy/lb7DVVilldbAQkTmS+tsuCNppIa1QlvXCVYYehrCJf7qgU
JQv2UCfEkSiWrnXPfKs2kxUdJLi9yfCJ8Jh4d+7WjvoMkANeHi/A+6TQ46NkDSF1
/oWL07D8Xyccpr3RDdbwishINZDO8VAqaWJEsJ59bk3oyO8BOmjdLKFZkQe45WGl
SDC4cTqkOjEEa2dMuVTHlmdbUtoW3cHcDpXrOqBZHBemdKmKmsY/kCOG2A+lzHQx
bTVMQCNL7xnuQu1FK7bb
=QniR
-----END PGP SIGNATURE-----

--HU8lGjTU08sgF4fotpiPFdbvaDGHqlkwU--
