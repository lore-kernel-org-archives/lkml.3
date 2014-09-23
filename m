Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaIWFlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:41:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaIWFlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:41:07 -0400
Date: Tue, 23 Sep 2014 15:40:58 +1000
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923154058.6a1c2449@notabene.brown>
In-Reply-To: <20140923045549.GB11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
	<20140923041817.GA11740@mtj.dyndns.org>
	<20140923144650.2aa71b39@notabene.brown>
	<20140923045549.GB11740@mtj.dyndns.org>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/IEw+uUk3B1Qzay_FdIiC.El"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IEw+uUk3B1Qzay_FdIiC.El
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2014 00:55:49 -0400 Tejun Heo <tj@kernel.org> wrote:

> Hello, Neil.
>=20
> On Tue, Sep 23, 2014 at 02:46:50PM +1000, NeilBrown wrote:
> > seqfile is only safe for reads.  sysfs via kernfs uses seq_read(), so t=
here
> > is only a single allocation on the first read.
> >=20
> > It doesn't really related to fixing writes, except to point out that on=
ly
> > writes need to be "fixed".  Reads already work.
>=20
> Oh, I meant the buffer seqfile read op writes to, so it depends on the
> fact that the allocation is only on the first read?  That seems
> extremely brittle to me, especially for an issue which tends to be
> difficult to reproduce.

It is easy for user-space to ensure they read once before any critical time=
..

>=20
> > Separately:
> >=20
> > > Ugh... :( If this can't be avoided at all, I'd much prefer it to be
> > > something explicit - a flag marking the file as needing a persistent
> > > write buffer which is allocated on open.  "Small" writes on stack
> > > feels way to implicit to me.
> >=20
> > How about if we add seq_getbuf() and seq_putbuf() to seqfile
> > which takes a 'struct seq_file' and a size and returns the ->buf
> > after making sure it is big enough.
> > It also claims and releases the seqfile ->lock.
> >=20
> > Then we would be using the same buffer for reads and write.
> >=20
> > Does that sound suitable?  It uses existing infrastructure and avoids h=
aving
> > to identify in advance which attributes it is important for.
>=20
> I'd much rather keep things direct and make it explicitly allocate r/w
> buffer(s) on open and disallow seq_file operations on such files.

As far as I can tell, seq_read is used on all sysfs files that are
readable except for 'binary' files.  Are you suggesting all files that might
need to be accessed without a kmalloc have to be binary files?

Having to identify those files which are important in advance seems the more
"brittle" approach to me.  I would much rather it "just worked"

Would you prefer a new per-attribute flag which directed sysfs to
pre-allocate a full page, or a 'max_size' attribute which caused a buffer of
that size to be allocated on open?
The same size would be used to pre-allocate the seqfile buf (like
single_open_size does) if reads were supported.

Thanks,
NeilBrown


--Sig_/IEw+uUk3B1Qzay_FdIiC.El
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCEH6jnsnt1WYoG5AQKJBxAAn6nVm4wqIhQZLyKUsIWyfgCrG4yBdLAT
iy4ubM8URXoL3z67JzHud+N5yroRKNepAsM1Zzf5EJlx3Bq2tZ15yX8XZtWp6c2W
Zdpx3MuOSEDZBxgvg4R8bX6G8Rh+9/p6MoJqAJ0D6U0RKImJ5EVZmiBB4jTSWnlI
cuIRxqb4Q4Yezsp5MLNmJtOH+Dv6G8yp8FASO2paJAx5mntl8Pkr5LgaxaB389xt
ocR4Lu+iEG0ea2nXjPDg0VvVhgT+Gm9sRJrHfap7IlTIjnat5f46aUMWZutVw9Fl
OPRoh+CKv+dqQFKgdUQ0Cox4FIzMs/bUYQMsct1lVpS/h5oi1GcvyB/TLjN485i+
dfhoXwIHr4mNlCHYFbzbJgQUPaqOKwgzSnoTZ4jugXprWCM5rEvwqegbMf6Zaa5o
nO20dAk5JFbmNDFodm1/kz/AsI0HMwcVvYitpsD7S5aHrBWmzhy6wdzzHU3NKVjr
nE3UitzHnWbk4NwdUE0+NoUfTqH466dyAedBWxHj0vCPgpZMFtGz7DLKNwV2Pjb2
EuBT135HbpmmQfVQFTdyUdcdcqkAEdrJ+m4FbHmG18OYvumyGtG8QUiqQG9jnkq8
/GNps+9M14xuBZCBpcs7/0lwadmRrKEMWLNNI2UvS2E7jRf2kECeBdq5AV1J6Sly
Nh8iX4YY76k=
=Kwt+
-----END PGP SIGNATURE-----

--Sig_/IEw+uUk3B1Qzay_FdIiC.El--
