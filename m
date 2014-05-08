Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaEHMDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:03:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:43279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaEHMDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:03:31 -0400
Date: Thu, 8 May 2014 14:03:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, nicolas.pitre@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/idle: Reflow cpuidle_idle_call()
Message-ID: <20140508120327.GS11096@twins.programming.kicks-ass.net>
References: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org>
 <1877683.4pfeUuvFZ2@vostro.rjw.lan>
 <5838571.inpi2giIZ5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8teuZUM8bA5gqecl"
Content-Disposition: inline
In-Reply-To: <5838571.inpi2giIZ5@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8teuZUM8bA5gqecl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:41:29PM +0200, Rafael J. Wysocki wrote:
> > I wonder how we can resolve this?
>=20
> And I wonder why I haven't been in the CC list of this tip-bot message ev=
en.

Yes, my bad there, I should really script adding CCs :/

That change actually made the patch smaller and simpler.

---
 drivers/cpuidle/cpuidle.c | 30 +++++++++---------------------
 include/linux/cpuidle.h   |  5 -----
 kernel/sched/idle.c       | 13 ++++---------
 3 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8236746e46bb..fca5405cbad6 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -65,26 +65,6 @@ int cpuidle_play_dead(void)
 }
=20
 /**
- * cpuidle_enabled - check if the cpuidle framework is ready
- * @dev: cpuidle device for this cpu
- * @drv: cpuidle driver for this cpu
- *
- * Return 0 on success, otherwise:
- * -NODEV : the cpuidle framework is not available
- * -EBUSY : the cpuidle framework is not initialized
- */
-int cpuidle_enabled(struct cpuidle_driver *drv, struct cpuidle_device *dev)
-{
-	if (off || !initialized)
-		return -ENODEV;
-
-	if (!drv || !dev || !dev->enabled)
-		return -EBUSY;
-
-	return 0;
-}
-
-/**
  * cpuidle_enter_state - enter the state and update stats
  * @dev: cpuidle device for this cpu
  * @drv: cpuidle driver for this cpu
@@ -134,10 +114,18 @@ int cpuidle_enter_state(struct cpuidle_device *dev, s=
truct cpuidle_driver *drv,
  * @drv: the cpuidle driver
  * @dev: the cpuidle device
  *
- * Returns the index of the idle state.
+ * Returns the index of the idle state on success, otherwise:
+ * -NODEV : the cpuidle framework is not available
+ * -EBUSY : the cpuidle framework is not initialized
  */
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
+	if (off || !initialized)
+		return -ENODEV;
+
+	if (!drv || !dev || !dev->enabled)
+		return -EBUSY;
+
 	return cpuidle_curr_governor->select(drv, dev);
 }
=20
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index b0238cba440b..a8d5bd391a26 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -120,8 +120,6 @@ struct cpuidle_driver {
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
=20
-extern int cpuidle_enabled(struct cpuidle_driver *drv,
-			  struct cpuidle_device *dev);
 extern int cpuidle_select(struct cpuidle_driver *drv,
 			  struct cpuidle_device *dev);
 extern int cpuidle_enter(struct cpuidle_driver *drv,
@@ -149,9 +147,6 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device=
 *dev);
 #else
 static inline void disable_cpuidle(void) { }
-static inline int cpuidle_enabled(struct cpuidle_driver *drv,
-				  struct cpuidle_device *dev)
-{return -ENODEV; }
 static inline int cpuidle_select(struct cpuidle_driver *drv,
 				 struct cpuidle_device *dev)
 {return -ENODEV; }
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 34083c9ac976..25b9423abce9 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -98,10 +98,11 @@ static void cpuidle_idle_call(void)
 	rcu_idle_enter();
=20
 	/*
-	 * Check if the cpuidle framework is ready, otherwise fallback
-	 * to the default arch specific idle method
+	 * Ask the cpuidle framework to choose a convenient idle state.
+	 * Fall back to the default arch idle method on errors.
 	 */
-	if (cpuidle_enabled(drv, dev)) {
+	next_state =3D cpuidle_select(drv, dev);
+	if (next_state < 0) {
 use_default:
 		/*
 		 * We can't use the cpuidle framework, let's use the default
@@ -115,12 +116,6 @@ static void cpuidle_idle_call(void)
 		goto exit_idle;
 	}
=20
-	/*
-	 * Ask the governor to choose an idle state it thinks
-	 * it is convenient to go to. There is *always* a
-	 * convenient idle state
-	 */
-	next_state =3D cpuidle_select(drv, dev);
=20
 	/*
 	 * The idle task must be scheduled, it is pointless to

--8teuZUM8bA5gqecl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa3KFAAoJEHZH4aRLwOS6HokQALPEQfneNLofw30cMfZjkx6N
LsSmF83tiPHtdmODV6DGc2XqzbcHzZFsp/Bjti8jKhvu/C+WecsWeLPkCYEyCQ8h
4RT+alRfqCuB3fQ9uaDsCVH65HvEseTqvCTwmfMQWCKI1FqIk6P5Llb6cq5DVqJp
vFCb7CX9tBKkumbc9S8SYTJDdK2ObpZW67chqg//vrGkeOtHyoSJn1pZjIfRAjyC
yuiRwfDMfB7MU4Kizo4/RjqFel2WmPEaGh6tQY3vsAbbMKPRmy9Uf2AYdgDA7Jzi
PXPy3CnGlzbRPVczpXIpTFakAbk5J0AdJmJzh6UO+HiNQRE3QitG3s1jxJ8yx1Jy
VDYJcyKywBtc6uiTZhhQcZnw3q57GqJV5EnKRMaAjh9jjofQwSJ7lpYjVRvdl5lW
V/PRngIvz8auyyhnlO/u8OqmOdKKBsiRcIuzcgKQlJP3+3MaB3ryxnXi34cS3BGG
NCzpfr3VsqYEz0aqwKNSuIuyAqDUgBnsD1FCyVXjLYkieRyTrJsVOKbyqWxxf1Un
tXs/ySUQ66yBkkWrOwTY/iF6oXmXLLhjgcd8hpPRaBEEAgHlVmV/q4Ybmn1Lau/2
gAqLHNHgMqDPX0npMLCXtTVMIlBzuQbeN/iBZD7CZqjVZ6DJf/XAETwyxe0vea3x
33izU31CXMbfNbKQqeJn
=5J6X
-----END PGP SIGNATURE-----

--8teuZUM8bA5gqecl--
