Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaCVPxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:53:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37691 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbaCVPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:53:18 -0400
Message-ID: <1395503588.2770.69.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.13 110/149] ASoC: pcm: free path list before exiting
 from error conditions
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Patrick Lai <plai@codeaurora.org>, Mark Brown <broonie@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 22 Mar 2014 15:53:08 +0000
In-Reply-To: <20140321000440.772268771@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
	 <20140321000440.772268771@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+oX9XUQlsGjJZRLTcYOR"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+oX9XUQlsGjJZRLTcYOR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-03-20 at 17:04 -0700, Greg Kroah-Hartman wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Patrick Lai <plai@codeaurora.org>
>=20
> commit e4ad1accb28d0ed8cea6f12395d58686ad344ca7 upstream.
>=20
> dpcm_path_get() allocates dynamic memory to hold path list.
> Corresponding dpcm_path_put() must be called to free the memory.
> dpcm_path_put() is not called under several error conditions.
> This leads to memory leak.

This is broken.  dpcm_path_get() may return -ENOMEM and not initialise
the list at all.

If snd_soc_dapm_dai_get_connected_widgets() can fail (I don't think it
can) then dpcm_path_get() should be responsible for freeing the list
before returning.

[...]
> --- a/sound/soc/soc-pcm.c
> +++ b/sound/soc/soc-pcm.c
[...]
> @@ -1979,6 +1981,7 @@ static int dpcm_fe_dai_open(struct snd_p
>  	fe->dpcm[stream].runtime =3D fe_substream->runtime;
> =20
>  	if (dpcm_path_get(fe, stream, &list) <=3D 0) {
> +		dpcm_path_put(&list);

This is the one place where a memory leak seems to be possible, but the
< 0 and =3D=3D 0 cases need to be distinguished.

Greg, please drop this until it is fixed properly upstream.

Ben.

>  		dev_dbg(fe->dev, "ASoC: %s no valid %s route\n",
>  			fe->dai_link->name, stream ? "capture" : "playback");
>  	}

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-+oX9XUQlsGjJZRLTcYOR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUy2x5Oe/yOyVhhEJAQqxihAAv08mYOulzvZkLpzXOW32FCxoe+/ne1vu
GXmILhUhGhcvkYmI/KISEApmdKc6HyFwQFlhsDcoh6y8DLQlNNrMQz12parzDQsl
JVTSQKi/dgl91PxZ0h1YALP4eJL+zayMoAgX5hngn8EFllvkFHlF09/tJ/t7nWWe
6UTyhZZHreNcglROK1V+uxePWB8tMJHg4EZSlSQw+ODe+XR5STkqDrdNj1gHoz08
RdRKLDlSF8aq2coGMKcwA+u/LIb9SDmitej+AhvadadNMnmIshmRKBQIXJButcwU
Q6DCNoruzxiGH1+LpZKJsWVCjg6wmnvrBvQG9eOW8UeiTPJFd2ZXI8/QP4xTGY+6
spfJe+5qfdp9LEDOSsKi5StfiZUTYqs4uQ9tkjYEkwV567kQwKy893WZV/9Ki1e1
y0JSFgb66gA85CJGvJgiDpI/FS0Mgo3J0kczR8VNZe9oJox6XFFmTelP8t0In/EW
kP2u5qcI+SGYCmTMCGiHswiaQu/jkczs9G2w4hb5ZqulGIcp67B40ZreQ2F6/mWx
/ZfCA8sAol9NLwN0aS/BsNmqNCXTm+Qk3Nn7jmr0rdGchG8VnogRT95eWgkiBe8j
b1RiGqO/1BzjOHKrueZfYhdryrAGnvMXlSQ3OID47Zv0hZcLqX0944xuiQ/By3V7
n11E2Mldnc8=
=g+Do
-----END PGP SIGNATURE-----

--=-+oX9XUQlsGjJZRLTcYOR--
