Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaGHJdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:33:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:53874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGHJdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:33:43 -0400
Date: Tue, 8 Jul 2014 11:33:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: mingo@redhat.com, juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        xiaofeng.yan2012@gmail.com
Subject: Re: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
Message-ID: <20140708093334.GD6758@twins.programming.kicks-ass.net>
References: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j+wdmHMkwJXioevW"
Content-Disposition: inline
In-Reply-To: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j+wdmHMkwJXioevW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 08:53:27AM +0000, xiaofeng.yan wrote:
>  static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>  {
> -	s64 delta =3D p->dl.dl_runtime - p->dl.runtime;
> -
> -	if (delta > 10000)
> -		hrtick_start(rq, p->dl.runtime);
> +	delta =3D max_t(s64, 10000LL, delta);
> +	hrtick_start(rq, delta);
>  }

no, no, no. I said to unify the test.

---
 kernel/sched/core.c     | 9 ++++++++-
 kernel/sched/deadline.c | 3 +--
 kernel/sched/fair.c     | 7 -------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e1a2f31bb0cb..c7b8a6fbac66 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -444,7 +444,14 @@ static void __hrtick_start(void *arg)
 void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer =3D &rq->hrtick_timer;
-	ktime_t time =3D ktime_add_ns(timer->base->get_time(), delay);
+	ktime_t time;
+
+	/*
+	 * Don't schedule slices shorter than 10000ns, that just
+	 * doesn't make sense and can cause timer DoS.
+	 */
+	delta =3D max_t(s64, delta, 10000LL);
+	time =3D ktime_add_ns(timer->base->get_time(), delay);
=20
 	hrtimer_set_expires(timer, time);
=20
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1258f..e1e24eea8061 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -999,8 +999,7 @@ static void start_hrtick_dl(struct rq *rq, struct task_=
struct *p)
 {
 	s64 delta =3D p->dl.dl_runtime - p->dl.runtime;
=20
-	if (delta > 10000)
-		hrtick_start(rq, p->dl.runtime);
+	hrtick_start(rq, p->dl.runtime);
 }
 #endif
=20
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 923fe32db6b3..713c58d2a7b0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3901,13 +3901,6 @@ static void hrtick_start_fair(struct rq *rq, struct =
task_struct *p)
 			return;
 		}
=20
-		/*
-		 * Don't schedule slices shorter than 10000ns, that just
-		 * doesn't make sense. Rely on vruntime for fairness.
-		 */
-		if (rq->curr !=3D p)
-			delta =3D max_t(s64, 10000LL, delta);
-
 		hrtick_start(rq, delta);
 	}
 }

--j+wdmHMkwJXioevW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu7ruAAoJEHZH4aRLwOS6Mn8QAJeqwYcAVEftYSoVQY0JgMQS
miRmkBbhw9nmsqVlXNVPm0OMTPQ2kudHtyxm8I+c5jzsa9/UMSMEZ0zjXSCzm6BJ
laIVll5XT/JwqcoLlF7S6c+s8AoTDiGIqgx/2rupsoU1OGnLLQnd7y7XcvUjfqJX
LGR72HivIOk/wBpKSxwWPdxlgArPpjcI6aagTThuDSrnp2qTnKpc1QyNX7i2zuB8
kBvxqYRRh6XIVeoHualSr+7KreiNuHR28BD/J6xQh6G+aPVInjVV8a0k4Dg9RUzy
FWbxBY8i72ac5ZPZ8az+HKwlVUvzxG3hnbFU1sjDOCFbC7nqRmk5fuV7dT4cduQQ
qZxRbFEmPmmvquxV+qYX4Xe20wlnBWTpP4zKEUW/gIuuTd0f1nFuKbfIFnckNwM3
Ews5cqcbTlEXPcTXZVC3RZVNGbKA5R6KSPlTXnFtJT8Ua6c5saOC1sXf1ojMkYU0
ZHoEVzH1yW7l4jqXs5sYoIthazyHr7T+zQ0WAboCpKXs3WDNG03WMoxQxfh/GxA7
yApsdKZmHRMyr50RIAghdXH9tUs9wsTRVfw6oLasmq2YoBvlprbWgAJVb8P1cY0K
onEED1r8T1ccC4nkXOnoCTHAPBnfftjbsv/QuHZ53J83QMiQMNEfG7xFtkg2JUG1
bjclCJnLLsUkwSKU4QVi
=q8CO
-----END PGP SIGNATURE-----

--j+wdmHMkwJXioevW--
