Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaFDKRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:17:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaFDKRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:17:40 -0400
Date: Wed, 4 Jun 2014 12:17:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
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
Message-ID: <20140604101724.GD11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
 <CAKfTPtBCG1Jq2b+fyoGuA=7yG_yUbsmaD+j-ZXXsPNGp5giKpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aavXWXnpRwqpjJp2"
Content-Disposition: inline
In-Reply-To: <CAKfTPtBCG1Jq2b+fyoGuA=7yG_yUbsmaD+j-ZXXsPNGp5giKpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aavXWXnpRwqpjJp2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 11:32:10AM +0200, Vincent Guittot wrote:
> On 4 June 2014 10:08, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Jun 04, 2014 at 09:47:26AM +0200, Vincent Guittot wrote:
> >> On 3 June 2014 17:50, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
> >> >> Since we may do periodic load-balance every 10 ms or so, we will pe=
rform
> >> >> a number of load-balances where runnable_avg_sum will mostly be
> >> >> reflecting the state of the world before a change (new task queued =
or
> >> >> moved a task to a different cpu). If you had have two tasks continu=
ously
> >> >> on one cpu and your other cpu is idle, and you move one of the task=
s to
> >> >> the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
> >> >> first cpu while it starts from 0 on the other one. 10 ms later it w=
ill
> >> >> have increased a bit, 32 ms later it will be 47742/2, and 345 ms la=
ter
> >> >> it reaches 47742. In the mean time the cpu doesn't appear fully uti=
lized
> >> >> and we might decide to put more tasks on it because we don't know if
> >> >> runnable_avg_sum represents a partially utilized cpu (for example a=
 50%
> >> >> task) or if it will continue to rise and eventually get to 47742.
> >> >
> >> > Ah, no, since we track per task, and update the per-cpu ones when we
> >> > migrate tasks, the per-cpu values should be instantly updated.
> >> >
> >> > If we were to increase per task storage, we might as well also track
> >> > running_avg not only runnable_avg.
> >>
> >> I agree that the removed running_avg should give more useful
> >> information about the the load of a CPU.
> >>
> >> The main issue with running_avg is that it's disturbed by other tasks
> >> (as point out previously). As a typical example,  if we have 2 tasks
> >> with a load of 25% on 1 CPU, the unweighted runnable_load_avg will be
> >> in the range of [100% - 50%] depending of the parallelism of the
> >> runtime of the tasks whereas the reality is 50% and the use of
> >> running_avg will return this value
> >
> > I'm not sure I see how 100% is possible, but yes I agree that runnable
> > can indeed be inflated due to this queueing effect.
=20
Let me explain the 75%, take any one of the above scenarios. Lets call
the two tasks A and B, and let for a moment assume A always wins and
runs first, and then B.

So A will be runnable for 25%, B otoh will be runnable the entire time A
is actually running plus its own running time, giving 50%. Together that
makes 75%.

If you release the assumption that A runs first, but instead assume they
equally win the first execution, you get them averaging at 37.5% each,
which combined will still give 75%.

> In fact, it can be even worse than that because i forgot to take into
> account the geometric series effect which implies that it depends of
> the runtime (idletime) of the task
>=20
> Take 3 examples:
>=20
> 2 tasks that need to run 10ms  simultaneously each 40ms. If they share
> the same CPU, they will be on the runqueue 20ms (in fact a bit less
> for one of them), Their load (runnable_avg_sum/runnable_avg_period)
> will be 33% each so the unweighted runnable_load_avg of the CPU will
> be 66%
>=20
> 2 tasks that need to run 25ms simultaneously each 100ms. If they share
> the same CPU, they will be on the runqueue 50ms (in fact a bit less
> for one of them), Their load (runnable_avg_sum/runnable_avg_period)
> will be 74% each so the unweighted runnable_load_avg of the CPU will
> be 148%
>=20
> 2 tasks that need to run 50ms  simultaneously each 200ms. If they
> share the same CPU, they will be on the runqueue 100ms (in fact a bit
> less for one of them), Their load
> (runnable_avg_sum/runnable_avg_period) will be 89% each so the
> unweighted runnable_load_avg of the CPU will be 180%

And this is because the running time is 'large' compared to the decay
and we get hit by the weight of the recent state? Yes, I can see that,
the avg will fluctuate due to the nature of this thing.

--aavXWXnpRwqpjJp2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjvI0AAoJEHZH4aRLwOS6fA8P/24/9GSUkZiDMVvo2heUhmMb
gJHkwMggCk4RFLjkcxOEqLf4CEHQxVG5PC1Gw6U9TbtfNJoSiBkaVke6gg1KtBl+
kBTTj4aMvnLzZpyiiJlMY92CUV3J92VOPlhZC3FKrIT12P+N/HCVqpDNPh9qjR8i
2xc7J6RiUr/Emd3xpQSi1BAXWXwufP+M8eGoRRz3pmiAlBZSPB05mdVQqn1F6ECA
H0QI6lb/RJu3LkSQasOsCYdt9qK7bI+NXkgZ0ULuE3Rvn2dZB3ZaUMRj/J8Bztie
wRpKdfyV6nCXF3P3FrHQNQNYyxyUgjlD8PhoRsjS5n1YW9KphXngv6cCByu/cBSg
TSht8QWMNCXMT6PzWlUL8zw+E1nqIXaqD+U/wTcOQwO3dizvpZRBmvB3DtATolz8
ZJikoePuT1bXOta4y9hXDUQhtwYmnZ/RML9fJU3PLAu8mwLh6s9Df62PjNLzYF7k
Fzk4ySbjpKxjl8YZYiKSVx8G4znwOIREA89xKbDZUCZ1JhBlia6gdUI7WkGXOP4v
zM08/0Jcm7vW9fhQ+J+WGxlFbQGEfpEQkqgWIuoRY2OtpsnKhoAaVELFng6TPbxz
5rNIGY5CenJNpBgRskLnrjbfopOTbQF4CVbcikhvdmjEkO6FXSEQwpWhsvsdYZvg
QwY9HjvOKTc2Y4gA7HUU
=93qa
-----END PGP SIGNATURE-----

--aavXWXnpRwqpjJp2--
