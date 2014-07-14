Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaGNNWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:22:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:52036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaGNNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:21:04 -0400
Date: Mon, 14 Jul 2014 15:20:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140714132052.GY9918@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop>
 <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711151304.GD3935@laptop>
 <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
 <20140711201238.GY20603@laptop.programming.kicks-ass.net>
 <20140714125529.GN26542@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9weITk6rEWSannbW"
Content-Disposition: inline
In-Reply-To: <20140714125529.GN26542@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9weITk6rEWSannbW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 01:55:29PM +0100, Morten Rasmussen wrote:
> On Fri, Jul 11, 2014 at 09:12:38PM +0100, Peter Zijlstra wrote:
> > On Fri, Jul 11, 2014 at 07:39:29PM +0200, Vincent Guittot wrote:
> > > In my mind, arch_scale_cpu_freq was intend to scale the capacity of
> > > the CPU according to the current dvfs operating point.
> > > As it's no more use anywhere now that we have arch_scale_cpu, we could
> > > probably remove it .. and see when it will become used.
> >=20
> > I probably should have written comments when I wrote that code, but it
> > was meant to be used only where, as described above, we limit things.
> > Ondemand and such, which will temporarily decrease freq, will ramp it up
> > again at demand, and therefore lowering the capacity will skew things.
> >=20
> > You'll put less load on because its run slower, and then you'll run it
> > slower because there's less load on -> cyclic FAIL.
>=20
> Agreed. We can't use a frequency scaled compute capacity for all
> load-balancing decisions. However, IMHO, it would be useful to have know
> the current compute capacity in addition to the max compute capacity
> when considering energy costs. So we would have something like:
>=20
> * capacity_max: cpu capacity at highest frequency.
>=20
> * capacity_cur: cpu capacity at current frequency.
>=20
> * capacity_avail: cpu capacity currently available. Basically
>   capacity_cur taking rt, deadline, and irq accounting into account.
>=20
> capacity_max should probably include rt, deadline, and irq accounting as
> well. Or we need both?

I'm struggling to fully grasp your intent. We need DVFS like accounting
for sure, and that means a current freq hook, but I'm not entirely sure
how that relates to capacity.

> Based on your description arch_scale_freq_capacity() can't be abused to
> implement capacity_cur (and capacity_avail) unless it is repurposed.
> Nobody seems to implement it. Otherwise we would need something similar
> to update capacity_cur (and capacity_avail).

Yeah, I never got around to doing so. I started doing a APERF/MPERF SMT
capacity thing for x86 but never finished that. The naive implementation
suffered the same FAIL loop as above because APERF stops on idle. So
when idle your capacity drops to nothing, leading to no new work,
leading to more idle etc.

I never got around to fixing that -- adding an idle filter, and ever
since things have somewhat bitrotted.

> As a side note, we can potentially get into a similar fail cycle already
> due to the lack of scale invariance in the entity load tracking.

Yah, I think that got mentioned a long while ago.

> > > > In that same discussion ISTR a suggestion about adding avg_running =
time,
> > > > as opposed to the current avg_runnable. The sum of avg_running shou=
ld be
> > > > much more accurate, and still react correctly to migrations.
> > >=20
> > > I haven't look in details but I agree that avg_running would be much
> > > more accurate than avg_runnable and should probably fit the
> > > requirement. Does it means that we could re-add the avg_running (or
> > > something similar) that has disappeared during the review of load avg
> > > tracking patchset ?
> >=20
> > Sure, I think we killed it there because there wasn't an actual use for
> > it and I'm always in favour of stripping everything to their bare bones,
> > esp big and complex things.
> >=20
> > And then later, add things back once we have need for it.
>=20
> I think it is a useful addition to the set of utilization metrics. I
> don't think it is universally more accurate than runnable_avg. Actually
> quite the opposite when the cpu is overloaded. But for partially loaded
> cpus it is very useful if you don't want to factor in waiting time on
> the rq.

Well, different things different names. Utilization as per literature is
simply the fraction of CPU time actually used. In that sense running_avg
is about right for that. Our current runnable_avg is entirely different
(as I think we all agree by now).

But yes, for application the tipping point is u =3D=3D 1, up until that
point pure utilization makes sense, after that our runnable_avg makes
more sense.



--9weITk6rEWSannbW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw9kzAAoJEHZH4aRLwOS61woQAIHrw8zz+0TWb4GkqynnMQIN
fP7mshYpA5WojbTBAFUZOgc138Pe+VnLn76UilER/8fex0t/Ik4ne7xhqBRq2th0
er3ebcztx+sHmFAAuTyjAZOpcqWeGgyuNk9pxDWE39DhrreezrmqgPqrkpIGLwSg
jzOEh8s+XmI1HgKvGxdSMPlEOPcFjRZKpnK6vpNF/+zlvHEAGZiATDNKbKH06E6O
zvm98WnJWl2tpEjyk5NEXQCZylGWKq6c2pPjGjlwabQBKG1EOz5AsjWtS5sFIk31
c51kQY+Osc2nySCN2/9+N+pIwGMeckHq+XJmfiaK1cqera6RMxXQiG+w7JWR6K7v
Rwf8ZccKqFE5rQAgtpI5CsokctD/kElKx41c7NMIf766syRO/pCidOAV9uZqrEsN
6r5PfRZzNs/hR8wYB//AY3YPIUM51bM3HTcKdaGP/FA1EGL60a4MyZpqDMck44+V
luGj8yTU2CsAlEqHSk30T2Td/C01rkyGoUHN5UBcY62Jz5Q9jXwgafwNXAZTJQFy
v/mNNj0xMpNa4UX6+erR2FikZrniq2aGAO4jsOkfZkJcg5/pREDUFFXJKfS4/HqQ
/TyTEk/m6mquqQwhJoHAEHuv9gbsxjZ9wciMmAU9fFrIAcyXybf/5qo9gD4oweao
ylCX37meDXJuJvq4ZZRu
=Dwrf
-----END PGP SIGNATURE-----

--9weITk6rEWSannbW--
