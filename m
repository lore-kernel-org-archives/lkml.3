Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaHAIsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:48:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaHAIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:48:30 -0400
Date: Fri, 1 Aug 2014 18:48:15 +1000
From: NeilBrown <neilb@suse.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] VFS: allow ->d_manage() to declare -EISDIR in rcu_walk
 mode.
Message-ID: <20140801184815.22dd193f@notabene.brown>
In-Reply-To: <20140801083318.GA4907@mwanda>
References: <20140730160833.5eac00ec@notabene.brown>
	<20140801083318.GA4907@mwanda>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/fJpCSNY6NQRXtXhKzCFGz92"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fJpCSNY6NQRXtXhKzCFGz92
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Aug 2014 11:33:18 +0300 Dan Carpenter <dan.carpenter@oracle.com>
wrote:

> On Wed, Jul 30, 2014 at 04:08:33PM +1000, NeilBrown wrote:
> > @@ -1110,11 +1110,16 @@ static bool __follow_mount_rcu(struct nameidata=
 *nd, struct path *path,
> >  		 * Don't forget we might have a non-mountpoint managed dentry
> >  		 * that wants to block transit.
> >  		 */
> > -		if (unlikely(managed_dentry_might_block(path->dentry)))
> > +		switch (managed_dentry_rcu(path->dentry)) {
> > +		case -ECHILD:
> > +		default:
> >  			return false;
> > +		case -EISDIR:
> > +			return true;
> > +		}
> > =20
>=20
> Smatch says that any lines after that switch statement are unreachable.
>=20
> Is the "default" intended?

Ugh.  It was an after thought.

The defined error codes are -ECHILD and -EISDIR.
But current code actually treats any other negative number as -ECHILD.
So I stuck in the default .... which of course was wrong.
I need to add
   case 0:
       break;

I'll send that out on Monday.

Thanks heaps.

NeilBrown


>=20
> >  		if (!d_mountpoint(path->dentry))
> > -			return true;
> > +			return !(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT);
> > =20
> >  		mounted =3D __lookup_mnt(path->mnt, path->dentry);
> >  		if (!mounted)
>=20
> regards,
> dan carpenter


--Sig_/fJpCSNY6NQRXtXhKzCFGz92
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9tUTznsnt1WYoG5AQJITA//Qcwvw+hzqGi6tD5Xcqh6YL30ZpjA6AQo
bF3kU0j/OV6ywTVCX83Zqx1gB5U1NEHxz2IzAz/qpfqvmfbpQ0s3yBkpjCQau31E
lK4Vufv8Vv1YeTnuzt6pm0hRBny50juZFJnMHEtGzTBLMkN/zMSvG48l8gBuGXer
MGN2f5Uw5TY+0iytO5UG5X0WAkQ5nVGRgp5B8nYhUOsy4vdqkH4mHnD5ixZDuFRk
0K1oO2WlZEIVv/I1XJpT3hquDPYe9Fp/uJ0v3SX9Qka6r8FiBrmnq3mtb8DKAnUU
Zncg4FHYXfsWDvDHLFuZQf67MBje4md35J3zWniKQoioetZSg2Jh9CCzWWJtwopi
z5ZJlho9L65oW+qrq7+Un4MSNJyPxNcDDnCCbmWUNGfBBtcZBOFZI4rCEqgjiopB
rIRkAm4rewPxDnPxPPKVYueOm20tUO5aps211pL/9H/FXLkuAwyRelxG2Sh65a9y
WqjTqoM8EWb6Dp7PjceId0tK8Ux5wKy46Fowck2HiNy3ylLVhEbMlkFqnKFRIIVm
eEcQGRcoQwXbPo8F5r1B4Po4WvQFuuc2fsVuwSFK56Dd/kv9FRRSYD/9lsuEJZEy
IDBMyv+tEKN5051TiXyFKX8BP7ZCj1oYA684gw/8tqNFcHrLUc5agFHk9ycT6OrL
INGvK6D1Cs8=
=28nR
-----END PGP SIGNATURE-----

--Sig_/fJpCSNY6NQRXtXhKzCFGz92--
