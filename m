Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaFDHo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:44:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaFDHo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:44:28 -0400
Date: Wed, 4 Jun 2014 09:44:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: umgwanakikbuti@gmail.com, mingo@kernel.org, tglx@linutronix.de,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] sched,idle: Clear polling before descheduling the
 idle thread
Message-ID: <20140604074416.GH30445@twins.programming.kicks-ass.net>
References: <cover.1401841482.git.luto@amacapital.net>
 <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Td065rRKAY1Vpy0"
Content-Disposition: inline
In-Reply-To: <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Td065rRKAY1Vpy0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 05:29:50PM -0700, Andy Lutomirski wrote:
> Currently, the only real guarantee provided by the polling bit is
> that, if you hold rq->lock and the polling bit is set, then you can
> set need_resched to force a reschedule.
>=20
> The only reason the lock is needed is that the idle thread might not
> be running at all when setting its need_resched bit, and rq->lock
> keeps it pinned.
>=20
> This is easy to fix: just clear the polling bit before scheduling.
> Now the polling bit is only ever set when rq->curr =3D=3D rq->idle.

Yah, except of course:

  lkml.kernel.org/r/20131120162736.508462614@infradead.org

which I really need to rebase and post again :/

In any case, this is useful even with that, although then we really must
do something like:

  rcu_read_lock();
  if (!set_nr_if_polling(rq->curr))
  	smp_send_reschedule(rq->cpu);
  rcu_read_unlock();

Because there's other tasks than rq->idle which might be 'idle', joy!

--+Td065rRKAY1Vpy0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjs5QAAoJEHZH4aRLwOS6HNQP+wV1r0AV7jiYTZzVsa2ET5r8
zZZcndwKzgq0vaTSpWcDp3MEFh/2XPxsqq089PZ8cOeYpFeqzTyGMX21IaA2P38U
R/g7RWvFMP4OkbZirBZbHHWMGbDBcm/eQd9LDRXdnLQGdP8//QOLY7bvkfI1Bsp6
uooQJvTsHBJdSfoWfwO+dak9CAFpvzJnxk/hTyeQ3Dy38vE+UCx9HmnGG07Eeoby
uLBycQUBoyFSMj9wGuqNPQHET4Yl7/mUziQwblvcTiix7TwBLH7JTSIS/F628rEq
wKyHCQMC7JYY8UiDzojgvBRIzsLKlfSEbswFZNPKmSMGufzfYz1WEjJTTSbIpyS4
2cPQ1z4zTOMPSSV032ccJgOsYGFnmYN2AZ295KoZ8acdm9U+sGDjwkyg9/GO5tEG
pj3hmqz+KxJkOh5Sz/Q+sVSWUDm5ClxvI6uWSyHHWoAKEnOd5xYydWC/exGQXjGg
qXrMYdxdEUveqVeJc5aZRgwQwMCeNabOLFk8H+DXYGeJ9X+C1UQkMdJIK2e7O/zt
r6OzbtzA5r7GxljyQnWuB+fWX1e4EEwzmkPcKN//7yTTmJnT9NlnWN0IyaivDG3H
v1r3COOV3bVIf2FR1tMBE7y1X7sDDKpb+DOs7uTqvH9yjKv7CESAV64TaCnRVrKh
nn1c8vGCQ3eEy0NKcJyM
=3dA6
-----END PGP SIGNATURE-----

--+Td065rRKAY1Vpy0--
