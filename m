Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaHGINv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:13:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:45979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaHGINd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:13:33 -0400
Date: Thu, 7 Aug 2014 10:13:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON_ONCE(in_nmi()) hit in irq_work_queue_on
Message-ID: <20140807081321.GI19379@twins.programming.kicks-ass.net>
References: <20140806162113.GC14261@redhat.com>
 <20140806164633.GY3935@laptop>
 <20140806165610.GB12054@laptop.lan>
 <20140806170151.GC12054@laptop.lan>
 <20140806234456.GA17015@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W62FzbuS5Na6+MTw"
Content-Disposition: inline
In-Reply-To: <20140806234456.GA17015@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W62FzbuS5Na6+MTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 01:44:58AM +0200, Frederic Weisbecker wrote:
> In fact the problem has arised since the recent irq work patches I did.

No, those just added the WARN, previously we send the resched IPI, and
that's equally wrong from NMI context.

> There I've changed tick_nohz_full_kick() to use irq_work_queue_on() inste=
ad
> of irq_work_queue() so it has become NMI unsafe by accident.
>=20
> So I'd rather suggest this instead of queuing two levels of irq_work:

> +void tick_nohz_full_kick(void)
> +{
> +	if (!tick_nohz_full_cpu(smp_processor_id()))
> +		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
> +}

Indeed, that's better. Thanks!

--W62FzbuS5Na6+MTw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4zUhAAoJEHZH4aRLwOS6NTsQAIHav5n17FNnIvnZd2SaD6rn
dkZp9HVHvLg7Og0vwwM+SXeAJtrAT88M08rOo6k18DqSzE9GOQbviqmbGaT7F8RN
x+a4f7zujm0JZKUHeT+sHrCWn8aEgTWobFU2EFP8Qbgm7pbQ2O+L8zi6JjNAqpsf
KaYrISfHvenc5/ovxGHTDDJa/N4bAtp7G8gpp+xKLBMWS1IYOq9wSV3PYDHSkG8d
Nhlsun24WK3ga/btRQjEY3gzjX9PCk9QBI+fVhbyg9Kf4Z6illWzYeZl6jbK7Xid
+J8YxNi1ilIte8lKm5yFR0tGn5F66+9NCSCNtAtQRga0r6k83hENnjaLOAXLJUI0
hJUJKF382JOQyxCkhbfimBgvKmZCkLYTSSMlJrYvYgKBUdanSuF+VuelS+YkPF/e
p/iD/y5Bt4YlleCog8JLrZXcW5sPWEant/0O6jn6YajYokzH5mMHROR2Eiz5KWlU
PYUUpoWyd8F8Rt7w9+xWxlPlSybk8tZhQ+23kJDpjTeAcz65mX+10MD7cj0o8nqQ
uPGmeWCoPXk6dDWnD77wuLxjLv446DZlmYEy5YpgiIbN0FgLarw4JyaXIGXQc+0l
ddAdJ0ZMks5Obkt3N8STqX0o96fjcwbgOEYB9oDl81jFzN29EzvzEYNn8f44eBMU
5X7kEeZ1QHnz2XjHtGpP
=cJdr
-----END PGP SIGNATURE-----

--W62FzbuS5Na6+MTw--
