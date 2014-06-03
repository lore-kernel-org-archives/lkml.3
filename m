Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaFCOR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:17:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaFCORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:17:25 -0400
Date: Tue, 3 Jun 2014 16:16:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140603141659.GO30445@twins.programming.kicks-ass.net>
References: <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
 <20140516162945.GZ11096@twins.programming.kicks-ass.net>
 <53849EB7.9090302@linux.vnet.ibm.com>
 <20140527142637.GB19143@laptop.programming.kicks-ass.net>
 <53875F09.3090607@linux.vnet.ibm.com>
 <538DB076.4090704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NI/YJYXQ/j0wYS88"
Content-Disposition: inline
In-Reply-To: <538DB076.4090704@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NI/YJYXQ/j0wYS88
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 07:24:38PM +0800, Lai Jiangshan wrote:
> Hi, Jason
>=20
> Could you test again after the following command has done.
> (if Peter hasn't asked you test with this command before nor he doesn't s=
top you now)=20
>=20
> echo NO_TTWU_QUEUE > /sys/kernel/debug/sched_features
>=20
> Thanks a lot.
>=20
> Hi, Peter,
>=20
> I found something strange by review (just by review, no test yet)
>=20
> __migrate_task()
> {
> ...
> 	/*
> 	 * If we're not on a rq, the next wake-up will ensure we're
> 	 * placed properly.
> 	 */
> 	if (p->on_rq) {
> 		dequeue_task(rq_src, p, 0);
> 		set_task_cpu(p, dest_cpu);
> 		enqueue_task(rq_dest, p, 0);
> 		check_preempt_curr(rq_dest, p, 0);
> 	}
> ...
> }
>=20
> The comment is incorrect if TTWU_QUEUE is enabled.
> The task is waken-up even p->on_rq=3D=3D0 in this case:
> 	p->wake_entry is added to the rq,
> 	p->state is TASK_WAKING
> 	p->on_rq is 0
>=20
> In this case __migrate_task() fails to migrate the task!!!.
>=20
> Go back to workqueue for higher level analysing.
>=20
> task1				cpu#4			task3
> workqueue_cpu_up_callback()
> 							wake_up_process(worker1)
> 							  ttwu_queue_remote() #queue worker1 to cpu#4
> set_cpus_allowed_ptr()
>   set worker's cpuallowed to
>   cpumask_of(5)
> 				#stopper_task
> 				__migrate_task()
> 				finds p->on_rq is 0,
> 				do nothing return
> set_cpus_allowed_ptr() return 0
>=20
> In this case, the WARN_ON() in process_one_work() hit.

Hmm, yes I think you're right. A queued wakeup can miss an affinity
change like that.

Something like the below ought to cure that I suppose..

---
 kernel/sched/core.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240aa83e73f5..0708ee21632f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1521,17 +1521,32 @@ static int ttwu_remote(struct task_struct *p, int w=
ake_flags)
 }
=20
 #ifdef CONFIG_SMP
+static void ttwu_queue_remote(struct task_struct *p, int cpu)
+{
+	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
+		smp_send_reschedule(cpu);
+}
+
 static void sched_ttwu_pending(void)
 {
 	struct rq *rq =3D this_rq();
 	struct llist_node *llist =3D llist_del_all(&rq->wake_list);
 	struct task_struct *p;
+	int cpu;
=20
 	raw_spin_lock(&rq->lock);
=20
 	while (llist) {
 		p =3D llist_entry(llist, struct task_struct, wake_entry);
 		llist =3D llist_next(llist);
+
+		if (unlikely(!cpumask_test_cpu(rq->cpu, tsk_cpus_allowed(p)))) {
+			cpu =3D select_fallback_rq(rq->cpu, p);
+			set_task_cpu(p, cpu);
+			ttwu_queue_remote(p, cpu);
+			continue;
+		}
+
 		ttwu_do_activate(rq, p, 0);
 	}
=20
@@ -1579,12 +1594,6 @@ void scheduler_ipi(void)
 	irq_exit();
 }
=20
-static void ttwu_queue_remote(struct task_struct *p, int cpu)
-{
-	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
-}
-
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) =3D=3D per_cpu(sd_llc_id, that_cpu);

--NI/YJYXQ/j0wYS88
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjdjbAAoJEHZH4aRLwOS6Ep8QALWCtMQipWoielx2KjoLl34a
+TqZT96SCsPWirz0khTFwrNaPwa/zzUioyg+lA41j0Ht7SHdERX//IbdTuEZjBq0
aGQGmO+ENy0IVtnXYqADb5MKuXrQSrRsKUhgAj+UZvoXmyxrKD/KCKjWisS8aMcf
+A9TipsxbVT48lpzZqQ88XjhM1RDV0mwTQ9kZEhSqR+/5TJ9KujqfE2ThYwpnfaP
s1hRR+nqonzLjN8nxl1s8MOebOdJRjvHFOxvK75Y5+q4q+dXXkAyfzlu4LdoAi8c
vuv9iFKya4PT4MHJwTYXEdwTqreHe4TBF3PAVciyMKAAYGVm0V1wTHVGIMqOZRKB
MtXzgL4LQFyTxUT0MztX0tkpROp4SFmxCZjGitu6xIHSMaxW1S94FbioHQWYJ5Ok
zIYgKZcXjKCkmJ2LNss346JERapxFRWl8AdqPz8JawsBDY3zOtPifcQ7sj8uVEDb
dmCXu4U0BkZKETeWkeI/lBewvDgL4e7ByFV+YoCkApNflVnPiQ4DS8TMIkawd49W
UC46UE5nCu+m3otanhvJkI0oybGyS9f9vQsFruLCnj24/DTYQMSC4eGLZXcmr1hq
eNMwjIVb2WKY+zrL7oj3FbPrzn2A1sZIMQ+a1dReaQH42DjFNHdqG3C5ZKZzKbJR
jFwmSummbb5fxc5W1K4H
=AIBR
-----END PGP SIGNATURE-----

--NI/YJYXQ/j0wYS88--
