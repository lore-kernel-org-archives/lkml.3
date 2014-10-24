Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbaJXPHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:07:53 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51843 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaJXPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:07:49 -0400
Date: Fri, 24 Oct 2014 11:07:46 -0400
From: Burke Libbey <burke.libbey@shopify.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infreadead.org
Subject: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141024150746.GB25260@burke.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom 2014-02-15: https://lkml.org/lkml/2014/2/15/217

This issue was reported and patched, but it still occurs in some situations=
 on
newer kernel versions.

[2249353.328452] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000150
[2249353.336528] IP: [<ffffffff810b1cf7>] check_preempt_wakeup+0xe7/0x210

se.parent gets out of sync with se.depth, causing a panic when the algorith=
m in
find_matching_se assumes they are correct. This patch forces se.depth to be
updated every time se.parent is, so they can no longer become desync'd.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Burke Libbey <burke.libbey@shopify.com>
---

I haven't been able to isolate the problem. Though I'm pretty confident this
fixes the issue I've been having, I have not been able to prove it.

I kept a debugging journal if you want more context for whatever reason:
https://gist.github.com/burke/c60dc5b8f0ba9bfd9275

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..bcffba2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -844,6 +844,7 @@ static inline void set_task_rq(struct task_struct *p, u=
nsigned int cpu)
 #ifdef CONFIG_FAIR_GROUP_SCHED
  p->se.cfs_rq =3D tg->cfs_rq[cpu];
  p->se.parent =3D tg->se[cpu];
+ p->se.depth =3D p->se.parent ? p->se.parent->depth + 1 : 0;
 #endif
=20
 #ifdef CONFIG_RT_GROUP_SCHED


--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlRKaz4ACgkQlQD7fIYie1xMgwCePg+tz8Dwvk6JrpdAF2+EluhB
oRAAoJhn6PYEBm/VG2PmBT6qIjdAcF3i
=Ycri
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
