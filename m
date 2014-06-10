Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaFJMMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:12:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:49141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaFJMM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:12:28 -0400
Date: Tue, 10 Jun 2014 14:12:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140610121222.GE6758@twins.programming.kicks-ass.net>
References: <20140515083531.GE30445@twins.programming.kicks-ass.net>
 <53747EE4.3020605@linux.vnet.ibm.com>
 <20140515090638.GI30445@twins.programming.kicks-ass.net>
 <53748A5D.6070605@linux.vnet.ibm.com>
 <20140515115751.GK30445@twins.programming.kicks-ass.net>
 <5375768F.1010000@linux.vnet.ibm.com>
 <1400208690.7133.11.camel@marge.simpson.net>
 <53759303.40409@linux.vnet.ibm.com>
 <20140516075421.GL11096@twins.programming.kicks-ass.net>
 <5396C82C.6060101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tzjrJU3+iJ6c5SNx"
Content-Disposition: inline
In-Reply-To: <5396C82C.6060101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tzjrJU3+iJ6c5SNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 04:56:12PM +0800, Michael wang wrote:
> On 05/16/2014 03:54 PM, Peter Zijlstra wrote:
> [snip]
> >=20
> > Hmm, that _should_ more or less work and does indeed suggest there's
> > something iffy.
> >=20
>=20
> I think we locate the reason why cpu-cgroup doesn't works well on dbench
> now... finally.
>=20
> I'd like to link the reproduce way of the issue here since long time
> passed...
>=20
> 	https://lkml.org/lkml/2014/5/16/4
>=20
> Now here is the analysis:
>=20
> So our problem is when put tasks like dbench which sleep and wakeup each =
other
> frequently into a deep-group, they will gathered on same CPU when workloa=
d like
> stress are running, which lead to that the whole group could gain no more=
 than
> one CPU.
>=20
> Basically there are two key points here, load-balance and wake-affine.
>=20
> Wake-affine for sure pull tasks together for workload like dbench, what m=
ake
> it difference when put dbench into a group one level deeper is the
> load-balance, which happened less.

We load-balance less (frequently) or we migrate less tasks due to
load-balancing ?

> Usually, when system is busy, during the wakeup when we could not locate
> idle cpu, we pick the search point instead, whatever how busy it is since
> we count on the balance routine later to help balance the load.

But above you said that dbench usually triggers the wake-affine logic,
but now you say it doesn't and we rely on select_idle_sibling?

Note that the comparison isn't fair, running dbench on an idle system vs
running dbench on a busy system is the first step.

The second is adding the cgroup crap on.

> However, in our cases the load balance could not help on that, since deep=
er
> the group is, less the load effect it means to root group.

But since all actual load is on the same depth, the relative threshold
(imbalance pct) should work the same, the size of the values don't
matter, the relative ratios do.

> By which means even tasks in deep group all gathered on one CPU, the load
> could still balanced from the view of root group, and the tasks lost the
> only chances (balance) to spread when they already on the same CPU...

Sure, but see above.

> Furthermore, for tasks flip frequently like dbench, it'll become far more
> harder for load balance to help, it could even rarely catch them on rq.

And I suspect that is the main problem; so see what it does on a busy
system: !cgroup: nr_cpus busy loops + dbench, because that's your
benchmark for adding cgroups, the cgroup can only shift that behaviour
around.

> So in such cases, the only chance to do balance for these tasks is during
> the wakeup, however it will be expensive...
>=20
> Thus the cheaper way is something just like select_idle_sibling(), the on=
ly
> difference is now we balance tasks inside the group to prevent them from
> gathered.
>=20
> Below patch has solved the problem during the testing, I'd like to do more
> testing on other benchmarks before send out the formal patch, any comments
> are welcomed ;-)

So I think that approach is wrong, select_idle_siblings() works because
we want to keep CPUs from being idle, but if they're not actually idle,
pretending like they are (in a cgroup) is actively wrong and can skew
load pretty bad.

Furthermore, if as I expect, dbench sucks on a busy system, then the
proposed cgroup thing is wrong, as a cgroup isn't supposed to radically
alter behaviour like that.

More so, I suspect that patch will tend to overload cpu0 (and lower cpu
numbers in general -- because its scanning in the same direction for
each cgroup) for other workloads. You can't just go pile more and more
work on cpu0 just because there's nothing running in this particular
cgroup.

So dbench is very sensitive to queueing, and select_idle_siblings()
avoids a lot of queueing on an idle system. I don't think that's
something we should fix with cgroups.


--tzjrJU3+iJ6c5SNx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlvYmAAoJEHZH4aRLwOS67OAP/3WwHxFP6OO7ZMUQqAACkXH7
FrZod1uVITR3ItoHxHf5dnVdRHZhb4ve1KRGskakWxnBeD2SRWGnxxVHFNtSkW8t
F3qJf72uTy6RW4hLo2jali4pS4Z0THb6zvonGSuqdLRS1cE/pvByr+045J3HX7u0
lo0yiZT74WtJUn5GmXKwpPwMHtYtf6kIomDndLzT6N17P9Z86hjMbsfOaxlMRMf2
Q021D9WS452cDHhu0LJme9nrHhL05EcdW7b4YA3d/yEF+ixBnVEYgEZTbtlBBqQ8
dKCwYVElbJpT9bfWt9Fp4VrYIJNgHCsllG0qeN2pxwuFMfXOdwhUWP/gsP5yVKJx
Ah+JKbpe9xVZfi10J9YvAEFjYw2E7MfNQfsblukHlvMfxmcM/rLF+l5EXLk6T+6q
djrWa68j/g9r4LtOu7zmT826d+8pGu1FLd/PLK6DtkXoXn0gGr6Uzz5V6N8B21E1
YMeNAQuJPTN3o9mrX4wqOTNhlU3GGuuHUWyKasrtD94mFiqDdWmBRjHX8BMoYtJS
lxI3SnCWH5oAqgSWMPBkDJ8VTxRN6THH+1wghDA0bqxkp1zkN1S3IBgq9FPcywkm
vDfTc2Y1csfR62Ma78x0gSVn+WymUdRxXeEg3QlPkDtT0UjY6wg4QZfx29rPBhFW
SXiVg9PJ2KCQw0tIHbBQ
=6DzZ
-----END PGP SIGNATURE-----

--tzjrJU3+iJ6c5SNx--
