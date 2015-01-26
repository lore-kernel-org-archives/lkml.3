Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbbAZMIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:08:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38626 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbbAZMIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:08:51 -0500
Message-ID: <54C62E4B.3070009@ti.com>
Date: Mon, 26 Jan 2015 14:08:43 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Scot Doyle <lkml14@scotdoyle.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] fbcon: expose cursor blink interval via sysfs
References: <alpine.DEB.2.11.1501240109060.3489@localhost.localdomain> <alpine.DEB.2.11.1501240117400.3639@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.11.1501240117400.3639@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8jiWxLuqvo41UPBV66nxhatBBwIimxwep"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8jiWxLuqvo41UPBV66nxhatBBwIimxwep
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 24/01/15 03:19, Scot Doyle wrote:
> The fbcon cursor, when set to blink, is hardcoded to toggle display sta=
te
> five times per second. Expose this setting via
> /sys/class/graphics/fbcon/cursor_blink_ms
>=20
> Values written to the interface set the approximate time interval in
> milliseconds between cursor toggles, from 1 to 32767. Since the interva=
l
> is stored internally as a number of jiffies, the millisecond value read=

> from the interface may not exactly match the entered value.
>=20
> An outstanding blink timer is reset after a new value is entered.
>=20
> If the cursor blink is disabled, either via the 'cursor_blink' boolean
> setting or some other mechanism, the 'cursor_blink_ms' setting may stil=
l
> be modified. The new value will be used if the blink is reactivated.
>=20
> Tested with intelfb.
>=20
> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> ---
>  drivers/video/console/fbcon.c | 75 +++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 75 insertions(+)
>=20
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbco=
n.c
> index 7a2030b..0ddfcf6 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -3495,11 +3495,86 @@ err:
>  	return count;
>  }
> =20
> +static ssize_t show_cursor_blink_ms(struct device *device,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct fb_info *info;
> +	struct fbcon_ops *ops;
> +	int idx, ms =3D -1;
> +
> +	if (fbcon_has_exited)
> +		return 0;

Why not return an error here?

> +
> +	console_lock();
> +	idx =3D con2fb_map[fg_console];
> +
> +	if (idx =3D=3D -1 || registered_fb[idx] =3D=3D NULL)
> +		goto err;

Same here?

> +	info =3D registered_fb[idx];
> +	ops =3D info->fbcon_par;
> +
> +	if (!ops)
> +		goto err;

And here.

> +
> +	ms =3D jiffies_to_msecs(ops->blink_jiffies);
> +
> +err:
> +	console_unlock();
> +	return snprintf(buf, PAGE_SIZE, "%d\n", ms);
> +}
> +
> +static ssize_t store_cursor_blink_ms(struct device *device,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct fb_info *info;
> +	struct fbcon_ops *ops;
> +	int idx;
> +	unsigned long ms;
> +
> +	if (fbcon_has_exited)
> +		return count;
> +
> +	console_lock();
> +	idx =3D con2fb_map[fg_console];
> +
> +	if (idx =3D=3D -1 || registered_fb[idx] =3D=3D NULL)
> +		goto err;
> +
> +	info =3D registered_fb[idx];
> +
> +	if (!info->fbcon_par)
> +		goto err;
> +
> +	ops =3D info->fbcon_par;
> +
> +	if (!ops)
> +		goto err;

Here also all the above look like errors to me, so why not return an erro=
r?

> +
> +	if (!kstrtoul(buf, 0, &ms)) {
> +		ms =3D min_t(unsigned long, ms, SHRT_MAX);
> +		ops->blink_jiffies =3D max_t(int, msecs_to_jiffies(ms), 1);
> +
> +		if (info->queue.func =3D=3D fb_flashcursor &&
> +		    ops->flags & FBCON_FLAGS_CURSOR_TIMER) {
> +			fbcon_del_cursor_timer(info);
> +			fbcon_add_cursor_timer(info);
> +		}
> +	}
> +
> +err:
> +	console_unlock();
> +	return count;
> +}
> +
>  static struct device_attribute device_attrs[] =3D {
>  	__ATTR(rotate, S_IRUGO|S_IWUSR, show_rotate, store_rotate),
>  	__ATTR(rotate_all, S_IWUSR, NULL, store_rotate_all),
>  	__ATTR(cursor_blink, S_IRUGO|S_IWUSR, show_cursor_blink,
>  	       store_cursor_blink),
> +	__ATTR(cursor_blink_ms, S_IRUGO|S_IWUSR, show_cursor_blink_ms,
> +	       store_cursor_blink_ms),
>  };
> =20
>  static int fbcon_init_device(void)
>=20



--8jiWxLuqvo41UPBV66nxhatBBwIimxwep
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxi5LAAoJEPo9qoy8lh71ihUP/RbpnLCFo5eKVIHzUv3fNQzk
0z+ZyxMtcheXHxheXxDfnYrRS4QQISu52izQFsb7MHG5fsD6EJiLb0MikYPE6Kni
3QBEZGmYlMtrEvQIOGDUxvPmVzKo4PuEN+ZqBxj6d6nannFKSe2izdn/hW7ZybFR
8tubgA24jRuFLhq7SArK5FJvnkp7gBp71AcqQkpzQGcxF3dZk8Wu+4IvQtRiXP2j
1+dnivpTCHpOa7WUVqtvTiw0usjp3GwxrwmD6Wwl3ldIoF4FHUHGwlkIirUCoy3j
JDVIN4UBWlPA0tP3ZzDqGMC9YuiMDJl3opvsN4IE7ldvrCUfFF68VYEjrp0fnjPp
BHRznC0h7vPJqHRYxEvnm1vGza3K3glLWVOHhdSVvit4DurZV5QfrDu2SOOqXyT3
xHcM9309s1YY20Q8WGt2M4AmTRowzNTeKfNiJ1sTqDRe61vF0MoqBuN9wn3lG4m2
f6/dcCEWa7/hytIsAV6FlBWEYiXVe+f/wXPlmqNOpaYV/LpaAhYlibA+D62lxMRp
71iMpKpzjFOakoRGzXoXi6eI4MEQhkvwDxBHIRv0I9Ym4VsrBhWyopYxUeL8eTe2
OsmfiZgrffUUAwrpYJyReOYhOCi7gvfAFAkuLTuK4B+hR65MIMMsac91La5+kyZf
ekxUsMmnjLyF3OpLYRBl
=7oBh
-----END PGP SIGNATURE-----

--8jiWxLuqvo41UPBV66nxhatBBwIimxwep--
