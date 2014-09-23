Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaIWErE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:47:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbaIWErA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:47:00 -0400
Date: Tue, 23 Sep 2014 14:46:50 +1000
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923144650.2aa71b39@notabene.brown>
In-Reply-To: <20140923041817.GA11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
	<20140923041817.GA11740@mtj.dyndns.org>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7vLqeqVQ/f9Lj6Qnut_BJf."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7vLqeqVQ/f9Lj6Qnut_BJf.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2014 00:18:17 -0400 Tejun Heo <tj@kernel.org> wrote:

> On Tue, Sep 23, 2014 at 02:06:33PM +1000, NeilBrown wrote:
> ...
> > Note that reads from a sysfs file are already safe due to the use for
> > seqfile.  The first read will allocate a buffer (m->buf) which will
> > be used for all subsequent reads.
>=20
> Hmmm?  How is seqfile safe?  Where would the seq op write to?

seqfile is only safe for reads.  sysfs via kernfs uses seq_read(), so there
is only a single allocation on the first read.

It doesn't really related to fixing writes, except to point out that only
writes need to be "fixed".  Reads already work.

Separately:

> Ugh... :( If this can't be avoided at all, I'd much prefer it to be
> something explicit - a flag marking the file as needing a persistent
> write buffer which is allocated on open.  "Small" writes on stack
> feels way to implicit to me.

How about if we add seq_getbuf() and seq_putbuf() to seqfile
which takes a 'struct seq_file' and a size and returns the ->buf
after making sure it is big enough.
It also claims and releases the seqfile ->lock.

Then we would be using the same buffer for reads and write.

Does that sound suitable?  It uses existing infrastructure and avoids having
to identify in advance which attributes it is important for.

Thanks,
NeilBrown

--Sig_/7vLqeqVQ/f9Lj6Qnut_BJf.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCD7Ojnsnt1WYoG5AQKp3w/+NCYAwSxS5P05TsZe7dhBp4LSDzpEODl9
nDxOSZG/VQGNB1U7A5y608x+Qy9cwIZH7hPdB6DiosMTmtGP2gTNbkwJdBCjNrHc
QkxW3WNsOxFC29ASoPdtTYiJ/8hS4/0K2jLCklmtrwUwdppTFVQDUIyTfLN/Gpbr
pm/fhB2aiPt64m8JmkWoaCPmsrTHJkOhNOthPAn67JIvOgNYi3sfWbLhrFDc1BI9
PNj+ObtXS0jP4VotuoCDqHNRVaAG/u6Y+tYBncMlYxQayh0FEh7Se+FdjoUG2R/z
0r/yYFeSWXUD3h8UJWJGHwtutBGdHChnTe2r/711104jGiHYx3BxNsVI76OCMSkU
eW5ejOXYMtAExMxeggu6H5Elq391SxfOkZxGwUfs6TkoH53FYQOFkKtupwSasIKk
Onhxt6wRmrMvONDMAadNW6t57wDtxuF8IPWAv2OZTn0SA3D/iSd2YBbhwBoItGKu
2ZBP9BrjBwCswFU1PGkpXoJJMQBpr1LcgvGw7autT7NZvgGAGGK/z1HT9x2/mpcx
4dLPJ8Ursdullas1l8PYw9toZv8o7231ssgXwTu+22vYXtMvZXQiZv0SBuwsj4KA
QTwLKcInOX1zJhXuSCXBj22ReqmrnxMhWtiWjSSbNTOUYvYXYiycIx9+heG3dMnv
y5sviR7durk=
=Dqt0
-----END PGP SIGNATURE-----

--Sig_/7vLqeqVQ/f9Lj6Qnut_BJf.--
