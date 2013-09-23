Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3IWUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:24:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58986 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3IWUYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:24:35 -0400
Date: Mon, 23 Sep 2013 15:24:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: <behanw@converseincode.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] USB: Removing the use of VLAIS from the gadget driver
Message-ID: <20130923202428.GG309@radagast>
Reply-To: <balbi@ti.com>
References: <1375407344-30120-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Content-Disposition: inline
In-Reply-To: <1375407344-30120-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 01, 2013 at 09:35:44PM -0400, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
>=20
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel =
code
> precludes the use of compilers which don't implement VLAIS (for instance =
the
> Clang compiler). This patch removes the use of VLAIS in the gadget driver.
>=20
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  drivers/usb/gadget/f_fs.c | 128 +++++++++++++++++++++++++++-------------=
------
>  1 file changed, 76 insertions(+), 52 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index f394f29..4b872c4 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -30,7 +30,6 @@
> =20
>  #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
> =20
> -
>  /* Debugging ***********************************************************=
*****/
> =20
>  #ifdef VERBOSE_DEBUG
> @@ -214,6 +213,8 @@ struct ffs_data {
>  	/* ids in stringtabs are set in functionfs_bind() */
>  	const void			*raw_strings;
>  	struct usb_gadget_strings	**stringtabs;
> +	struct usb_gadget_strings	*stringtab;
> +	struct usb_string		*strings;
> =20
>  	/*
>  	 * File system's super block, write once when file system is
> @@ -263,7 +264,10 @@ struct ffs_function {
> =20
>  	struct ffs_ep			*eps;
>  	u8				eps_revmap[16];
> +	struct usb_descriptor_header	**fs_descs;
> +	struct usb_descriptor_header	**hs_descs;
>  	short				*interfaces_nums;
> +	char				*raw_descs;
> =20
>  	struct usb_function		function;
>  };
> @@ -1345,6 +1349,8 @@ static void ffs_data_clear(struct ffs_data *ffs)
>  	kfree(ffs->raw_descs);
>  	kfree(ffs->raw_strings);
>  	kfree(ffs->stringtabs);
> +	kfree(ffs->stringtab);
> +	kfree(ffs->strings);
>  }
> =20
>  static void ffs_data_reset(struct ffs_data *ffs)
> @@ -1357,6 +1363,8 @@ static void ffs_data_reset(struct ffs_data *ffs)
>  	ffs->raw_descs =3D NULL;
>  	ffs->raw_strings =3D NULL;
>  	ffs->stringtabs =3D NULL;
> +	ffs->stringtab =3D NULL;
> +	ffs->strings =3D NULL;
> =20
>  	ffs->raw_descs_length =3D 0;
>  	ffs->raw_fs_descs_length =3D 0;
> @@ -1528,12 +1536,10 @@ static void ffs_func_free(struct ffs_function *fu=
nc)
>  	ffs_data_put(func->ffs);
> =20
>  	kfree(func->eps);
> -	/*
> -	 * eps and interfaces_nums are allocated in the same chunk so
> -	 * only one free is required.  Descriptors are also allocated
> -	 * in the same chunk.
> -	 */
> -
> +	kfree(func->fs_descs);
> +	kfree(func->hs_descs);
> +	kfree(func->interfaces_nums);
> +	kfree(func->raw_descs);
>  	kfree(func);
>  }
> =20
> @@ -1907,33 +1913,35 @@ static int __ffs_data_got_strings(struct ffs_data=
 *ffs,
>  		return 0;
>  	}
> =20
> -	/* Allocate everything in one chunk so there's less maintenance. */
>  	{
> -		struct {
> -			struct usb_gadget_strings *stringtabs[lang_count + 1];
> -			struct usb_gadget_strings stringtab[lang_count];
> -			struct usb_string strings[lang_count*(needed_count+1)];
> -		} *d;
>  		unsigned i =3D 0;
> -
> -		d =3D kmalloc(sizeof *d, GFP_KERNEL);
> -		if (unlikely(!d)) {
> +		usb_gadget_strings **stringtabs =3D NULL;
> +		usb_gadget_strings *stringtab =3D NULL;
> +		usb_string *strings =3D NULL;

did you compile this patch ?

--=20
balbi

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQKN8AAoJEIaOsuA1yqREIbMQAIR1uFMpTvUwwqo0KpWcd43c
7Q5N4umxHqxhAJ3dW3qg4MyvYt2T3/ntQQAorWEBPz2nGzyX7xfkG0sYABMTfFL9
4DCJra64xa/AGnTVo7RtNYsey3kLNPc0j+tsuxcnQOh1lhY6UHdhZc9VvD2zHDt3
38Erh6sgUPsucm0713FlAbqCYJw/WA++H6aAnG+9o60/k3BWPzzxZbyDODjuX1gX
RdywwmNnS3FhmMBjyJ2D8sGDyftnfFbo0TGj8KwpceZiaA68kArwBnfoipkdeMV4
mjtc63w/WCuGNXqgvaR3DvzkSn27zuW1ZuOzzzud3mLIsB85tB4wUJ08DRpPyjJt
jylZrWvkoxX54e2HBNn4jCwgreHq9ODsHRPXA8vs4HL/EotxxDrOgqwEkyRO+WeV
GfGylJfMWnSolww7yIp3a/Zq3XIfLaX8FL0BFnAI0vIYxZmiND87fC/DWzwSke2n
ehh+0ZSNS+zAx/2O28RU7G0dbmlkc9lphT6tDoPB51FEQiyYakFQNQJAt9KwtXnf
P6n/vhpbpdb0oZfP8T/JI5cQaADuMyG6kbEY5Rt63ffGfJVAckMjRvTfP2c7U1jm
ko9hSVi+Cv/0xy/iBSoX0xgw0+vhSK2jfW2ZHOY8jSt9TToBOnvtcUohgkpSvvCd
OMENAtfej+6ZnP6esYRF
=yCjU
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
