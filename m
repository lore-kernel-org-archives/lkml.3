Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaENK0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:26:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaENK0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:26:10 -0400
Date: Wed, 14 May 2014 12:26:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140514102602.GJ30445@twins.programming.kicks-ass.net>
References: <20140224121218.GR15586@twins.programming.kicks-ass.net>
 <534610A4.5000302@oracle.com>
 <53464164.5030701@linux.vnet.ibm.com>
 <336561397137116@web27h.yandex.ru>
 <5347FCED.8040706@oracle.com>
 <1442521397229373@web20m.yandex.ru>
 <53711785.5010504@oracle.com>
 <2614131400060552@web30m.yandex.ru>
 <20140514101354.GI30445@twins.programming.kicks-ass.net>
 <2158101400062864@web10h.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fis3l7cGi4BLWycj"
Content-Disposition: inline
In-Reply-To: <2158101400062864@web10h.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fis3l7cGi4BLWycj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 02:21:04PM +0400, Kirill Tkhai wrote:
>=20
>=20
> 14.05.2014, 14:14, "Peter Zijlstra" <peterz@infradead.org>:
> > On Wed, May 14, 2014 at 01:42:32PM +0400, Kirill Tkhai wrote:
> >
> >> =A0Peter, do we have to queue stop works orderly?
> >>
> >> =A0Is there is not a possibility, when two pair of works queued differ=
ent on
> >> =A0different cpus?
> >>
> >> =A0=A0kernel/stop_machine.c | 10 ++++++++--
> >> =A0=A01 file changed, 8 insertions(+), 2 deletions(-)
> >> =A0diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> >> =A0index b6b67ec..29e221b 100644
> >> =A0--- a/kernel/stop_machine.c
> >> =A0+++ b/kernel/stop_machine.c
> >> =A0@@ -250,8 +250,14 @@ struct irq_cpu_stop_queue_work_info {
> >> =A0=A0static void irq_cpu_stop_queue_work(void *arg)
> >> =A0=A0{
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct irq_cpu_stop_queue_work_info *inf=
o =3D arg;
> >> =A0- cpu_stop_queue_work(info->cpu1, info->work1);
> >> =A0- cpu_stop_queue_work(info->cpu2, info->work2);
> >> =A0+
> >> =A0+ if (info->cpu1 < info->cpu2) {
> >> =A0+ cpu_stop_queue_work(info->cpu1, info->work1);
> >> =A0+ cpu_stop_queue_work(info->cpu2, info->work2);
> >> =A0+ } else {
> >> =A0+ cpu_stop_queue_work(info->cpu2, info->work2);
> >> =A0+ cpu_stop_queue_work(info->cpu1, info->work1);
> >> =A0+ }
> >> =A0=A0}
> >
> > I'm not sure, we already send the IPI to the first cpu of the pair, so
> > supposing we have 4 cpus, and get 4 pairs like:
> >
> > 0,1 1,2 2,3 3,0
> >
> > That would result in IPIs to 0, 1, 2, and 0 again, and since the IPI
> > function is serialized I don't immediately see a way for this to
> > deadlock.
>=20
> It's about stop_two_cpus(), I have a distrust about other users of stop t=
ask:
>=20
> queue_stop_cpus_work() queues work consequentially:
>=20
> 0 1 2 4
>=20
> stop_two_cpus() may queue:
>=20
> 1 0
>=20
> Looks like, stop thread on 0th and on 1th are waiting for wrong works.

so we serialize stop_cpus_work() vs stop_two_cpus() with an l/g lock.

Ah, but stop_cpus_work() only holds the global lock over queueing, it
doesn't wait for completion, that might indeed cause a problem.

Also, since its two different cpus queueing, the ordered queue doesn't
really matter, you can still interleave the all and two sets and get
into this state.

--fis3l7cGi4BLWycj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc0S6AAoJEHZH4aRLwOS6S0UQAKNMjOZQyCrxelSlHboDqSjm
b6tUA3ldYIspYAE/d/HmVs0W1DHOhv5SegfQElZNxonpEURsR1SbQuDjB1s/enaR
xGXpMwSlRL1W+rJWDnF/uBLY6nJNNA/XZ6hDH0UGvgfAS0WGRuDjVgt0ChB3gmVB
Wv+08YLdYhI77/fBa1P+dz38qIvfvEx2Uby8h/L+BivQz/j12bJFwTi3YJ9efj/q
nH4UiClVtOE5dtOsft6574fPtHrBYd6lTCTtpYzV5ZQtfTIlBoVw4FNmhg/pNU1p
a24v0dWMt574TNy07ALUOL+fH1MBk6uu1XPf8cMoUvzXczbjOT6XxBYMyagO2yRe
iN69NJ5CY5NxkDjDAv5EHEa5NpEY6VuGTCZpZrRFvaBsEwWGIvSYiaO1csd4dwv3
gYNpyQ0oYZWSCByMjJVI5S1AIxPgGxZ0RXLLuQgofDsmztsQ4l5cw2TAFJWRQVL+
GblIt58H0hP0bzrW2xbamBFqNcwraGgvRG0/CtEPxaGalw2lMalA311/H+2utdqT
wfwBAdCVPhjL9OIVZxarv8kYxzAPSzquUgizD1QZ16MrtiXpa5vz4xSzqW1kqOH1
j69KdHL8lRinNRVZjPobo7jLm+p82bVTLZcPmFX7UCA+y4xuc2kkULqTHr18FKWv
+5nIgcKJQ22rhF8F4GVx
=mdIE
-----END PGP SIGNATURE-----

--fis3l7cGi4BLWycj--
