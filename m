Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaGHNKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:10:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:54693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaGHNKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:10:06 -0400
Date: Tue, 8 Jul 2014 15:09:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
Message-ID: <20140708130958.GG6758@twins.programming.kicks-ass.net>
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0mrGdROycKaeLXMw"
Content-Disposition: inline
In-Reply-To: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0mrGdROycKaeLXMw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 03:00:17PM +0200, Stefan Bader wrote:
> When reading from /proc/stat we allocate a large buffer to maximise
> the chances of the results being from a single run and thus internally
> consistent.  This currently is sized at 128 * num_possible_cpus() which,
> in the face of kernels sized to handle large configurations (256 cpus
> plus), results in the buffer being an order-4 allocation or more.
> When system memory becomes fragmented these cannot be guarenteed, leading
> to read failures due to allocation failures.

> @@ -184,7 +184,7 @@ static int show_stat(struct seq_file *p, void *v)
> =20
>  static int stat_open(struct inode *inode, struct file *file)
>  {
> -	size_t size =3D 1024 + 128 * num_possible_cpus();
> +	size_t size =3D 1024 + 128 * num_online_cpus();
>  	char *buf;
>  	struct seq_file *m;
>  	int res;

Old thread, and already solved in the meantime, but note that
CONFIG_NR_CPUS _should_ have no reflection on num_possible_cpus().

The arch (x86 does) should detect at boot time the max possible CPUs the
actual hardware supports and put num_possible_cpus() to that number. So
your typical laptop will mostly have num_possible_cpus() <=3D 4, even
though CONFIG_NR_CPUS could be 4k.

Of course, if you actually do put 256+ cpus in your system, well, then
the difference between possible and online isn't going to help either.

If on the other hand your 'board' reports it can hold 256 CPUs while in
fact it cannot, go kick your vendor in the nuts.

--0mrGdROycKaeLXMw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu+2mAAoJEHZH4aRLwOS688YP/jJg21XzmYEgZRU9HwyeraVn
LPMZJq3KD51u0A5Po5nRhHcZaR0KrUuRHM7f9fVI+XD/e7gEJ8UCiKwyEhXbbnql
E2EWOjDCIWwFBUWOCyVd0CUyEax5JYH9mJW2tvy9iAysSvds2LA0qTlNwfHZNAdb
WssVjQo7rK4hGQS7IIwH/JUXve95fjMbkv8BwW/1tzED8/v7brN2JmgJnXN3C6p/
84OEC2pChUobzRDy12L2PK99BEoMUrG8EAPnpQ7tXKSP9q957KmnnTg13my3shAB
48yt7+yZHR4MdpdwVW06Yv3xE3uHWo7rx56kyWZuHyL7oYqJh+AXlaPZo3U/oz/f
0EYyF68X94EsRVW1r11LCVvoFrTOnG9E19sBFUpKOyhyJgPYQYw2Uj+zapBwfz4+
8j5D9Ydv8C+u4hnEU/OJWXiZaVO5/Ap/biBu0aXjYTB8/C21jaVwKznPRFE6LAnN
ztEyxrm7QmtmIfOEfojNtQ0+IeMPwDKyCFDtjVoDP/GQQdG9d6A2wraG/KlX5sSZ
HiKMoGnxsvux46NSELY/SaIwOy0kHbNMvaTLnKWEOvar5XMr1J/5j0qcZd30ar/q
zQC/3RhbtszAhR9Xh+CuEkyJO6jtFr33dqsRh7ZNc51JkMU4jE6DCnGZqlmm9FrF
ok9FynPJHepH6nh6n6o1
=aUzr
-----END PGP SIGNATURE-----

--0mrGdROycKaeLXMw--
