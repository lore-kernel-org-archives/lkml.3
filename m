Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaJAVNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:13:10 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:48099 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaJAVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:13:05 -0400
X-CheckPoint: {542C6E60-4-2100090A-C0000000}
Message-ID: <201410012113.s91LD3vb022726@farm-0039.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 1 Oct 2014 16:48:29 -0400
Subject: [PATCH v2 1/2] tile: switch to using seqlocks for the vDSO time code
To: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Henrik Austad <henrik@austad.us>
In-Reply-To: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
	<alpine.DEB.2.11.1410010004560.4455@nanos>
	<CALAqxLWHhmyDp-CeGzs6Jqzcrk-KDX_T4UQpTU79VDTL3oHdJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/vdso.h          |  5 ++--
 arch/tile/kernel/time.c               | 16 +++++-------
 arch/tile/kernel/vdso/vgettimeofday.c | 46 ++++++++++++-----------------------
 3 files changed, 24 insertions(+), 43 deletions(-)

v2: split apart seqlock and new functionality into separate commits

diff --git a/arch/tile/include/asm/vdso.h b/arch/tile/include/asm/vdso.h
index 9f6a78d665fa..d64b0d58a7e9 100644
--- a/arch/tile/include/asm/vdso.h
+++ b/arch/tile/include/asm/vdso.h
@@ -15,6 +15,7 @@
 #ifndef __TILE_VDSO_H__
 #define __TILE_VDSO_H__
 
+#include <linux/seqlock.h>
 #include <linux/types.h>
 
 /*
@@ -26,8 +27,8 @@
  */
 
 struct vdso_data {
-	__u64 tz_update_count;  /* Timezone atomicity ctr             */
-	__u64 tb_update_count;  /* Timebase atomicity ctr             */
+	seqcount_t tz_seq;	/* Timezone seqlock                   */
+	seqcount_t tb_seq;	/* Timebase seqlock                   */
 	__u64 xtime_tod_stamp;  /* TOD clock for xtime                */
 	__u64 xtime_clock_sec;  /* Kernel time second                 */
 	__u64 xtime_clock_nsec; /* Kernel time nanosecond             */
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 462dcd0c1700..0661045f718d 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -249,13 +249,10 @@ cycles_t ns2cycles(unsigned long nsecs)
 
 void update_vsyscall_tz(void)
 {
-	/* Userspace gettimeofday will spin while this value is odd. */
-	++vdso_data->tz_update_count;
-	smp_wmb();
+	write_seqcount_begin(&vdso_data->tz_seq);
 	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
 	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
-	smp_wmb();
-	++vdso_data->tz_update_count;
+	write_seqcount_end(&vdso_data->tz_seq);
 }
 
 void update_vsyscall(struct timekeeper *tk)
@@ -267,9 +264,8 @@ void update_vsyscall(struct timekeeper *tk)
 	if (clock != &cycle_counter_cs)
 		return;
 
-	/* Userspace gettimeofday will spin while this value is odd. */
-	++vdso_data->tb_update_count;
-	smp_wmb();
+	write_seqcount_begin(&vdso_data->tb_seq);
+
 	vdso_data->xtime_tod_stamp = clock->cycle_last;
 	vdso_data->xtime_clock_sec = wall_time.tv_sec;
 	vdso_data->xtime_clock_nsec = wall_time.tv_nsec;
@@ -277,6 +273,6 @@ void update_vsyscall(struct timekeeper *tk)
 	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
 	vdso_data->mult = clock->mult;
 	vdso_data->shift = clock->shift;
-	smp_wmb();
-	++vdso_data->tb_update_count;
+
+	write_seqcount_end(&vdso_data->tb_seq);
 }
diff --git a/arch/tile/kernel/vdso/vgettimeofday.c b/arch/tile/kernel/vdso/vgettimeofday.c
index 51ec8e46f5f9..efd00165d654 100644
--- a/arch/tile/kernel/vdso/vgettimeofday.c
+++ b/arch/tile/kernel/vdso/vgettimeofday.c
@@ -53,49 +53,33 @@ inline unsigned long get_datapage(void)
 int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	cycles_t cycles;
-	unsigned long count, sec, ns;
-	volatile struct vdso_data *vdso_data;
+	unsigned count;
+	unsigned long sec, ns;
+	struct vdso_data *vdso = (struct vdso_data *)get_datapage();
 
-	vdso_data = (struct vdso_data *)get_datapage();
 	/* The use of the timezone is obsolete, normally tz is NULL. */
 	if (unlikely(tz != NULL)) {
-		while (1) {
-			/* Spin until the update finish. */
-			count = vdso_data->tz_update_count;
-			if (count & 1)
-				continue;
-
-			tz->tz_minuteswest = vdso_data->tz_minuteswest;
-			tz->tz_dsttime = vdso_data->tz_dsttime;
-
-			/* Check whether updated, read again if so. */
-			if (count == vdso_data->tz_update_count)
-				break;
-		}
+		do {
+			count = read_seqcount_begin(&vdso->tz_seq);
+			tz->tz_minuteswest = vdso->tz_minuteswest;
+			tz->tz_dsttime = vdso->tz_dsttime;
+		} while (unlikely(read_seqcount_retry(&vdso->tz_seq, count)));
 	}
 
 	if (unlikely(tv == NULL))
 		return 0;
 
-	while (1) {
-		/* Spin until the update finish. */
-		count = vdso_data->tb_update_count;
-		if (count & 1)
-			continue;
-
-		cycles = (get_cycles() - vdso_data->xtime_tod_stamp);
-		ns = (cycles * vdso_data->mult) >> vdso_data->shift;
-		sec = vdso_data->xtime_clock_sec;
-		ns += vdso_data->xtime_clock_nsec;
+	do {
+		count = read_seqcount_begin(&vdso->tb_seq);
+		cycles = (get_cycles() - vdso->xtime_tod_stamp);
+		ns = (cycles * vdso->mult) >> vdso->shift;
+		sec = vdso->xtime_clock_sec;
+		ns += vdso->xtime_clock_nsec;
 		if (ns >= NSEC_PER_SEC) {
 			ns -= NSEC_PER_SEC;
 			sec += 1;
 		}
-
-		/* Check whether updated, read again if so. */
-		if (count == vdso_data->tb_update_count)
-			break;
-	}
+	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
 
 	tv->tv_sec = sec;
 	tv->tv_usec = ns / 1000;
-- 
1.8.3.1

