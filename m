Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaEPHo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:44:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaEPHoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:44:54 -0400
Date: Fri, 16 May 2014 09:44:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perfevents: irq loop stuck!
Message-ID: <20140516074445.GJ11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu>
 <20140515182136.GI11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405160017120.1351@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tTvAEuyWWbMF5UF4"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405160017120.1351@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tTvAEuyWWbMF5UF4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 12:25:28AM -0400, Vince Weaver wrote:
> anyway I'm not sure if it's worth tracking this more if it's possible to=
=20
> mostly fix the case by fixing the sample_period bounds.

Right, so lets start with that, if it triggers again, we'll have another
look.

FWIW I ran with the below patch over night, and while trinity completely
shat itself going OOM -- so I'm not sure how long it ran, it didn't
trigger the stuck interrupt loop.

Will do more runs now that I'm there to hold its hand once more.

---
Subject: perf: Limit perf_event_attr::sample_period to 63 bits
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Thu May 15 20:23:48 CEST 2014

Vince reported that using a large sample_period (one with bit 63 set)
results in wreckage since while the sample_period is fundamentally
unsigned (negative periods don't make sense) the way we implement
things very much rely on signed logic.

So limit sample_period to 63 bits to avoid tripping over this.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-p25fhunibl4y3qi0zuqmyf4b@git.kernel.org
---
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7058,6 +7058,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (attr.freq) {
 		if (attr.sample_freq > sysctl_perf_event_sample_rate)
 			return -EINVAL;
+	} else {
+		if (attr.sample_period & (1ULL << 63))
+			return -EINVAL;
 	}
=20
 	/*

--tTvAEuyWWbMF5UF4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdcHnAAoJEHZH4aRLwOS6waYP/jlLyQY9NsPvwpg5FSnGnPbA
T7/rvd/zQ/aAhK/RLCDXwcWki2n3DSZPGab+1wnXChc+IQccXf29QxLOis31j+lo
2HT9lDEQ+pO/Yencm+cDbFOIMKRRU+QrqbVcYY2Sj5nAVC6uqowpfwWmc5ezh841
TUxa4+iqYCnN5tKjgnz6cqSfJ/3voA3Id2jnYKiPoje/e9hNe/atq9TWYQCfxOFA
LbWsmymN3Yj18Us3dXboBocAC6te2PVeC0L3EbevWcula6gAffDWYvfkr8J6B3uN
X5zQZ1/GpGyjKEvCO2ktGh7E6bf94GYl6o9vxdnMRbWZD3mzHXLB09aBTNWIR1eR
Kt3NI/nzKyEWfKO2tb23S8Z9YBGEjNZg+Cbgj7bTC7+M/5vTAd9v23QLv5DwdIjv
qIXjwgjAlcKUMAvWGH6SKsl6yJszzgO5s7YxViJ7TcxgwoXRX/6Xr0owb9y9bfW2
cUmNQ+7fZgx8EYvNqhJRz0h2QWRYTBybkIsHCli8mr9HPaWf2cbI5hjwr3wicvMc
guFw9UZshRBCoAG3jr3Nz2343hg7RjaBTtsy7zuHey/lAxXizms0dTTZlVrziWwO
9II1HdKLGMgcq+pAOADS8TFCTS/P2F/jzD3S0O9gcxQsng4FHRRDqoLaAQSvvc5p
ljF4iYsCbOyn1bSZvelV
=ypUT
-----END PGP SIGNATURE-----

--tTvAEuyWWbMF5UF4--
