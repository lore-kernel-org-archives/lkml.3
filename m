Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaCVSzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:55:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54605 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:55:14 -0400
Date: Sat, 22 Mar 2014 18:54:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Patrick Lai <plai@codeaurora.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org
Message-ID: <20140322185456.GA30031@sirena.org.uk>
References: <20140321000436.377902063@linuxfoundation.org>
 <20140321000440.772268771@linuxfoundation.org>
 <1395503588.2770.69.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1395503588.2770.69.camel@deadeye.wl.decadent.org.uk>
X-Cookie: I've Been Moved!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3.13 110/149] ASoC: pcm: free path list before exiting
 from error conditions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2014 at 03:53:08PM +0000, Ben Hutchings wrote:
> On Thu, 2014-03-20 at 17:04 -0700, Greg Kroah-Hartman wrote:

If you spot something on a stable patch that applies upstream (as
opposed to being stable process or to do with the older kernel which are
the most common things with these mails) please add both the maintainers
and relevant lists.  -stable mail only goes to signoffs so misses both
lists and additional maintainers meaning things may not be going to the
people who should see them (in this case it's Liam who mostly looks at
DPCM for example).  It might make sense for the -stable mails to do this
in general, at least with the lists if not the maintainers.

Ideally it's helpful to also send it in a separate thread since the
volume of mail about -stable stuff is extremely high so things are
easily missed but that's a bit more fun to do, I'm really not sure
there's any general way to resolve that one sensibly.

> > dpcm_path_get() allocates dynamic memory to hold path list.
> > Corresponding dpcm_path_put() must be called to free the memory.
> > dpcm_path_put() is not called under several error conditions.
> > This leads to memory leak.

> This is broken.  dpcm_path_get() may return -ENOMEM and not initialise
> the list at all.

> If snd_soc_dapm_dai_get_connected_widgets() can fail (I don't think it
> can) then dpcm_path_get() should be responsible for freeing the list
> before returning.

It can't fail without memory corruption or internal bugs and would only
fail with a crash.

> [...]
> > --- a/sound/soc/soc-pcm.c
> > +++ b/sound/soc/soc-pcm.c
> [...]
> > @@ -1979,6 +1981,7 @@ static int dpcm_fe_dai_open(struct snd_p
> >  	fe->dpcm[stream].runtime =3D fe_substream->runtime;
> > =20
> >  	if (dpcm_path_get(fe, stream, &list) <=3D 0) {
> > +		dpcm_path_put(&list);

> This is the one place where a memory leak seems to be possible, but the
> < 0 and =3D=3D 0 cases need to be distinguished.

> Greg, please drop this until it is fixed properly upstream.

It's actually not going to cause a leak there at all since we have an
unconditional run through the rest of the function to a double free with
references to the list that gets freed, AFAICT there wasn't a leak to
start off with.  I think what the function needs to do here is bomb out
early on -ENOMEM and otherwise trundle on.

Anyway, I'll revert this upstream.  Thanks for noticing this.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLdx9AAoJELSic+t+oim9KJQP/Rx4nG0soHHyMnabqdwnwyKY
63ev/mlLFnV5yzWcHYZP+6cUhwh770XgdSGJ2pW5LyzLigNqNIkJbTWEY1qUFpHw
U/PgCHoU2/G4t5LE/OloSpIMmETOV9EHm5NJ7B83pRSW+O/X/WQSuUF9SqTthf7H
Tr2KaCr+FixER8jjCoUSFtgCTTd67mC9o71WSpBgtgQY/FmAT+StIRzvYNnb5+z5
EubDZEOskf/mG36d7qe0J+NDN5o36G8DzzEUkXh9+rGxfAyF2u51y9Ypj+yE1gjP
omy9Ygc2ocWw1CIWO9fF4x2rcJdJ7wv/1jSdR0gx7aHG5PjGFblk2YGXXpUpSy0C
yUuT8SH+kdjC9uW7EJWYI/5UftOm7xA9E7PxtDR4dyVpf+WThtO2TgBJD8sVMIVl
PB/yOCYbr4w1+4AtR78uaqsiwkawwg28w3bTXUOmIR2KSPsAvLjm8/limYRweSv6
qC/6vRlUwm6oHRfMkM30qHd7GT3klJSngUNsOKZxTrPzyXvjqWWl8Y4zuuKZR7CK
r+kn3t2rmpwHVV/kKyWcDmWBKTGWwy7huL4RhkCjRL2Esa3KNoOi4XqSx+/ZMfjc
79WHcH1UOCQI7lIoWIVxV7vbKVdaez25eImXcMyEP2wsLTbSB0AEZm0NIFTyVv78
8Ohhb91Z37pFg6p2Q65V
=Xyg8
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
