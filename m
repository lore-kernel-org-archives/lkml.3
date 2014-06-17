Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaFQMPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:15:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaFQMPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:15:54 -0400
Date: Tue, 17 Jun 2014 14:15:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        registosites@hotmail.com, srivatsa@mit.edu
Subject: Re: [PATCH 11/15] x86: Rewrite cyc2ns to avoid the need to disable
 IRQs
Message-ID: <20140617121535.GY6758@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.238445339@infradead.org>
 <CAOh2x=mgeozUMGYQubQ4GKPEB6k_TkcV3CSTzNLqjKok-gROQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O82bwzp7nMTZS6dV"
Content-Disposition: inline
In-Reply-To: <CAOh2x=mgeozUMGYQubQ4GKPEB6k_TkcV3CSTzNLqjKok-gROQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O82bwzp7nMTZS6dV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 10:43:38PM +0530, Viresh Kumar wrote:
> Cc'ing Mauro/Rafael/Srivatsa..
>=20
> On Thu, Dec 12, 2013 at 7:38 PM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > Use a ring-buffer like multi-version object structure which allows
> > always having a coherent object; we use this to avoid having to
> > disable IRQs while reading sched_clock() and avoids a problem when
> > getting an NMI while changing the cyc2ns data.
> >
> >                         MAINLINE   PRE        POST
> >
> >     sched_clock_stable: 1          1          1
> >     (cold) sched_clock: 329841     331312     257223
> >     (cold) local_clock: 301773     310296     309889
> >     (warm) sched_clock: 38375      38247      25280
> >     (warm) local_clock: 100371     102713     85268
> >     (warm) rdtsc:       27340      27289      24247
> >     sched_clock_stable: 0          0          0
> >     (cold) sched_clock: 382634     372706     301224
> >     (cold) local_clock: 396890     399275     399870
> >     (warm) sched_clock: 38194      38124      25630
> >     (warm) local_clock: 143452     148698     129629
> >     (warm) rdtsc:       27345      27365      24307
> >
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > ---
> >  arch/x86/include/asm/timer.h     |   23 +++
> >  arch/x86/kernel/cpu/perf_event.c |   14 +-
> >  arch/x86/kernel/tsc.c            |  229 ++++++++++++++++++++++++++++++=
++++-----
> >  3 files changed, 236 insertions(+), 30 deletions(-)
>=20
> Hi Peter,
>=20
> We have been following a bug around cpufreq changes in 3.14
> (https://bugzilla.kernel.org/show_bug.cgi?id=3D77201) and our tests
> narrowed it down to this patch after which things aren't working
> as expected.

> Mauro (registosites@hotmail.com) have reported that since 3.14
> after doing hot-unplug/hotplug of CPU1, cpufreq POSTCHANGE notifications
> for every second frequency change hangs his machine ..

Ah, just a freeze?

> Last working tag was: 3.13.8 and it started failing from 3.14 and fails
> for latest 3.15 as well..
>=20
> model name : AMD Turion(tm) 64 X2 Mobile Technology TL-64
> CPUFreq driver: powernow-k8 ..
> CPUs: Only two CPUs, sharing clock line

What's specific to this particular CPU?

> Can you give any pointers, so that he can get it fixed ?

So what you can try is force a cyc2ns read before the write in
set_cyc2ns_scale(). I think its possible that if we do not do the read,
the write will wait for a 'free' slot indefinitely.

--O82bwzp7nMTZS6dV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJToDFnAAoJEHZH4aRLwOS6yOMP+wV56fHEyPtvceMiq5ayZA7k
W2fVK7zigZQ30A+kjgELit+Y7A040qokfhwXKoWQmgmKBJehADupBn8REur2l+YB
51+/eK6jjhh/MLrSjoR0JvMSEhsW4MLYwwfvGJOUN4gbmmYgvJ/fPX9XyKwR8R33
J3GjWmkcfRcGMfNfaIDVkOHsxcz+iNiz5B975O6+E4T8PN/SSGV89x4eSg4BRa8D
P6hxK7epZnkR6YudgvOeNko/ZzJWJm2uH2NlYs9kFTcTBygZ2905ivo88FAGS0sg
cfAZPhNuIGrgTPVz7Ix10xZD/q6mjv8bKKMvVzcSJnlwJE87ywAURI871uPNVzNJ
FNo+NE4iwZGqH4ChYc5B6V1F7sbqMlpS1tCx1RSoMVsRROPVpDk7cjVMjx0DNP08
mDcQhvp3R4oAsFfTwGo9aPaWE5yYW1IS68TCSmsKFiOWLipnEIZkBLB4w1Z/Vqmq
6NbTSrsba7RexnWQgplVFubbXgX/N1xPFBv9iZEWoblQg20QxQXUyt9qAJokKC/5
0Zpv2oHiLtJODU9VHCVC09y2osq37BMJNmOBscTejoY8iZdyU+pXmahc38NTEwD4
Gtq7FhNs1ku0O4ItdpXRLMfIWCdOUlw9r7hbO6mYZkIyf9JutPa1FZ7ZgfMCxw3c
Tez8DXb4hLB2ZPROwdQU
=re7Z
-----END PGP SIGNATURE-----

--O82bwzp7nMTZS6dV--
