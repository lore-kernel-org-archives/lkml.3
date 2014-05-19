Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaESKc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:32:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:32:55 -0400
Date: Mon, 19 May 2014 12:32:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: bsegall@google.com, linux-kernel@vger.kernel.org, pjt@google.com,
        chris.j.arges@canonical.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140519103247.GX30445@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <87lhu215ky.wl%klamm@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hc379uXrspCKzedK"
Content-Disposition: inline
In-Reply-To: <87lhu215ky.wl%klamm@yandex-team.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hc379uXrspCKzedK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 12:38:21PM +0400, Roman Gushchin wrote:

> I still think, there is a deadlock. I'll try to explain.
> Three CPUs must be involved:
> CPU0				CPU1				CPU2
> take rq->lock			period timer fired	=09
> ...				take cfs_b lock
> ...				...				tg_set_cfs_bandwidth()
> throttle_cfs_rq()		release cfs_b lock		take cfs_b lock
> ...				distribute_cfs_runtime()	timer_active =3D 0
> take cfs_b->lock		wait for rq->lock		...
> __start_cfs_bandwidth()=09
> {wait for timer callback
>  break if timer_active =3D=3D 1}
>=20
> So, CPU0 and CPU1 are deadlocked.

OK, so can someone explain this ->timer_active thing? esp. what's the
'obvious' difference with hrtimer_active()?


Ideally we'd change the lot to not have this, but if we have to keep it
we'll need to make it lockdep visible because all this stinks

--hc379uXrspCKzedK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTed3PAAoJEHZH4aRLwOS6U5cP/39MZbNo7xar58ERWw7S/oUU
spe3q9JmQ8ZculRNPVU2xsfx1q0+inWM00tsKaptmZKF1aBcm2kI6n6X+lbw/g8d
En7nezC4qU2OYgQLPvO8ke2EpxU5d/TgzvFN4y315hfZ1/r1DsWmHjWtTpN39aZ8
HVnz7vffT8YR9K/JFp29sKjvj/h7vArgC19aFngPdGLybN9nRU5BKKsWBkygIhYS
cx1IUMViK1Wb2rjHgMxMNBxPWnDnpGg+S+jz2dW6SwYykOtgBNQwero0OjhM/oX6
AdDvfd9sczI8YxSZzk+mSeNqggQMjCwU5JtCfCuUalbAHnv+VP82joqt/CvZHdIM
THIRtyenmIpfdGpGLkYz3/IXjrP5BPRtonkOyNSPdd2EX5q+hneML72SOEG5F2wV
XSPyfq3AwZN3ZS1iewoXQ8e4IxSXoKMqYoreoUPNkujW0BSdXAcVnMsZLZx9tLjK
FmUT6esvqGcABTeUmX2K+J7neMR+dvhcNZqL04G+CDB0FiPO4AC5zH2HJgmaNh0S
0IvTmyUyeHC/GXzrpPkQFjdTvf4ieKEdbps/lUYDPib+ZGNMy5WYHR1/ef8Xu5Ak
1eaAj1GJi3d3hYv0SsDgyqMA0V9VKcK4k8sLIlUoP/vzvZMS6KOTYRvNyxWl5gqs
KZtwZ1ZtrY/QH1rolvJD
=Px/b
-----END PGP SIGNATURE-----

--hc379uXrspCKzedK--
