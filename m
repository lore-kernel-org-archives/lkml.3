Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaGBQE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:04:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:33212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaGBQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:04:25 -0400
Date: Wed, 2 Jul 2014 18:04:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140702160412.GO19379@twins.programming.kicks-ass.net>
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iKKZt69u2Wx/rspf"
Content-Disposition: inline
In-Reply-To: <20140702153915.GQ4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iKKZt69u2Wx/rspf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 08:39:15AM -0700, Paul E. McKenney wrote:
> On Wed, Jul 02, 2014 at 02:34:12PM +0200, Peter Zijlstra wrote:
> > On Fri, Jun 27, 2014 at 07:20:38AM -0700, Paul E. McKenney wrote:
> > > An 80-CPU system with a context-switch-heavy workload can require so
> > > many NOCB kthread wakeups that the RCU grace-period kthreads spend se=
veral
> > > tens of percent of a CPU just awakening things.  This clearly will not
> > > scale well: If you add enough CPUs, the RCU grace-period kthreads wou=
ld
> > > get behind, increasing grace-period latency.
> > >=20
> > > To avoid this problem, this commit divides the NOCB kthreads into lea=
ders
> > > and followers, where the grace-period kthreads awaken the leaders eac=
h of
> > > whom in turn awakens its followers.  By default, the number of groups=
 of
> > > kthreads is the square root of the number of CPUs, but this default m=
ay
> > > be overridden using the rcutree.rcu_nocb_leader_stride boot parameter.
> > > This reduces the number of wakeups done per grace period by the RCU
> > > grace-period kthread by the square root of the number of CPUs, but of
> > > course by shifting those wakeups to the leaders.  In addition, because
> > > the leaders do grace periods on behalf of their respective followers,
> > > the number of wakeups of the followers decreases by up to a factor of=
 two.
> > > Instead of being awakened once when new callbacks arrive and again
> > > at the end of the grace period, the followers are awakened only at
> > > the end of the grace period.
> > >=20
> > > For a numerical example, in a 4096-CPU system, the grace-period kthre=
ad
> > > would awaken 64 leaders, each of which would awaken its 63 followers
> > > at the end of the grace period.  This compares favorably with the 79
> > > wakeups for the grace-period kthread on an 80-CPU system.
> >=20
> > Urgh, how about we kill the entire nocb nonsense and try again? This is
> > getting quite rediculous.
>=20
> Sure thing, Peter.

So you don't think this has gotten a little out of hand? The NOCB stuff
has lead to these masses of rcu threads and now you're adding extra
cache misses to the perfectly sane and normal code paths just to deal
with so many threads.

And all to support a feature that nearly nobody uses. And you were
talking about making nocb the default rcu...



--iKKZt69u2Wx/rspf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtC18AAoJEHZH4aRLwOS6/SAP/jgfqkUEN7HSc1EROwk6A6uH
dXa1k4iZhwA2cG8qkyuY+5N4Hw8liATvFt6uf2WJhzNcYvngRWc14o6xoM6JjQlH
qWEvgK6AX3MaWRqEfIZ+kRsrAH5UaDG7623/dMBu8KoVjxf9b2iY6YAnT5pfsX6p
l2LQrb+CDpXe/zywIopavyyKIspnht5eGiyAZxi5k7DjGpq277MdsLLuSN7m8ejb
A9TJibh1ntvV1F9mLrbFv85eLMGliPc8hDeGflE1tpgOFUD+DXis33BB0GwIY8+/
DKjNHgF3R/EtWw51tpM9oAasEbRS6ifIDbtOTwvh2gQgDApKr8UE1PkZM0rRc2k4
kqL67c8PK10Adwxa+PNDrLp+qRboWChAGS6PT7s/6YMwm+AOz0c1PFUD2Xz8/QHh
lF60P1m7Wt8N5KgT89ZHTno0e3NbJlTLH6EO0zKzJuSi7fOFk6aIMyq90z8XpfMI
mUApUvcPzUQAZRWI2OUI/NAhdXn3dgTlMgnC0DPJyaugZm3CjaYZAYzchZ7gvzjn
Yfp3x7f0X7esqLmcLlD17fhZbksiLhSOJzpeFJMWGyDCr8jPjbPbkiMQcihaEzXI
Mw8VvdJUF+/+r6r7n8ICnea9rGGFbesKahckBPG8d2eDgR/jSb9nYEsiL6MwlLk4
V7Vprine/WhkZvXf7eNi
=x7Th
-----END PGP SIGNATURE-----

--iKKZt69u2Wx/rspf--
