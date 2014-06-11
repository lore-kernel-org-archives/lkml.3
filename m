Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaFKIYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:24:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaFKIYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:24:44 -0400
Date: Wed, 11 Jun 2014 10:24:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140611082433.GH3213@twins.programming.kicks-ass.net>
References: <20140515090638.GI30445@twins.programming.kicks-ass.net>
 <53748A5D.6070605@linux.vnet.ibm.com>
 <20140515115751.GK30445@twins.programming.kicks-ass.net>
 <5375768F.1010000@linux.vnet.ibm.com>
 <1400208690.7133.11.camel@marge.simpson.net>
 <53759303.40409@linux.vnet.ibm.com>
 <20140516075421.GL11096@twins.programming.kicks-ass.net>
 <5396C82C.6060101@linux.vnet.ibm.com>
 <20140610121222.GE6758@twins.programming.kicks-ass.net>
 <5397F396.2060801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PK5kSfjks5jzTD3m"
Content-Disposition: inline
In-Reply-To: <5397F396.2060801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PK5kSfjks5jzTD3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 02:13:42PM +0800, Michael wang wrote:
> Hi, Peter
>=20
> Thanks for the reply :)
>=20
> On 06/10/2014 08:12 PM, Peter Zijlstra wrote:
> [snip]
> >> Wake-affine for sure pull tasks together for workload like dbench, wha=
t make
> >> it difference when put dbench into a group one level deeper is the
> >> load-balance, which happened less.
> >=20
> > We load-balance less (frequently) or we migrate less tasks due to
> > load-balancing ?
>=20
> IMHO, when we put tasks one group deeper, in other word the totally
> weight of these tasks is 1024 (prev is 3072), the load become more
> balancing in root, which make bl-routine consider the system is
> balanced, which make we migrate less in lb-routine.

But how? The absolute value (1024 vs 3072) is of no effect to the
imbalance, the imbalance is computed from relative differences between
cpus.

> Our comparison is based on the same busy-system, all the two cases have
> the same workload running, the only difference is that we put the same
> workload (dbench + stress) one group deeper, it's like:
>=20
> Good case:
> 		root
> 		l1-A	l1-B	l1-C
> 		dbench	stress	stress
>=20
> 	results:
> 		dbench got around 300%
> 		each stress got around 450%
>=20
> Bad case:
> 		root
> 		l1
> 		l2-A	l2-B	l2-C
> 		dbench	stress	stress
>=20
> 	results:
> 		dbench got around 100% (throughout dropped too)
> 		each stress got around 550%
>=20
> Although the l1-group gain the same resources (1200%), it doesn't assign
> to l2-ABC correctly like the root-group did.

But in this case select_idle_sibling() should function identially, so
that cannot be the problem.

> > The second is adding the cgroup crap on.
> >=20
> >> However, in our cases the load balance could not help on that, since d=
eeper
> >> the group is, less the load effect it means to root group.
> >=20
> > But since all actual load is on the same depth, the relative threshold
> > (imbalance pct) should work the same, the size of the values don't
> > matter, the relative ratios do.
>=20
> Exactly, however, when group is deep, the chance of it to make root
> imbalance reduced, in good case, gathered on cpu means 1024 load, while
> in bad case it dropped to 1024/3 ideally, that make it harder to trigger
> imbalance and gain help from the routine, please note that although
> dbench and stress are the only workload in system, there are still other
> tasks serve for the system need to be wakeup (some very actively since
> the dbench...), compared to them, deep group load means nothing...

What tasks are these? And is it their interference that disturbs
load-balancing?

> >> By which means even tasks in deep group all gathered on one CPU, the l=
oad
> >> could still balanced from the view of root group, and the tasks lost t=
he
> >> only chances (balance) to spread when they already on the same CPU...
> >=20
> > Sure, but see above.
>=20
> The lb-routine could not provide enough help for deep group, since the
> imbalance happened inside the group could not cause imbalance in root,
> ideally each l2-task will gain 1024/18 ~=3D 56 root-load, which could be
> easily ignored, but inside the l2-group, the gathered case could already
> means imbalance like (1024 * 5) : 1024.

your explanation is not making sense, we have 3 cgroups, so the total
root weight is at least 3072, with 18 tasks you would get 3072/18 ~ 170.

And again, the absolute value doesn't matter, with (istr) 12 cpus the
avg cpu load would be 3072/12 ~ 256, and 170 is significant on that
scale.

Same with l2, total weight of 1024, giving a per task weight of ~56 and
a per-cpu weight of ~85, which is again significant.

Also, you said load-balance doesn't usually participate much because
dbench is too fast, so please make up your mind, does it or doesn't it
matter?

> > So I think that approach is wrong, select_idle_siblings() works because
> > we want to keep CPUs from being idle, but if they're not actually idle,
> > pretending like they are (in a cgroup) is actively wrong and can skew
> > load pretty bad.
>=20
> We only choose the timing when no idle cpu located, and flips is
> somewhat high, also the group is deep.

-enotmakingsense

> In such cases, select_idle_siblings() doesn't works anyway, it return
> the target even it is very busy, we just check twice to prevent it from
> making some obviously bad decision ;-)

-emakinglesssense

> > Furthermore, if as I expect, dbench sucks on a busy system, then the
> > proposed cgroup thing is wrong, as a cgroup isn't supposed to radically
> > alter behaviour like that.
>=20
> That's true and that's why we currently still need to shut down the
> GENTLE_FAIR_SLEEPERS feature, but that's another problem we need to
> solve later...

more confusion..

> What we currently expect is that the cgroup assign the resource
> according to the share, it works well in l1-groups, so we expect it to
> work the same well in l2-groups...

Sure, but explain why it isn't? So far you're just saying words that
don't compute.

--PK5kSfjks5jzTD3m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmBI8AAoJEHZH4aRLwOS6+X8P/28yxwNaoxJIEB3EuxahdvQR
GD7v31CT3rxznpokkOQTFHcJQOCMOAqYtMcVSPe6D3iramqEcBrKyTH4kXqiR8rp
7EUZTARyJYtp8I/rcVIs5ofu/m7vw4U94uw7ETDKfjedwughLDdM7Vmc1CQPrae0
xOkAGZol6B8G1MD7ryy1dACJh1/E3C0L35V/5IrmDqsUtiNolR/1KZ/AdlQld2LA
hTcVrtQ6TfAleO/TfsB79i+58AeEDcOgLIt+rX3x++6+5XeFOdo8LGblJ9Vvm4Yu
GuEsF5zP/dqrLNRcAaizOibQLu24/UazTc2aYUEsjUQQbwLs987s0DpizZY8HXT9
99xcIc6gcJTFhE2bs2kvINtm7gyckEoZWHjF+KzWXVrSzktZGea6B1Jhbl5OSD0p
Q9Uuu/X1J4sXXtyWdWPIacOZcK6IsWB+3+qUkYAaHw0MLe3aAa52yTIwrTQ261Le
BRjbV+9sK3flbN5KawqLtTjLoVPTtVxZZ1+0sSF+nxNZSjwcYxa0lS1QHm2VbZ26
00TITed3mDKpOmr7vJJzMCAd2K3lua0D9GkaAc3j3L6oAYH9QqVpb+EAW1gvL+zR
AL3LbXEGs1TyKyirMEWNv8iKIt348jSa9TURhUBKOTteAEH1pN2wJn24gbjdCMc+
B7A6PQ6o2kYY0+lp/MaI
=1Rwg
-----END PGP SIGNATURE-----

--PK5kSfjks5jzTD3m--
