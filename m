Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873AbaACE05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 23:26:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42300 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbaACE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 23:26:55 -0500
Message-ID: <1388723203.22017.36.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 056/185] mm: ensure get_unmapped_area() returns
 higher address than mmap_min_addr
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Date: Fri, 03 Jan 2014 04:26:43 +0000
In-Reply-To: <lsq.1388282923.51724079@decadent.org.uk>
References: <lsq.1388282923.51724079@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QywVJajcLIyUY/n0oxo4"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QywVJajcLIyUY/n0oxo4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-12-29 at 03:08 +0100, Ben Hutchings wrote:
> 3.2.54-rc1 review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
>=20
> commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.
[...]
> [bwh: Backported to 3.2:
>  As we do not have vm_unmapped_area(), make arch_get_unmapped_area_topdow=
n()
>  calculate the lower limit for the new area's end address and then compar=
e
>  addresses with this instead of with len.  In the process, fix an off-by-=
one
>  error which could result in returning 0 if mm->mmap_base =3D=3D len.]

I'm dropping this as I have no good way to test the backport (it's not
used on x86) and I didn't get any confirmation that it's right.

Ben.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1368,7 +1368,7 @@ arch_get_unmapped_area(struct file *filp
>  	struct vm_area_struct *vma;
>  	unsigned long start_addr;
> =20
> -	if (len > TASK_SIZE)
> +	if (len > TASK_SIZE - mmap_min_addr)
>  		return -ENOMEM;
> =20
>  	if (flags & MAP_FIXED)
> @@ -1377,7 +1377,7 @@ arch_get_unmapped_area(struct file *filp
>  	if (addr) {
>  		addr =3D PAGE_ALIGN(addr);
>  		vma =3D find_vma(mm, addr);
> -		if (TASK_SIZE - len >=3D addr &&
> +		if (TASK_SIZE - len >=3D addr && addr >=3D mmap_min_addr &&
>  		    (!vma || addr + len <=3D vma->vm_start))
>  			return addr;
>  	}
> @@ -1442,9 +1442,10 @@ arch_get_unmapped_area_topdown(struct fi
>  	struct vm_area_struct *vma;
>  	struct mm_struct *mm =3D current->mm;
>  	unsigned long addr =3D addr0;
> +	unsigned long low_limit =3D max(PAGE_SIZE, mmap_min_addr);
> =20
>  	/* requested length too big for entire address space */
> -	if (len > TASK_SIZE)
> +	if (len > TASK_SIZE - mmap_min_addr)
>  		return -ENOMEM;
> =20
>  	if (flags & MAP_FIXED)
> @@ -1454,7 +1455,7 @@ arch_get_unmapped_area_topdown(struct fi
>  	if (addr) {
>  		addr =3D PAGE_ALIGN(addr);
>  		vma =3D find_vma(mm, addr);
> -		if (TASK_SIZE - len >=3D addr &&
> +		if (TASK_SIZE - len >=3D addr && addr >=3D mmap_min_addr &&
>  				(!vma || addr + len <=3D vma->vm_start))
>  			return addr;
>  	}
> @@ -1469,14 +1470,14 @@ arch_get_unmapped_area_topdown(struct fi
>  	addr =3D mm->free_area_cache;
> =20
>  	/* make sure it can fit in the remaining address space */
> -	if (addr > len) {
> +	if (addr >=3D low_limit + len) {
>  		vma =3D find_vma(mm, addr-len);
>  		if (!vma || addr <=3D vma->vm_start)
>  			/* remember the address as a hint for next time */
>  			return (mm->free_area_cache =3D addr-len);
>  	}
> =20
> -	if (mm->mmap_base < len)
> +	if (mm->mmap_base < low_limit + len)
>  		goto bottomup;
> =20
>  	addr =3D mm->mmap_base-len;
> @@ -1498,7 +1499,7 @@ arch_get_unmapped_area_topdown(struct fi
> =20
>  		/* try just below the current vma->vm_start */
>  		addr =3D vma->vm_start-len;
> -	} while (len < vma->vm_start);
> +	} while (vma->vm_start >=3D low_limit + len);
> =20
>  bottomup:
>  	/*

--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.

--=-QywVJajcLIyUY/n0oxo4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUsY8A+e/yOyVhhEJAQrZWA/+N219ALegDKByoN3xUBeTEZnVizVQ+Tr+
phDbL69cQmc7Y9PrvuODeaSQ/yKnpHRvWaJ4RaXalSm9e4j2ZQ+WOl/FV7o70oy3
ya03d4fgmjx5ZAziAl2UEdaeuocQChQxHT8k0fHtupzt3xX5EiLdbXOl2iXeezHB
oeAdMDRhPXmPIcjTPYT2CHNXIBC4/TzTVNmkTwxTz6MtN28qQ7ww8gfoKauo20nr
GHhPaiDz4GjOv28agPw2y7oYTB0hp75/l/FzPtUB+f5L+HqWCdxRjYqNM+2aCsLY
d5ST3gGj791dotXMx+aP8aNewAasNs6Rjixi83rbg7ZjELY4yDx9VECs59Mib5xu
F3vG0ioQkzF8f4OglcUNhAukZpAO1tXltmIvZ53CVy8hMPWM7ebmoEuFUl69o4JO
/hY/U1MUqd4weryH9nIZZRYVX5MoCzpeCIt6wKn0hke/xhQ3sU0710eg7gB1uPiY
7JwhxP8kDn10yVyqQ93QXl+6LRveI5OVSlwxG0m46bY2QL95rAmu8p8C65em2Trh
SjqpPzf4sHrN1bR/eiKSERD3eKQX6hmB+L4f4vyUECHFL5cv+fWpakLUvLGrZmzh
DofmKrV5r0OPilembrQe4pDFVv92cPewJ7j3B+x5kNSrwQ60XPaJZlfCXzVFVQVr
qnBCpXJ89x8=
=3r6h
-----END PGP SIGNATURE-----

--=-QywVJajcLIyUY/n0oxo4--
