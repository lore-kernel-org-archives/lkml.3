Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3BLXAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:00:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3BLXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:00:18 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1BVg16HVlSoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FQz980Gyr_cA:10 a=JfrnYn6hAAAA:8 a=w160XLPGjJZy46Wmf4cA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=4XWRJ7YoowM90m6mI6MA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130212230017.802122508@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 12 Feb 2013 17:54:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] sched: Enable interrupts in idle_balance()
References: <20130212225412.781044738@goodmis.org>
Content-Disposition: inline; filename=0003-sched-Enable-interrupts-in-idle_balance.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Now that the idle_balance is called from the post_schedule of the
idle task sched class, it is safe to enable interrupts. This allows
for better interaction of tasks waking up and other interrupts that
are triggered while the idle balance is in process.

Preemption is still disabled, but perhaps that can change as well.
That may need some more investigation.

It may be safe to also enable preemption, but we'll leave that change
for another time.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/fair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ed18c74..0fcdbff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5222,9 +5222,10 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 1);
=20
 	/*
-	 * Drop the rq->lock, but keep IRQ/preempt disabled.
+	 * Drop the rq->lock, but keep preempt disabled.
 	 */
-	raw_spin_unlock(&this_rq->lock);
+	preempt_disable();
+	raw_spin_unlock_irq(&this_rq->lock);
=20
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
@@ -5251,7 +5252,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	}
 	rcu_read_unlock();
=20
-	raw_spin_lock(&this_rq->lock);
+	raw_spin_lock_irq(&this_rq->lock);
+	preempt_enable();
=20
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRGsmBAAoJEOdOSU1xswtMGNcH/3WaD14uLKVHFC0n+twzK60B
4T1BEOB5egVKJXiEkHE65rBqtsIDNyzGjBjx5iBbQ12JoM/FVS8V4CfHVNAp6sLw
ikBvS4eOOE48Y6WPO37zhyrSN+Gu63J/Iy8xh6q5O4kIPdcA6UTMn0snLEQVrrBD
Mcahgom+NWRxMly4J6tERmHloOh4Zy69GCTF8jhC7eFBCwojXJSH0DlysOgHM5UY
6mPgHqMfHSwmya4X57NuQILB7nWgOps1HEBGiYtvLVsFSDYX3nMXxZmbSdxVCbus
4fFXtJNVhpL4ZspkG0dqvNHnHzllgL5M+QPO4UbgqX/yV4OdyTJ1+PXL9unQ5v4=
=pkvj
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
