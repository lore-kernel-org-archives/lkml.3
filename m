Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaHOObu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:31:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaHOObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:31:49 -0400
Date: Fri, 15 Aug 2014 16:31:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Message-ID: <20140815143121.GJ19379@twins.programming.kicks-ass.net>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-5-git-send-email-andi@firstfloor.org>
 <CABPqkBTnZ8SF8TPPMxcY+jPvwQhv+3gki86dnNVgBbAJ_RPdkg@mail.gmail.com>
 <20140814143009.GO5803@tassilo.jf.intel.com>
 <CABPqkBQVwGH7GAVXAXjR1inWnWYeWuVG7Aj-aWAzAksdGq8oeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P98sdcEg3k0nRBOW"
Content-Disposition: inline
In-Reply-To: <CABPqkBQVwGH7GAVXAXjR1inWnWYeWuVG7Aj-aWAzAksdGq8oeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P98sdcEg3k0nRBOW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 07:47:56PM +0200, Stephane Eranian wrote:
> [+perf tool maintainers]
>=20
> On Thu, Aug 14, 2014 at 4:30 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >
> > I understand all your points, but there's no alternative.
> > The only other way would be to disable INST_RETIRED.ALL.
> >
> You cannot do that either. INST_RETIRED:ALL is important.  I assume
> the bug applies whether or not the event is used with a filter.
>=20
> I think we need to ensure that by looking at the perf.data file, one
> can reconstruct the total number of inst_Retired:all occurrences for
> the run. With a fixed period, one would do num_samples * fixed_period.
> I know the Gooda tool does that. It is used to estimate the number of
> events captured vs. the number of events occurring.

OK, I think we can make that work; IFF we guarantee
perf_event_attr::sample_period >=3D 128.

Suppose we start out with sample_period=3D192; then we'll set period_left
to 192, we'll end up with left =3D 128 (we truncate the lower bits). We
get an interrupt, find that period_left =3D 64 (>0 so we return 0 and
don't get an overflow handler), up that to 128. Then we trigger again,
at n=3D256. Then we find period_left =3D -64 (<=3D0 so we return 1 and do g=
et
an overflow). We increment with sample_period so we get left =3D 128. We
fire again, at n=3D384, period_left =3D 0 (<=3D0 so we return 1 and get an
overflow). And on and on.

So while the individual interrupts are 'wrong' we get then with
interval=3D256,128 in exactly the right ratio to average out at 192. And
this works for everything >=3D128.

So the num_samples*fixed_period thing is still entirely correct +- 127,
which is good enough I'd say, as you already have that error anyhow.

So no need to 'fix' the tools, al we need to do is refuse to create
INST_RETIRED:ALL events with sample_period < 128.

--P98sdcEg3k0nRBOW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7hm5AAoJEHZH4aRLwOS6VM0P/iwL0Bqj3Jz9dPD7+uLXHpEC
V7yAbqQGwNFRz+Jj/uEL2dzjD93xhCFeYuWTG9pflxMvfjIStcJOBYX+JDOiVuvE
esp7bzBrDr4M2sCcXaM0voSc03ByWHRIcMY1J5+j1mOt/SvbRNv/CF/TjfDOKISE
rTbGoUQsDoK5gYVYzXv4EL5wN6dAMbZvpiFSBOG3lL2FoKeNt2YFB/W16HsS/1PL
vCKn+F1GaMZfRYgGsWDE8400A2+syCBEAkJm+dYMhOCcXE2ge6FRumDg5IYgVrEf
qR3UEXnLSuSDngiNP/kmnCUwReOY1I8VOKnN9Y8OXCejK00vMPPs/Co/zZxTPBgl
6FXqGs8THD7tlrHd2EoPwteL9b06DCWFT41YNHnZFDA74d1K+Hsb9FiZINJIdFYL
qTCUDQcXhsakas3E6h2X2o6fQcBNFs0IlWByF9hojSK2fIlyAFG0hMpt8cMnbxgh
bycEooqNun/qOQrunbZyx11Lv8//b+Ud9HNNTb+fpTSmVhjgxDEdIE0q7y0+TW9B
hgXa/JWh23xxFm9KPKcwp1TRyElRwS8v1YS6afPmDZtGeNd7KXn4rMogqAORmr/8
qpgPGhGC6W4q1uGEYLNu737tGJwtYi4LSr9Fs3kmeEBwlfsR8FV+sr+yuQXWa3q7
Zq9RiHunT4NJIz+DKbeo
=9qwL
-----END PGP SIGNATURE-----

--P98sdcEg3k0nRBOW--
