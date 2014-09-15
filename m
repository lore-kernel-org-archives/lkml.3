Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaIOPFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:05:48 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54821 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaIOPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:05:46 -0400
Date: Mon, 15 Sep 2014 10:05:24 -0500
From: Clark Williams <clark.williams@gmail.com>
To: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: unify boost and kthread priorities
Message-ID: <20140915100524.2cd80d2e@sluggy>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wkuCoPfloblzjXWlEz._Jar"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wkuCoPfloblzjXWlEz._Jar
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Paul,

Here's the result of our conversation Friday, regarding the per-CPU and
boost priorities:

Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
threads (rcub/n).

Also, create the module_parameter rcutree.kthread_prio to be used on
the kernel command line at boot to set a new value
(rcutree.kthread_prio=3DN).

Signed-off-by: Clark Williams <clark.williams@gmail.com>
---
 Documentation/kernel-parameters.txt |  6 ++++++
 init/Kconfig                        | 23 ++++++++++++-----------
 kernel/rcu/tree_plugin.h            | 16 ++++++++--------
 3 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt index 10d51c2f10d7..471f885ab24d
100644 --- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2856,6 +2856,12 @@ bytes respectively. Such letter suffixes can
also be entirely omitted. quiescent states.  Units are jiffies, minimum
 			value is one, and maximum value is HZ.
=20
+	rcutree.kthread_prio=3D 	 [KNL,BOOT]
+			Set the SCHED_FIFO priority of the RCU
+			per-CPU kthreads (rcuc/N). This value is also
+			used for the priority of the RCU boost threads
+			(rcub/N). Valid values are 1-99.
+
 	rcutree.rcu_nocb_leader_stride=3D [KNL]
 			Set the number of NOCB kthread groups, which
 			defaults to the square root of the number of
diff --git a/init/Kconfig b/init/Kconfig
index e84c6423a2e5..beacc8bb1523 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -662,30 +662,31 @@ config RCU_BOOST
 	  Say Y here if you are working with real-time apps or heavy
loads Say N here if you are unsure.
=20
-config RCU_BOOST_PRIO
-	int "Real-time priority to boost RCU readers to"
+config RCU_KTHREAD_PRIO
+	int "Real-time priority to use for RCU worker threads"
 	range 1 99
 	depends on RCU_BOOST
 	default 1
 	help
-	  This option specifies the real-time priority to which
long-term
-	  preempted RCU readers are to be boosted.  If you are working
-	  with a real-time application that has one or more CPU-bound
-	  threads running at a real-time priority level, you should set
-	  RCU_BOOST_PRIO to a priority higher then the highest-priority
-	  real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
-	  of 1 is appropriate in the common case, which is real-time
+	  This option specifies the SCHED_FIFO priority value that
will be
+	  assigned to the rcuc/n and rcub/n threads and is also the
value
+	  used for RCU_BOOST (if enabled). If you are working with a
+	  real-time application that has one or more CPU-bound threads
+	  running at a real-time priority level, you should set
+	  RCU_KTHREAD_PRIO to a priority higher than the
highest-priority
+	  real-time CPU-bound application thread.  The default
RCU_KTHREAD_PRIO
+	  value of 1 is appropriate in the common case, which is
real-time applications that do not have any CPU-bound threads.
=20
 	  Some real-time applications might not have a single real-time
 	  thread that saturates a given CPU, but instead might have
 	  multiple real-time threads that, taken together, fully
utilize
-	  that CPU.  In this case, you should set RCU_BOOST_PRIO to
+	  that CPU.  In this case, you should set RCU_KTHREAD_PRIO to
 	  a priority higher than the lowest-priority thread that is
 	  conspiring to prevent the CPU from running any non-real-time
 	  tasks.  For example, if one thread at priority 10 and another
 	  thread at priority 5 are between themselves fully consuming
-	  the CPU time on a given CPU, then RCU_BOOST_PRIO should be
+	  the CPU time on a given CPU, then RCU_KTHREAD_PRIO should be
 	  set to priority 6 or higher.
=20
 	  Specify the real-time priority, or take the default if
unsure. diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a7997e272564..dfb3b793b80a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -30,13 +30,10 @@
 #include <linux/smpboot.h>
 #include "../time/tick-internal.h"
=20
-#define RCU_KTHREAD_PRIO 1
-
 #ifdef CONFIG_RCU_BOOST
-#include "../locking/rtmutex_common.h"
-#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
-#else
-#define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
+/* rcuc/rcub kthread realtime priority */
+static int kthread_prio =3D CONFIG_RCU_KTHREAD_PRIO;
+module_param(kthread_prio, int, 0644);
 #endif
=20
 #ifdef CONFIG_RCU_NOCB_CPU
@@ -112,6 +109,9 @@ static void __init rcu_bootup_announce_oddness(void)
 			pr_info("\tPoll for callbacks from no-CBs
CPUs.\n"); }
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+#ifdef CONFIG_RCU_BOOST
+	pr_info("\tRCU kthread priority: %d.\n", kthread_prio);
+#endif
 }
=20
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -1352,7 +1352,7 @@ static int rcu_spawn_one_boost_kthread(struct
rcu_state *rsp, smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task =3D t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	sp.sched_priority =3D RCU_BOOST_PRIO;
+	sp.sched_priority =3D kthread_prio;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
@@ -1369,7 +1369,7 @@ static void rcu_cpu_kthread_setup(unsigned int
cpu) {
 	struct sched_param sp;
=20
-	sp.sched_priority =3D RCU_KTHREAD_PRIO;
+	sp.sched_priority =3D kthread_prio;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 }
=20
--=20
1.9.3


--Sig_/wkuCoPfloblzjXWlEz._Jar
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUFwA9AAoJEEersVlSw9Nz/V8QALbhgoJAuNiVGLiN7OmmVszR
qVDdn6WOkdQXtOwaF8iq5dH2i1+n5mxcYe//IbuFNrhlsNE+dFHgmr2R/CQcWDcy
9IHuLUiTqaYbULx+/hz8akjb2Oczowj4/wkT280tqEDyCRG0s/SMyPBhqKo6kutO
lf1Mf0wxEBjeX1+cMmKXWy5WSu4s1VyTAc7ggDTl9huRZlmYtcKF/XDrWkEnUdbQ
RZZWlMU+VuMcXXfiN1Lb/howw4I8seLh5XUaWEAqbM+8zKe8b7yqPQt/QakHaIAU
gclhoQd3utacWnpem9o5ZWEDUznHoeXf9Hlxaq67vfoEXR37wYOgl3vz45cOF2OW
UEoIG2BGdTeJm1K8lVKMqJksVjRmMZ1FOBCstLnI+3L12DwEXuoGe5OqNjkKtsTT
+FdlJBZWFz08OePvYpPue2ImbhDWQu9+I7OQKBcBnxnvhb5jzTzm/SbSnZYrQg+W
IyjsyGsZX7i9vZPkFYcLue++Nv8gASAElaY1S42WfxvY3ts0S9dY3Io+TMJEuleU
Bt6o43VKHqmeHAr7Bz0u2NMGEdbnZaRH9ZVH9rwf8H8n6Dw2JzZ96EzWOqd7OrJa
9HK/KXbtdY91/JEg+F2Vwi9T/60cxdGu8Uezf6aXpB1NvR5/o66bC1Fdgx3h1vUZ
fTfCbte3JVXBMTTkN265
=cwCy
-----END PGP SIGNATURE-----

--Sig_/wkuCoPfloblzjXWlEz._Jar--
