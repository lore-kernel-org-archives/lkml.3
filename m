Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaFEObo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:31:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:52695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaFEObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:31:43 -0400
Date: Thu, 5 Jun 2014 16:31:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605143140.GN6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
 <20140605140400.GM3213@twins.programming.kicks-ass.net>
 <CABPqkBQRDpbkF73sWKXiXJOO0Jbeb9tRTWqScbjNdTG50EN3ug@mail.gmail.com>
 <20140605142135.GM6758@twins.programming.kicks-ass.net>
 <CABPqkBQ9_HWN-LbwoxqDY52gHjevA_8fSoYbcv=wp04Rtp2ESg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p1Od3smaOkJqivj4"
Content-Disposition: inline
In-Reply-To: <CABPqkBQ9_HWN-LbwoxqDY52gHjevA_8fSoYbcv=wp04Rtp2ESg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p1Od3smaOkJqivj4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 04:26:38PM +0200, Stephane Eranian wrote:
> On Thu, Jun 5, 2014 at 4:21 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:

> > We could limit each cpu to num_counters/2 exclusive slots. That'll still
> > be painful with some constrained events I imagine, but in general that
> > should 'work' I suppose.
>=20
> That is probably the easiest solution, just modify the dynamic constraint
> mask some more. Have not yet tried it.

Right, see what happens :-)

> The repatriation of the leaked count is not so easy either. Need to IPI
> the other HT. There may be some restrictions as to when we can
> safely do this.

Yes, that'll be 'interesting'. You typically cannot do things like
smp_function_call() from IRQ/NMI context. Which leaves you to
asynchonous IPIs.

I suppose the easiest way is to simply push the count out to the right
event when you reprogram the sibling. And maybe kick it every so often
to force do this just in case the PMU doesn't get reprogrammed a lot.

Still tricky.

--p1Od3smaOkJqivj4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkH9MAAoJEHZH4aRLwOS6PK0P/2OgBvQLeKJpMcOu0ms4qN+l
25EmWgQi8nyzwXZ3r+FGW32dCrn5ZW2I3IYl9FRAAdDigxDE2vPwHOfO3nhF3r99
3S3cd28AAzMkkqgqHen00TNawkrGzHaMIFORbIBLRZIX6U0LTBM2DoI7aqDneoEd
jE7aXdkI1mybf5zynYLIxgpNJWYCT9rKghhkoREzU1mU+fo/1YuaD/ocUKAeZw0N
0k+ELhSraMkIKerWD849LDg8Mgemz3YhrJMGxJjqIwsUc5Kwjd3tKoSKjuvz/4Ku
BfViUlX9LUUAxjIFZm/25XS59WxVjowzHGc8omtaDCrK7+wGB68aDN0xtuOmH1mN
Ps1dh1hBeUWjaA20PxCAqAazK4wlsI/dkccdopwda96SabaOk5MGOtzzXXo07j8v
S8dBspRDicP6c2Oa+yAaCiMeRiuyWhYXTI4iDf5HZeJhhrv1/PFziehmwYmAL5t4
gcdhF7JwJDZHOvnulczUJkz/kqrK/dqMgXrKQeNDnoRr2afYV4GTRDn6ez3H6lGv
qgX5cykRB8fQ/73m6p2whFfqZO5dupeEkrukEqrU6JqnDbeqmpBtJhCgu7kma6tp
e+ij13hv/y1F7XKgzlkadlpCdawj/aIpQBPwE73jHdUmL9HLeM8jFRLNv0cesT93
dH3UUKlqQEauENoSKj3I
=Kxvq
-----END PGP SIGNATURE-----

--p1Od3smaOkJqivj4--
