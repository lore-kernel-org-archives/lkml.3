Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaEVPfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:35:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:46034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEVPfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:35:10 -0400
Date: Thu, 22 May 2014 17:35:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Segall <bsegall@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Roman Gushchin <klamm@yandex-team.ru>,
        pjt@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix unlocked reads of some cfs_b->quota/period
Message-ID: <20140522153504.GY30445@twins.programming.kicks-ass.net>
References: <20140519224945.20303.93530.stgit@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+aOZGdcGYL8FotQd"
Content-Disposition: inline
In-Reply-To: <20140519224945.20303.93530.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+aOZGdcGYL8FotQd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 03:49:45PM -0700, Ben Segall wrote:
> @@ -3783,7 +3787,7 @@ static void __maybe_unused unthrottle_offline_cfs_r=
qs(struct rq *rq)
>  		 * clock_task is not advancing so we just need to make sure
>  		 * there's some valid quota amount
>  		 */
> -		cfs_rq->runtime_remaining =3D cfs_b->quota;
> +		cfs_rq->runtime_remaining =3D 1;
>  		if (cfs_rq_throttled(cfs_rq))
>  			unthrottle_cfs_rq(cfs_rq);
>  	}
>=20

That ^, causes:

kernel/sched/fair.c: In function =E2=80=98unthrottle_offline_cfs_rqs=E2=80=
=99:
kernel/sched/fair.c:3782:25: warning: unused variable =E2=80=98cfs_b=E2=80=
=99 [-Wunused-variable]

Stuck this on:

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3779,8 +3779,6 @@ static void __maybe_unused unthrottle_of
 	struct cfs_rq *cfs_rq;
=20
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		struct cfs_bandwidth *cfs_b =3D tg_cfs_bandwidth(cfs_rq->tg);
-
 		if (!cfs_rq->runtime_enabled)
 			continue;
=20

--+aOZGdcGYL8FotQd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfhkoAAoJEHZH4aRLwOS6ZaAP/AmeXKLl41uwgnmNO0J1E9QU
cMFddjEfYw+4tanJ/IyU0oO+wKtbP3cFRgXZ3sfgqwSWbpRGKiXJIwp/2nu9bVsY
HUrCIT7bgmfNo20nwfYUoKC4dtoSzBgyyc/Nm/oHQzSwOXiKkC31F0+H4+i15lXw
RIuvdE/rNTBYl2O1HXwNpKbF0WYsB9sKFwId8brTLV+1A9OJMDSDkHBxZzNQ170W
8nQaDVmzwj1GhZP9xfR/F2WlBk6AS0oEAitXa4bCN777M9eKptKm5pPQvg8KSs4V
zvkERxpCjkh4/fDhfpy1styY1HS+kp58Hn8jEUkAV9EUn2H+6tu0Ki3Lr8hRLs3S
fNMP0Wvrw+zwPmy32Bg8vHC1VdFFGV2z340+ivm+cnD/qR59Ehib9t/PqAobQ6dE
OYwoXZ2yJAR4zxnPbuhbJytF2aaYLHtvJhWD+gBBPFI5BCYnaO9uwMLMZmkJSIQC
oJLG6PCN1YLjVwzXUxuQKxGs/cuXmXy/6S6k6QNsHNpPwOEfsNFj7ZeXuMBVZ7LY
cdpsEo3I/wGf4x6WN71gLXqHffJ8g4XrCmIJ6KhsCvwWd3OdBuZUv2CRlDUCGF0V
ksa06vmVpklHBrYcUCZkoTuQD8nLoHByIFWP1bQVmzSX7cp1ESMmN6xzZ+1+CtH7
J1/g18ukxmSGaZU3i1b4
=jOy7
-----END PGP SIGNATURE-----

--+aOZGdcGYL8FotQd--
