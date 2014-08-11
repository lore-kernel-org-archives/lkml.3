Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaHKOR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:17:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:34491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaHKORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:17:51 -0400
Date: Mon, 11 Aug 2014 16:17:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [sched/numa] 096aa33863a: -21.4% hackbench.throughput, -20.2%
 netperf.Throughput_Mbps
Message-ID: <20140811141736.GD9918@twins.programming.kicks-ass.net>
References: <20140807105311.GA17655@localhost>
 <53E3C270.1010302@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1FTutcXiQhqXqWGN"
Content-Disposition: inline
In-Reply-To: <53E3C270.1010302@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1FTutcXiQhqXqWGN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 02:16:16PM -0400, Rik van Riel wrote:
> On 08/07/2014 06:53 AM, Fengguang Wu wrote:
> > Hi Rik,
> >=20
> > We noticed the below performance regression in commit
> > 096aa33863a5e48de52d2ff30e0801b7487944f4 ("sched/numa: Decay
> > ->wakee_flips instead of zeroing")
> >=20
> > b1ad065e65f5610  096aa33863a5e48de52d2ff30  testbox/testcase/testparams
> > ---------------  -------------------------  ---------------------------
> >     122361 =B1 0%     -21.4%      96140 =B1 0%  lkp-snb01/hackbench/50%=
-process-pipe
> >     122361 =B1 0%     -21.4%      96140 =B1 0%  TOTAL hackbench.through=
put
>=20
> I guess the performance of that benchmark depends on it
> "slipping under the wire" after each time the kernel
> zeroes out ->wakee_flips.
>=20
> Depending on repeatedly pulling the wakee back to the same
> node as the waker suggests something else in the kernel may
> be pulling the wakee to another place in the system repeatedly,
> as well, just at a lower frequency (load balancer?).
>=20
> I have also noticed that select_idle_sibling often fails to
> find an idle sibling within the LLC domain, even when it
> exists. Fixing that bug sometimes results in lower performance.
>=20
> It appears that some of the performance results of the scheduler
> appear on the code acting in an opposite way to its documented
> intention.
>=20
> It may be best to revert 096aa33863a for now...

Does something like so cure anything? Is that a 'normal' hackbench run?
lemme see if I can reproduce on anything.

---
 kernel/sched/fair.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86d0d68..13f00daf8028 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4098,14 +4098,19 @@ static unsigned long cpu_avg_load_per_task(int cpu)
=20
 static void record_wakee(struct task_struct *p)
 {
+	unsigned long now =3D jiffies;
 	/*
 	 * Rough decay (wiping) for cost saving, don't worry
 	 * about the boundary, really active task won't care
 	 * about the loss.
 	 */
-	if (time_after(jiffies, current->wakee_flip_decay_ts + HZ)) {
+	if (time_after(now, current->wakee_flip_decay_ts + BITS_PER_LONG * HZ)) {
+		current->wakee_flips =3D 0;
+		current->wakee_flip_decay_ts =3D now;
+	} else while (time_after(now, current->wakee_flip_decay_ts + HZ) &&=20
+		      current->wakee_flips) {
 		current->wakee_flips >>=3D 1;
-		current->wakee_flip_decay_ts =3D jiffies;
+		current->wakee_flip_decay_ts +=3D HZ;
 	}
=20
 	if (current->last_wakee !=3D p) {

--1FTutcXiQhqXqWGN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6NCAAAoJEHZH4aRLwOS6AtoP/07NPdizskWyDMuPtGtWmVGG
hVpEaVD15wo3kMPeUwpEkXVeVKTYM2SaJV3WGJaIPidj9M4GwBlqFpWP50eKSPpJ
d/CNM9dJXKFZa6nYJZ/4WaCW2K5canKhBoU7zQLIsjVz3ffGcu+zUfT7t8/TCU5i
uclPRpZoE1Cq8Ebr/ufq/0Biva+d2Ls+FsO+I9sqnqRMe+zo3QT2lVEosY4So9/I
60x93nBxEy8KMSNYoo4QjHBFzdJown4hrXd2ljvyyifwkWzupPRkB6TxGRGIt3fK
a51rXLWOlq0R8jPxxlA1iqmmi/c+yMW1WOCwJINackfaJOgYP2R/zfxi2w9zvEsf
py94TxzF1SB6iUnf3ltgZDz3aMJYmbiwZHgfAgNnyHCtYP60yuoPUa2Ykzs+RgLx
SndTtgvKBfr5o8odiCviv57Ms68o6k0sxQmbImhx8/ZgYnllLi9rchQXI3wsXvY0
d+8LhdQsUH/9zJpeJDmJtivV0t9o4Ca50TFtEJPxG5MrJMatP93IphIF2DvadeRB
YHsg9bQSGm6idxWSNplsRu5q8X19rPByk3U2i7Yfi4hKPJOW6zLaIxLkK20jFvLA
4Xh5VSJofL53UR3zJkT7LP+V6tvBxAn8YpffEUR8nf0yKzdaxEik9Ft3/9wZbN68
1dHT8KAN0m7jbicT+n3f
=t/O+
-----END PGP SIGNATURE-----

--1FTutcXiQhqXqWGN--
