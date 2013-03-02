Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3CBTsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:48:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab3CBTsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:48:14 -0500
Message-ID: <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sat, 02 Mar 2013 19:48:02 +0000
In-Reply-To: <1362172344.20156.15.camel@x61.thuisdomein>
References: <20130301194351.913471337@linuxfoundation.org>
	 <20130301194355.578429064@linuxfoundation.org>
	 <1362172344.20156.15.camel@x61.thuisdomein>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GLnuQQLz7b0Vua9BtO87"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GLnuQQLz7b0Vua9BtO87
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-01 at 22:12 +0100, Paul Bolle wrote:
> On Fri, 2013-03-01 at 11:44 -0800, Greg Kroah-Hartman wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >=20
> > commit 01c681d4c70d64cb72142a2823f27c4146a02e63 upstream.
> >=20
> > The 'handle' is the device that the request is from. For the life-time
> > of the ring we copy it from a request to a response so that the fronten=
d
> > is not surprised by it. But we do not need it - when we start processin=
g
> > I/Os we have our own 'struct phys_req' which has only most essential
> > information about the request. In fact the 'vbd_translate' ends up
> > over-writing the preq.dev with a value from the backend.
>=20
> Unless that call to vb_translate() fails, doesn't it? Wouldn't preq.dev
> still contain random data in that case?
>=20
> > This assignment of preq.dev with the 'handle' value is superfluous
> > so lets not do it.
> >=20
> > Acked-by: Jan Beulich <jbeulich@suse.com>
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > ---
> >  drivers/block/xen-blkback/blkback.c |    1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> > @@ -879,7 +879,6 @@ static int dispatch_rw_block_io(struct x
> >  		goto fail_response;
> >  	}
> > =20
> > -	preq.dev           =3D req->u.rw.handle;
> >  	preq.sector_number =3D req->u.rw.sector_number;
> >  	preq.nr_sects      =3D 0;
> > =20
>=20
> This introduces a new GCC warning in the stable 3.8.y tree:
>     drivers/block/xen-blkback/blkback.c: In function 'dispatch_rw_block_i=
o':
>     drivers/block/xen-blkback/blkback.c:904:3: warning: 'preq.dev' may be=
 used uninitialized in this function [-Wuninitialized]
>=20
> It does look GCC is right here. But I'm totally new to the code in
> question, so I'll just ask whether this can really go in stable as is.

When gcc compiles something like this:

static int foo(int *p)
{
	if (rand() & 1)
		return -1;
	*p =3D 0;
	return 0;
}

int bar(void)
{
	int i;
	if (foo(&i) < 0)
		return 1;
	return i;
}

and inlines foo() into bar(), sometimes it fails to recognise that i
will definitely be initialised before use.  This simple example seems to
be OK but more complex functions such as these will often trigger this
warning.  The warning is really quite useless now.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-GLnuQQLz7b0Vua9BtO87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTJXc+e/yOyVhhEJAQpY1g//QXsGPYdj0UxLAlbyT7xXyeD1t5iZXoE6
sDQFVbT8DmtCDoLOxUtrkJzz657ZhNGzEJK3ppKJHRPdq0egD2EhxPbzX+bw6fa7
fxjc10l/nimM8WNiSlcbKO7fZ6yjDziqfXltFOc2vYgTukyoHFVdQkMBoYusz3+7
eSqMhmVJJyTeHakA8vm2LHTOsW+xiTAXo3oPMu4KIqGUQETA8pmik1F+B2/YlRjZ
dXA8hE0A/Nmh7y7cwfRGvvLlOBXHYE+k3HPq6N9vk/1nWKX6acGtR1k67/mwlIqM
aKJM29ZufCWRFm7c1NuH8KUNL7XpkPAMR2BlNzGQadYsi9OAjRtSztNrzf80fmOS
MRzsQOxNlinXp3Ke4cONB8sfAr9MAoxQBqf9p8ZADrJL6Zfx9hbHLUq7YogRS35L
l5oHxWIKrL0adsKsE6DridGjWh1mUiMcJ8UN1bftLvwBE81ZVALf5QPMENJis+0H
fBDZP5DIePyPaPFUFfzS5Ya1H6ALMacubadUEmMr7FphOHhR0GjieQ30/i27w/HD
rj39CwZR+OBCiyptFt+YzPqcjDMHHaCs6SbzKXdT0UR9+sRGC+qAn6TzIFcKGSwB
RHpiZhh5y8r/BsVScLxmT8VCECagPa/y61AvensKsJ8Vy+eUUP4r2x1kUUCcRRfP
asKn8emB8I0=
=NQDm
-----END PGP SIGNATURE-----

--=-GLnuQQLz7b0Vua9BtO87--
