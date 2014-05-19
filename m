Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaESMlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:41:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:56093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaESMlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:41:01 -0400
Date: Mon, 19 May 2014 14:40:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140519124052.GA30445@twins.programming.kicks-ass.net>
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rjUVCMa02lvNeL3Z"
Content-Disposition: inline
In-Reply-To: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rjUVCMa02lvNeL3Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 11:08:35AM -0400, Paul Gortmaker wrote:
> As of the old commit ac086bc22997a2be24fc40fc8d46522fe7e03d11
> ("sched: rt-group: smp balancing") the concept of borrowing per
> cpu rt_runtime from one core to another was introduced.
>=20
> However, this prevents the RT throttling message from ever being
> emitted when someone does a common (but mistaken) attempt at
> using too much CPU in RT context.  Consider the following test:


So the alternative approach is something like the below, where we will
not let it borrow more than the global bandwidth per cpu.

This whole sharing thing is completely fail anyway, but I really
wouldn't know what else to do and keep allowing RT tasks to set random
cpu affinities.


---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7386,10 +7386,59 @@ static int __rt_schedulable(struct task_
 	return ret;
 }
=20
+/*
+ * ret :=3D (a * b) / d
+ */
+static u64 mul_u64_u64_div_u64(u64 a, u64 b, u64 d)
+{
+	/*
+	 * Compute the 128bit product:
+	 *   a * b ->
+	 *     [ a =3D (ah * 2^32 + al),  b =3D (bh * 2^32 + bl) ]
+	 *   -> (ah * bh) * 2^64 + (ah * bl + al * bh) * 2^32 + al * bl
+	 */
+	u32 ah =3D (a >> 32);
+	u32 bh =3D (b >> 32);
+	u32 al =3D a;
+	u32 bl =3D b;
+
+	u64 mh, mm, ml;
+
+	mh =3D (u64)ah * bh;
+	mm =3D (u64)ah * bl + (u64)al * bh;
+	ml =3D (u64)al * bl;
+
+	mh +=3D mm >> 32;
+	mm <<=3D 32;
+
+	ml +=3D mm;
+	if (ml < mm) /* overflow */
+		mh++;
+
+	/*
+	 * Reduce the 128bit result to fit in a 64bit dividend:
+	 *   m / d -> (m / 2^n) / (d / 2^n)
+	 */
+	while (mh) {
+		ml >>=3D 1;
+		if (mh & 1)
+			ml |=3D 1ULL << 63;
+		mh >>=3D 1;
+		d >>=3D 1;
+	}
+
+	if (unlikely(!d))
+		return ml;
+
+	return div64_u64(ml, d);
+}
+
 static int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err =3D 0;
+	u64 g_period =3D global_rt_period();
+	u64 g_runtime =3D global_rt_runtime();
=20
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
@@ -7400,6 +7449,9 @@ static int tg_set_rt_bandwidth(struct ta
 	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 	tg->rt_bandwidth.rt_period =3D ns_to_ktime(rt_period);
 	tg->rt_bandwidth.rt_runtime =3D rt_runtime;
+	tg->rt_bandwidth.rt_max_runtime =3D (g_runtime =3D=3D RUNTIME_INF) ?
+		rt_period :
+		mul_u64_u64_div_u64(rt_period, g_runtime, g_period);
=20
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq =3D tg->rt_rq[i];
@@ -7577,6 +7629,7 @@ static int sched_rt_global_validate(void
 static void sched_rt_do_global(void)
 {
 	def_rt_bandwidth.rt_runtime =3D global_rt_runtime();
+	def_rt_bandwidth.rt_max_runtime =3D global_rt_runtime();
 	def_rt_bandwidth.rt_period =3D ns_to_ktime(global_rt_period());
 }
=20
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -614,12 +614,12 @@ static int do_balance_runtime(struct rt_
 	struct rt_bandwidth *rt_b =3D sched_rt_bandwidth(rt_rq);
 	struct root_domain *rd =3D rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more =3D 0;
-	u64 rt_period;
+	u64 rt_max_runtime;
=20
 	weight =3D cpumask_weight(rd->span);
=20
 	raw_spin_lock(&rt_b->rt_runtime_lock);
-	rt_period =3D ktime_to_ns(rt_b->rt_period);
+	rt_max_runtime =3D rt_b->rt_max_runtime;
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter =3D sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
@@ -643,12 +643,12 @@ static int do_balance_runtime(struct rt_
 		diff =3D iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			diff =3D div_u64((u64)diff, weight);
-			if (rt_rq->rt_runtime + diff > rt_period)
-				diff =3D rt_period - rt_rq->rt_runtime;
+			if (rt_rq->rt_runtime + diff > rt_max_runtime)
+				diff =3D rt_max_runtime - rt_rq->rt_runtime;
 			iter->rt_runtime -=3D diff;
 			rt_rq->rt_runtime +=3D diff;
 			more =3D 1;
-			if (rt_rq->rt_runtime =3D=3D rt_period) {
+			if (rt_rq->rt_runtime =3D=3D rt_max_runtime) {
 				raw_spin_unlock(&iter->rt_runtime_lock);
 				break;
 			}
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -124,6 +124,7 @@ struct rt_bandwidth {
 	raw_spinlock_t		rt_runtime_lock;
 	ktime_t			rt_period;
 	u64			rt_runtime;
+	u64			rt_max_runtime;
 	struct hrtimer		rt_period_timer;
 };
 /*

--rjUVCMa02lvNeL3Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJTefvUAAoJEHZH4aRLwOS6oBAP90RTyv79K2LN9cXfW7/y8xEs
FFifzp8d4rYfzdiTiaoPXtcWQpe8p3YoQW20Pe21lsZe308CgtCU/JzP019ui/tD
yfAQ2M3eXKBMPnazssN12PdB9pi6HkE8Rv1+9mj+4ugTIcxkG4ANpMXWeDt85x3L
H0alZQFKUIGwGvEj40aENNU39X9OcZexp4UiNwUosu7aV25UYZdZEPgmiV89k1+Q
ArE1SJGu4CBMZp16OXGoz3O+/YkRs4mWO73OK1TbOWw7gtWi/wISzCU5Y5PEzSVK
KI5XF1EYq391zxrC+iPZgLV5TEafMaDkzFciur1F/gyMHK3BT2AW3d9r3RajKENL
qU6NWZdXDmEr6pU2EkU90g5Jethjd6JXs9y7kmQU++mT4JPZEhgBZOKQ6zHycFtZ
mqb2MHqEwrB+Csrxildiux+QSfjJmeQ0JJxPiV9b6Dm0haHCAABEw288/oSK9fbI
nhpTvaxKEJxeLoxRNHd83ItjbUcgK3JD6sNRZadTgbyVXIHbalvOgXnHHf8c28ZM
jpmId1ZY9oYXZkCXZqGHhyf1mLSPeXqlGisvNgBsb0o2TJja5lCR08bzY3pQjZQI
KsTzDyKQH1MFvaDsv5ZjrHHkJUL/ULK88BG8MaQNk5QElnU7A+5bePAWRzri7WFm
1qybyE6tINPe6CTyfbA=
=X7x5
-----END PGP SIGNATURE-----

--rjUVCMa02lvNeL3Z--
