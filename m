Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaFJKQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:16:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:48364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaFJKQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:16:32 -0400
Date: Tue, 10 Jun 2014 12:16:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140610101622.GB6758@twins.programming.kicks-ass.net>
References: <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140607232628.GC22261@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ERHfpFOxJvIsVBXy"
Content-Disposition: inline
In-Reply-To: <20140607232628.GC22261@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ERHfpFOxJvIsVBXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 08, 2014 at 07:26:29AM +0800, Yuyang Du wrote:
> Ok. I think we understand each other. But one more thing, I said P ~ V^3,
> because P ~ V^2*f and f ~ V, so P ~ V^3. Maybe some frequencies share the=
 same
> voltage, but you can still safely assume V changes with f in general, and=
 it
> will be more and more so, since we do need finer control over power consu=
mption.

I didn't know the frequency part was proportionate to another voltage
term, ok, then the cubic term makes sense.

> > Sure, but realize that we must fully understand this governor and
> > integrate it in the scheduler if we're to attain the goal of IPC/watt
> > optimized scheduling behaviour.
> >=20
>=20
> Attain the goal of IPC/watt optimized?
>=20
> I don't see how it can be done like this. As I said, what is unknown for
> prediction is perf scaling *and* changing workload. So the challenge for =
pstate
> control is in both. But I see more chanllenge in the changing workload th=
an
> in the performance scaling or the resulting IPC impact (if workload is
> fixed).

But for the scheduler the workload change isn't that big a problem; we
know the history of each task, we know when tasks wake up and when we
move them around. Therefore we can fairly accurately predict this.

And given a simple P state model (like ARM) where the CPU simply does
what you tell it to, that all works out. We can change P-state at task
wakeup/sleep/migration and compute the most efficient P-state, and task
distribution, for the new task-set.

> Currently, all freq governors take CPU utilization (load%) as the indicat=
or
> (target), which can server both: workload and perf scaling.

So the current cpufreq stuff is terminally broken in too many ways; its
sampling, so it misses a lot of changes, its strictly cpu local, so it
completely misses SMP information (like the migrations etc..)

If we move a 50% task from CPU1 to CPU0, a sampling thing takes time to
adjust on both CPUs, whereas if its scheduler driven, we can instantly
adjust and be done, because we _know_ what we moved.

Now some of that is due to hysterical raisins, and some of that due to
broken hardware (hardware that needs to schedule in order to change its
state because its behind some broken bus or other). But we should
basically kill off cpufreq for anything recent and sane.

> As for IPC/watt optimized, I don't see how it can be practical. Too micro=
 to
> be used for the general well-being?

What other target would you optimize for? The purpose here is to build
an energy aware scheduler, one that schedules tasks so that the total
amount of energy, for the given amount of work, is minimal.

So we can't measure in Watt, since if we forced the CPU into the lowest
P-state (or even C-state for that matter) work would simply not
complete. So we need a complete energy term.

Now. IPC is instructions/cycle, Watt is Joule/second, so IPC/Watt is

instructions   second
------------ * ------ ~ instructions / joule
  cycle        joule

Seeing how both cycles and seconds are time units.

So for any given amount of instructions, the work needs to be done, we
want the minimal amount of energy consumed, and IPC/Watt is the natural
metric to measure this over an entire workload.

--ERHfpFOxJvIsVBXy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTltr1AAoJEHZH4aRLwOS6QXsP/1tR4/Z8cYEL8qxXaKceV8gr
W2yYs++HJkRWoxxJrUcA2MTG3p7YxbIq6UkITHET1WszPynk8ojbm3AMLIzA31aa
Y/D7blKcaHydU3NPoJNrLPLi6bHybtiaxxS3Q+1VctxATM8bBFhMVK0zB0dbRU03
eBXcP7uWgdHV/Tl1CSf0YiwdEjnu7wgI02D9Q63MeTYvhLObWmCyzw67ZuEGz2tM
N018zm1sRJdLXSfMdbZsTnlTzsbnGDupuWRyeB7U4nUmK1+lvXXK1ozkyoNjIjbM
LNiDppJ5j9E0jvgS/cLPYfxen96o+QCiNnOX4ChtuhcLv/+A85ANeCQqkxb6FouA
jSLNTYCMGw8/qXA3EMYbWgfSZ2TuzA5PGGkgOq5wARduL3BTr10Hm1DgggpUGfRQ
jl3uZB4EQcj/RAm4QHdIaHx9BaagX5hV2aV0hEV4UEjgOp/XbuzV7UmwoFdzU2/R
yYolSLwZc20V3kiGVh7lkNxz6LE8H1YlZU6CRRTvYJm1zsTRd14mpdC8UIz05Bpg
b+GGO2DWDLbVQZqQ89hbUichCINp/r6DREqq371Sys/WFqKJygugCsYMVFdNCwV8
pN2RzNl+qCJ4I2kQopPTR2lahudVH2MDr0+lWQzfgus0Bv4uwK8eyx6LmRHDmh0/
+fC5b3if6W1UAn8jqvTp
=qnpQ
-----END PGP SIGNATURE-----

--ERHfpFOxJvIsVBXy--
