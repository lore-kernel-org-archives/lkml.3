Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbaFCP74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:59:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFCP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:59:53 -0400
Date: Tue, 3 Jun 2014 17:59:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603155939.GA30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <CAKfTPtCd8Mm+bvO3f1ybRC=gV-vQ=_5SxcUnOiuZ0XTf0JN=mA@mail.gmail.com>
 <20140603120354.GC29593@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lKJrrayK576VIMG2"
Content-Disposition: inline
In-Reply-To: <20140603120354.GC29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lKJrrayK576VIMG2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 01:03:54PM +0100, Morten Rasmussen wrote:
> On Wed, May 28, 2014 at 05:39:10PM +0100, Vincent Guittot wrote:
> > On 28 May 2014 17:47, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > > On Wed, May 28, 2014 at 02:15:03PM +0100, Vincent Guittot wrote:
> > >> On 28 May 2014 14:10, Morten Rasmussen <morten.rasmussen@arm.com> wr=
ote:
> > >> > On Fri, May 23, 2014 at 04:53:02PM +0100, Vincent Guittot wrote:

> > > I agree that the task runnable_avg_sum is always affected by the
> > > circumstances on the cpu where it is running, and that it takes this
> > > history with it. However, I think cfs.runnable_load_avg leads to less
> > > problems than using the rq runnable_avg_sum. It would work nicely for
> > > the two tasks on two cpus example I mentioned earlier. We don't need =
add
> >=20
> > i would say that nr_running is an even better metrics for such
> > situation as the load doesn't give any additional information.
>=20
> I fail to understand how nr_running can be used. nr_running doesn't tell
> you anything about the utilization of the cpu, just the number tasks
> that happen to be runnable at a point in time on a specific cpu. It
> might be two small tasks that just happened to be running while you read
> nr_running.

Agreed, I'm not at all seeing how nr_running is useful here.

> An unweighted version of cfs.runnable_load_avg gives you a metric that
> captures cpu utilization to some extend, but not the number of tasks.
> And it reflects task migrations immediately unlike the rq
> runnable_avg_sum.

So runnable_avg would be equal to the utilization as long as
there's idle time, as soon as we're over-loaded the metric shows how
much extra cpu is required.

That is, runnable_avg - running_avg >=3D 0 and the amount is the
exact amount of extra cpu required to make all tasks run but not have
idle time.

> Agreed, but I think it is quite important to discuss what we understand
> by cpu utilization. It seems to be different depending on what you want
> to use it for.

I understand utilization to be however much cpu is actually used, so I
would, per the existing naming, call running_avg to be the avg
utilization of a task/group/cpu whatever.

> We have done experiments internally with rq runnable_avg_sum for
> load-balancing decisions in the past and found it unsuitable due to its
> slow response to task migrations. That is why I brought it up here.

So I'm not entirely seeing that from the code (I've not traced this),
afaict we actually update the per-cpu values on migration based on the
task values.

old_rq->sum -=3D p->val;
new_rq->sum +=3D p->val;

like,.. except of course totally obscured.


--lKJrrayK576VIMG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjfDrAAoJEHZH4aRLwOS6cnkP/3Yml+RyrNScCF597fOYaCLm
ds9toi8rkVymLmdO+zIkKP1saoohF6oakXCNH/mh5Ib46SFKlz50qsepoT5sAFgy
/LjqZ3G3SCAKFEP1BahDJ5MyOVQ+DXBrjQ5ZR83Pwnx3n9xTwnGFkLprFZ4pyDHB
ZWZI1DPYY1gZwCvFQwcW4P6mny6fHGobQKg04LkETy6K35eujkEEAZbvKroIyMRd
CohZnI/Rv0lOc/4iBekHbBYbBSPNGDhQOE9TSS4GcvdG3M8ijiAnq99NQN6P3Bw/
SDmZO+7fvhTa7916D8bAQLdHPQgUiqM8vou0h1UDtpuyoXP7/IEqinZm5DC0AvC1
xvQBaTz1QKx9Zngb1PDdEAu4hjKz6AxQ+px/t0H46gQrtDQt2x4MFSLJ5USdfB4+
v+YeTMf6ek1iY9t13clN61Z2wIsTxphds3/h9Z47YNYsCwGP+mNzyVDB6vYVdo7o
7Qj2k+n3hz7lCyBrmfm2KOBJkexjf1rvomg7e/bpVBUXwqcEoGFFzcW8wvuEfjsh
6TPcDJgwMUneWsJFu6gQpUwfh5635QuOrFWag18NwmF8dyNsQLQzC9A6ume1G1NL
IFFoE1zauMnfM5cmpq/iYF2G0WSQZIZdRu3Q+QFT1xLhh80M+YhvbqFV+dxsk1GX
2dcffKAyPhBezK4ciKbR
=UuMO
-----END PGP SIGNATURE-----

--lKJrrayK576VIMG2--
