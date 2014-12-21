Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaLUSrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:47:52 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41257 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaLUSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:47:33 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Amir Vadai <amirv@mellanox.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        David Miller <davem@davemloft.net>, Frank Li <Frank.Li@freescale.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Matthew Vick <matthew.vick@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH net-next 11/11] timecounter: keep track of accumulated fractional nanoseconds
Date: Sun, 21 Dec 2014 19:47:06 +0100
Message-Id: <74bca4ace5011c6ec569c1e65a53403f77b2a5c3.1418504890.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1418504883.git.richardcochran@gmail.com>
References: <cover.1418504883.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current timecounter implementation will drop a variable amount
of resolution, depending on the magnitude of the time delta. In
other words, reading the clock too often or too close to a time
stamp conversion will introduce errors into the time values. This
patch fixes the issue by introducing a fractional nanosecond field
that accumulates the low order bits.

Reported-by: Janusz Użycki <j.uzycki@elproma.com.pl>
Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_clock.c |    4 ++--
 include/linux/timecounter.h                   |   19 +++++++++------
 kernel/time/timecounter.c                     |   31 +++++++++++++++++++------
 virt/kvm/arm/arch_timer.c                     |    3 ++-
 4 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index df35d0e..e9cce4f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -240,7 +240,7 @@ void mlx4_en_init_timestamp(struct mlx4_en_dev *mdev)
 {
 	struct mlx4_dev *dev = mdev->dev;
 	unsigned long flags;
-	u64 ns;
+	u64 ns, zero = 0;
 
 	rwlock_init(&mdev->clock_lock);
 
@@ -265,7 +265,7 @@ void mlx4_en_init_timestamp(struct mlx4_en_dev *mdev)
 	/* Calculate period in seconds to call the overflow watchdog - to make
 	 * sure counter is checked at least once every wrap around.
 	 */
-	ns = cyclecounter_cyc2ns(&mdev->cycles, mdev->cycles.mask);
+	ns = cyclecounter_cyc2ns(&mdev->cycles, mdev->cycles.mask, zero, &zero);
 	do_div(ns, NSEC_PER_SEC / 2 / HZ);
 	mdev->overflow_period = ns;
 
diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
index af3dfa4..74f4549 100644
--- a/include/linux/timecounter.h
+++ b/include/linux/timecounter.h
@@ -55,27 +55,32 @@ struct cyclecounter {
  * @cycle_last:		most recent cycle counter value seen by
  *			timecounter_read()
  * @nsec:		continuously increasing count
+ * @mask:		bit mask for maintaining the 'frac' field
+ * @frac:		accumulated fractional nanoseconds
  */
 struct timecounter {
 	const struct cyclecounter *cc;
 	cycle_t cycle_last;
 	u64 nsec;
+	u64 mask;
+	u64 frac;
 };
 
 /**
  * cyclecounter_cyc2ns - converts cycle counter cycles to nanoseconds
  * @cc:		Pointer to cycle counter.
  * @cycles:	Cycles
- *
- * XXX - This could use some mult_lxl_ll() asm optimization. Same code
- * as in cyc2ns, but with unsigned result.
+ * @mask:	bit mask for maintaining the 'frac' field
+ * @frac:	pointer to storage for the fractional nanoseconds.
  */
 static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
-				      cycle_t cycles)
+				      cycle_t cycles, u64 mask, u64 *frac)
 {
-	u64 ret = (u64)cycles;
-	ret = (ret * cc->mult) >> cc->shift;
-	return ret;
+	u64 ns = (u64) cycles;
+
+	ns = (ns * cc->mult) + *frac;
+	*frac = ns & mask;
+	return ns >> cc->shift;
 }
 
 /**
diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
index 59a1ec3..4687b31 100644
--- a/kernel/time/timecounter.c
+++ b/kernel/time/timecounter.c
@@ -25,6 +25,8 @@ void timecounter_init(struct timecounter *tc,
 	tc->cc = cc;
 	tc->cycle_last = cc->read(cc);
 	tc->nsec = start_tstamp;
+	tc->mask = (1ULL << cc->shift) - 1;
+	tc->frac = 0;
 }
 EXPORT_SYMBOL_GPL(timecounter_init);
 
@@ -51,7 +53,8 @@ static u64 timecounter_read_delta(struct timecounter *tc)
 	cycle_delta = (cycle_now - tc->cycle_last) & tc->cc->mask;
 
 	/* convert to nanoseconds: */
-	ns_offset = cyclecounter_cyc2ns(tc->cc, cycle_delta);
+	ns_offset = cyclecounter_cyc2ns(tc->cc, cycle_delta,
+					tc->mask, &tc->frac);
 
 	/* update time stamp of timecounter_read_delta() call: */
 	tc->cycle_last = cycle_now;
@@ -72,22 +75,36 @@ u64 timecounter_read(struct timecounter *tc)
 }
 EXPORT_SYMBOL_GPL(timecounter_read);
 
+/*
+ * This is like cyclecounter_cyc2ns(), but it is used for computing a
+ * time previous to the time stored in the cycle counter.
+ */
+static u64 cc_cyc2ns_backwards(const struct cyclecounter *cc,
+			       cycle_t cycles, u64 mask, u64 frac)
+{
+	u64 ns = (u64) cycles;
+
+	ns = ((ns * cc->mult) - frac) >> cc->shift;
+
+	return ns;
+}
+
 u64 timecounter_cyc2time(struct timecounter *tc,
 			 cycle_t cycle_tstamp)
 {
-	u64 cycle_delta = (cycle_tstamp - tc->cycle_last) & tc->cc->mask;
-	u64 nsec;
+	u64 delta = (cycle_tstamp - tc->cycle_last) & tc->cc->mask;
+	u64 nsec = tc->nsec, frac = tc->frac;
 
 	/*
 	 * Instead of always treating cycle_tstamp as more recent
 	 * than tc->cycle_last, detect when it is too far in the
 	 * future and treat it as old time stamp instead.
 	 */
-	if (cycle_delta > tc->cc->mask / 2) {
-		cycle_delta = (tc->cycle_last - cycle_tstamp) & tc->cc->mask;
-		nsec = tc->nsec - cyclecounter_cyc2ns(tc->cc, cycle_delta);
+	if (delta > tc->cc->mask / 2) {
+		delta = (tc->cycle_last - cycle_tstamp) & tc->cc->mask;
+		nsec -= cc_cyc2ns_backwards(tc->cc, delta, tc->mask, frac);
 	} else {
-		nsec = cyclecounter_cyc2ns(tc->cc, cycle_delta) + tc->nsec;
+		nsec += cyclecounter_cyc2ns(tc->cc, delta, tc->mask, &frac);
 	}
 
 	return nsec;
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 22fa819..75d9564 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -150,7 +150,8 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	ns = cyclecounter_cyc2ns(timecounter->cc, cval - now);
+	ns = cyclecounter_cyc2ns(timecounter->cc, cval - now, timecounter->mask,
+				 &timecounter->frac);
 	timer_arm(timer, ns);
 }
 
-- 
1.7.10.4

