Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3EHPPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:15:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3EHPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:15:01 -0400
Message-ID: <518A6BF0.2060705@canonical.com>
Date: Wed, 08 May 2013 17:14:56 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: WT memory type on x86_64?
References: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com> <20130508143505.GA8599@phenom.dumpdata.com>
In-Reply-To: <20130508143505.GA8599@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig307B692C44DA7DB7F2746E6C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig307B692C44DA7DB7F2746E6C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08.05.2013 16:35, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 24, 2013 at 12:33:33PM -0700, Andy Lutomirski wrote:
>> For an upcoming (and, sadly, NDA'd [1]) project, I may need to use
>> write-through memory.  I'd like to gauge how unpleasant this will be.
>>
>> AFAICT, modern CPUs allow the WT type to be set using MTRR or a PAT
>> entry.  Sadly, MTRRs are in short supply, and the four fully-usable
>> PAT slots are used for UC, UC-, WB, and WC.  I can keep my fingers
>> crossed and hope that there are enough free MTRRs, or I could try to
>> free up a PAT entry.
>>
>> How nasty will the latter be?  I just looked at two rather different
>> modern Sandy Bridge machines, and BIOS doesn't appear to set up any
>> MTRRs in the WC or WP states.  As long as those MTRR types aren't
>> used, I think the UC- PAT entry is useless -- it behaves identically
>> to UC.  Lots of DRM drivers, though, seen to add a WC MTRR to cover
>> video memory.  Is there any need for this on modern machines?  That
>> is, are there any drivers that actually need the mtrr_add call to
>> succeed on a machine that has a working PAT?
>>
>> If not, then here's a proposal:  At startup, if there are no WC or WP
>> MTRRs and the CPU is new enough, then set a flag for an alternative
>> PAT.  In alternative PAT mode, UC- is replaced with WT in the PAT and
>> mtrr_add fails when attempting to add a WC or WP entry.  Add
>> set_memory_wt, etc.  They fail in non-alternative-PAT mode.  This gets=

>> a bit unpleasant, since _PAGE_CACHE_UC_MINUS will have a different
>> meaning depending on the mode.
>>
>> A less conservative proposal would be to stop using UC- in the PAT
>> entirely.  The memtype code could learn to emulate UC- when there's an=

>> overlapping WC or WP MTRR.
>>
>> Any thoughts?  Are there known errata here?  Is there a good reason
>> why the kernel needs UC-?  Will this be such a big can of worms that I=

>> should just hope there's an available MTRR?
>=20
> Stefan Bader (CC-ed here) was looking in making a "black-box" type
> code wherein for any types but WC it would lookup in the PAT index
> the right bit and provide that for the page_attr_set functions.
>=20
> If I recall he had run in a bit of issue with of the hard-coded values
> set by the macros.

It could be opening a can of worms. Right now there are many places / def=
ines
that are based on the assumption that a certain combination of PCD and PW=
T in
pgprot maps to a certain cache type. PAT is deliberately left out because=
 its
location changes for large pages (PAT and PSE share the same bit). That i=
s the
reason for the PAT MSR is set in a way that results in the same cache typ=
e
regardless of the PAT bit being 0 or 1.

Not sure whether this is the reason but UC and UC- (as well as WB) are ke=
pt like
the backward compatible setup. So for systems with and without PAT cache =
types
map to the same. Only WT gets replaced by WC. For that whenever PCD is se=
t it
means some uncached type.

>=20
>>
>> --Andy
>>
>> [1]  I hope to be able to upstream all kernel code related to this
>> project.  It will be neat -- I promise.  It will depend on convincing
>> the people on the other end of the NDA that they should let me.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>



--------------enig307B692C44DA7DB7F2746E6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRimvwAAoJEOhnXe7L7s6jF9cP/2wXJdMB3fQWfCHzuQldJKNN
wqPHfD+GdgIJ37xAniS3AvrIjwzEYDM3WGDkmFAeAxtGqCLXBhHM9V9lutKS6Sdu
Ur8Z2Pop42ZAqqetteBhL9lxtCu9zTKD/1UuzazFl2OU+/OS1nRA7Gh8FJ9E77kY
doiJ5Cx5lf0Q9h2ArvmqnUzRzXTvfEfyB5gGeIkzGairL0HQIXj5+Cm/37wtYCHR
DlKumjQHiXuf3KE8GJ/Yn7R/AciUHvXautHlO/pkMlSHNUQ2bS27xxz2fKDK9TeJ
JUxz7UQxW0/HYDPxcvs+W7+O6hvLdITLiBiTJbX0UScG585pAgOvjvk1/JhmXDvF
gWeLnKwkMOMizCn16Bzx3zGDrZ4eYf7Esf2NWklank3h4hLqEYknVJ5unWwULSc/
So2744teeUVKgh0FJaNp/V4t41OV2KT1pWZOWXbPK/2dgYThpERJrQqrvgB5VPMK
AJdzUVVemEN6mlKRNV8To0tIzL7M0w2g2KMxBrFDsYFSO4Xm4UgFUexdYdvvf/V6
zLVcbseoqzY+XnLnmk/l02ru0dHUZasye+3J5MNn0cz2qjolp7RVCJ9DFyw0Iu8h
Yuqx+rry6OGUMrOOzlHo6Z3Umuou2MgdmlaysvbeUXTYdb/OCUMqSPeqc5aKGaOh
OD5r8zPEEKsF+XLz2IDp
=0vXo
-----END PGP SIGNATURE-----

--------------enig307B692C44DA7DB7F2746E6C--
