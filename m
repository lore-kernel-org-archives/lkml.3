Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3DAPvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:51:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51956 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758005Ab3DAPvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:51:07 -0400
Message-ID: <1364831446.3557.98.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
From: Ben Hutchings <ben@decadent.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, jwboyer@redhat.com, linux-efi@vger.kernel.org,
        seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
        x86@kernel.org
Date: Mon, 01 Apr 2013 16:50:46 +0100
In-Reply-To: <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	 <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JuGlKJRtdSSVii/R+sts"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:8b3:8e02:718c:5f0d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JuGlKJRtdSSVii/R+sts
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-01 at 11:14 -0400, Matthew Garrett wrote:
> EFI implementations distinguish between space that is actively used by a
> variable and space that merely hasn't been garbage collected yet. Space
> that hasn't yet been garbage collected isn't available for use and so isn=
't
> counted in the remaining_space field returned by QueryVariableInfo().
>=20
> Combined with commit 68d9298 this can cause problems. Some implementation=
s
> don't garbage collect until the remaining space is smaller than the maxim=
um
> variable size, and as a result check_var_size() will always fail once mor=
e
> than 50% of the variable store has been used even if most of that space i=
s
> marked as available for garbage collection. The user is unable to create
> new variables, and deleting variables doesn't increase the remaining spac=
e.
>=20
> The problem that 68d9298 was attempting to avoid was one where certain
> platforms fail if the actively used space is greater than 50% of the
> available storage space. We should be able to calculate that by simply
> summing the size of each available variable and subtracting that from
> the total storage space. With luck this will fix the problem described in
> https://bugzilla.kernel.org/show_bug.cgi?id=3D55471 without permitting
> damage to occur to the machines 68d9298 was attempting to fix.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/firmware/efivars.c | 41 ++++++++++++++++++++++++++++++++++++++--=
-
>  1 file changed, 38 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 60e7d8f..a6d8a58 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
[...]
> @@ -452,8 +462,33 @@ check_var_size_locked(struct efivars *efivars, u32 a=
ttributes,
>  	if (status !=3D EFI_SUCCESS)
>  		return status;
> =20
> -	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	list_for_each_entry(entry, &efivars->list, list) {
> +		var =3D &entry->var;
> +		status =3D get_var_data_locked(efivars, var);
> +
> +		if (status || !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
> +			continue;
> +
> +		active_size +=3D var->DataSize;
> +		active_size +=3D utf16_strsize(var->VariableName, 1024);
> +		/*
> +		 * There's some additional metadata associated with each
> +		 * variable. Intel's reference implementation is 60 bytes -
> +		 * bump that to 128 to account for vendor additions and
> +		 * potential alignment constraints
> +		 */
> +		active_size +=3D 128;
> +	}
> +
> +	/*
> +	 * Add on the size of any boot services-only variables
> +	 */
> +	active_size +=3D boot_var_size;
> +
> +	active_available =3D storage_size - active_size;
> +
> +	if (!storage_size || size > remaining_size ||
> +	    (active_available - size) < (storage_size / 2))
>  		return EFI_OUT_OF_RESOURCES;

Both substractions here could quite possibly underflow due to
over-estimation of active_size.

We can rearrange the condition to be:

	active_size + size > storage_size / 2

and delete the active_available variable.  But I think metadata for the
new variable should be accounted as well:

	active_size + size + 128 > storage_size / 2

Since we'll now be using that magic number twice, it needs a name.

Ben.

>  	return status;

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-JuGlKJRtdSSVii/R+sts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVms1ue/yOyVhhEJAQqUMw/+PB2TyVlnZ5ItosMmxLrB+bOyJ4+i+FpE
oPONrawP48WLC2JDVofk6O8zO5NAWnHrATc9M3LUxu9QtXYUecg45/lsSTl/ta7d
qq5HVzy3gl7AD9myx8He3K9fMrGiWMAvTOmF/HDAvQHILqw+x3e7rb/K2DF9BYBC
cglHaPMOmUbjo59JcY6tMLejMIIrESmyAgtl2qJmjP7t3QS5ufeXxvCJ3GScnV+O
cB80Y1YYRhPja9WkBvOtmNeb5eTpYqd88t0il6RNJC1lPIAqkV36x6QMeFC2ebmL
gy0H7nF0SnPdsXI/eTCBJMPDdSNZJiTKEgXvLWVJ7g6ms/ivbJ1aZ5c3uUb+StvV
gfWUsegymGu0HJaDbXyFxBBFLr72f0MzjTN6CsQLaVDYn92f/+jqLZDX8DlRsVR+
4/LhOTPitwZgjKM9Cu8UnkL+g66KVrpybp8Tw5WVAh+91wAx6lmt4a1681sJU0dX
5dCjRS7Mi/yCQzYzOshSYLji7mC0D1fJ6maLCqzBmWz4Ta6LhZQGl9D7IahZrMTA
ygMXhUYQwuUjzLRB9vlznFwsGG/qclScZ1aDfkMQhD5xPYBdHTKecH/X1ENvvu1m
o9zdYb+rY5gkoSm6CuPjdXyEZz/kWVf0Utz8TCX0IvfW6j3N9NUIfjmzrifz3sJW
LP/Mjs8jNqU=
=eOag
-----END PGP SIGNATURE-----

--=-JuGlKJRtdSSVii/R+sts--
