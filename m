Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbAUOma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:42:30 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61858 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbAUOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:42:21 -0500
Date: Wed, 21 Jan 2015 15:42:16 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Guenter Roeck <linux@roeck-us.net>,
        Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121144214.GA22884@ulmo.nvidia.com>
References: <20150120165655.GA10904@kria>
 <20150120232726.GA16913@kria>
 <1517211.UYLV49hvpg@sifl>
 <1528536.jyty2pu4Mz@sifl>
 <20150121004117.GM29656@ZenIV.linux.org.uk>
 <54BF1292.2080902@roeck-us.net>
 <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
 <20150121110539.GA8924@kria>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20150121110539.GA8924@kria>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 12:05:39PM +0100, Sabrina Dubroca wrote:
> 2015-01-21, 04:36:38 +0000, Al Viro wrote:
> > On Tue, Jan 20, 2015 at 08:01:26PM -0800, Guenter Roeck wrote:
> > > With this patch:
> > >=20
> > > sys_mkdir .:40775 returned -17
> > > sys_mkdir usr:40775 returned 0
> > > sys_mkdir usr/lib:40775 returned 0
> > > sys_mkdir usr/share:40755 returned 0
> > > sys_mkdir usr/share/udhcpc:40755 returned 0
> > > sys_mkdir usr/bin:40775 returned 0
> > > sys_mkdir usr/sbin:40775 returned 0
> > > sys_mkdir mnt:40775 returned 0
> > > sys_mkdir proc:40775 returned 0
> > > sys_mkdir root:40775 returned 0
> > > sys_mkdir lib:40775 returned 0
> > > sys_mkdir lib/modules:40775 returned 0
> > > ...
> > >=20
> > > and the problem is fixed.
>=20
> This patch also works for me.
>=20
>=20
> > ... except that it simply confirms that something's fishy with getname_=
kernel()
> > of ->name of struct filename returned by getname().  IOW, I still do not
> > understand the mechanism of breakage there.
>=20
> I'm not so sure about that.  I tried to copy name to a new string in
> do_path_lookup and that didn't help.
>=20
> Now, I've removed the
>=20
>         putname(filename);
>=20
> line from do_path_lookup and I don't get the panic.

That would indicate that somehow the refcount got unbalanced. Looking
more closely it seems like the various audit_*() function do take a
reference, but maybe that's not enough.

But debugging this further I see no indication that the memory is ever
freed, or otherwise corrupted.

I did collect a bit more data, perhaps that's useful. I started seeing
this issue as well on devices that boot over NFS. After reading this
thread I also realized that another warning that I was seeing might be
related:

	[   28.261930] Warning: unable to open an initial console.

I've added a couple of printks and see that the reason for this is that
/dev/console doesn't get created. /dev however does get created.

	[   11.786627] sys_mkdir dev:40755 returned 0
	...
	[   11.978748] sys_mknod dev/console:20600 returned -2

The chain that fails turns out to be this:

	sys_mknod()
	  sys_mknodat()
	    user_path_create()
	      kern_path_create()
	        do_path_lookup()
	          filename_lookup()
	            path_lookupat()
	              path_init()
	                link_path_walk()
	                  walk_component()

walk_components() ends up calling lookup_slow() and the result is that
inode =3D=3D NULL and d_is_negative(path->dentry) returns true, therefore
causing -ENOENT to be returned.

I tried to figure out why inode would be NULL at that point or why
d_is_negative() returned true, but I ended up getting completely lost,
so I thought it best to report my findings before I confuse everything.

Is there anything else I can investigate to track this down?

Thierry

--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUv7rGAAoJEN0jrNd/PrOh0aQP/3+W3EfMdwuD5/zNXQF/qmUv
90wkYaEzW0o4dKClyybNqomX+P1jotcN2ihYuTTN94IZal6MK3Y+KQxPC3MhnsI9
Va2SoTIvIDRDHmRYjzxv9gDFK63eHHwiYKQotKaNFRqclhlNReJGU98djmEtriUA
hMZEx/tjFur+w+ZON5A0+btnofud8YFqx0sQdT0Iyyrnh/NhalCCkPtccCGSUN7/
e8uChuLJ0V9+ETaSsgfVifQGGMVua0R0ZopyRebvoTihCI4GONURhh3nRnm0vJN5
tiaBs3PGZKa/8U7Jw1aKbClKl/jVgBeqJNIsyWVq2IsYq4fqjOP5yBl5LFR4yLLK
wmhZ5x5I7dBipWPDhVcCltxbJhcEpZ4HKG0zsPzLZqWi4Dt1sZlO2eJTEnlL9spL
o85MmX/DadFPigMPX2hJP286eUZHAz3N3BRR3qrKA6ACKnN3iEcH8OuuFTETCm6P
R2NftEJRUqsvGObol0divrN2cqxvU9z6HgRD8vomi8EOiFVHjZqTGB5wCSsYR4P7
SD01wGHAFFmUUjo3PfO7z74+I6y4fnSl5CvWyh3zWx/0HZ9L8JlPa517JWXIIme7
0qb6JzAIYTaeMpZo+qZFEjYHp9ZzURSTD92Cyr+suMuG2UyJnguD+nJ2oVAHgpz/
MSMAfxrH5C+ENOyMRjUr
=JzO1
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
