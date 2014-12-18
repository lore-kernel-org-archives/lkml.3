Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaLRLxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:53:23 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35312 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaLRLxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:53:18 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: m.chehab@samsung.com, david@hardeman.nu, uli-lirc@uli-eckhardt.de,
        hans.verkuil@cisco.com, julia.lawall@lip6.fr, himangi774@gmail.com,
        khoroshilov@ispras.ru, joe@perches.com, dborkman@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de, davem@davemloft.net,
        dwmw2@infradead.org, computersforpeace@gmail.com, arnd@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, zhang.lyra@gmail.com
Subject: [PATCH 3/3] media: rc: Replace timeval with ktime_t in imon.c
Date: Thu, 18 Dec 2014 19:52:02 +0800
Message-Id: <1418903522-19137-4-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
References: <ktime-mtd-rc-v1>
 <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the 32-bit time type (timeval) to the 64-bit one
(ktime_t), since 32-bit time types will break in the year 2038.

I use ktime_t instead of all uses of timeval in imon.c

This patch also changes do_gettimeofday() to ktime_get() accordingly,
since ktime_get returns a ktime_t, but do_gettimeofday returns a
struct timeval, and the other reason is that ktime_get() uses
the monotonic clock.

This patch will use a new function 'ktime_ms_delta' which is introduced
in 1/3 of this patch-set to get the millisecond time difference.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/imon.c |   49 +++++++++++++----------------------------------
 1 file changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b8837dd..a1e91d5 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -31,6 +31,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -41,7 +42,6 @@
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
 
-#include <linux/time.h>
 #include <linux/timer.h>
 
 #define MOD_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
@@ -1158,29 +1158,6 @@ out:
 	return retval;
 }
 
-static inline int tv2int(const struct timeval *a, const struct timeval *b)
-{
-	int usecs = 0;
-	int sec   = 0;
-
-	if (b->tv_usec > a->tv_usec) {
-		usecs = 1000000;
-		sec--;
-	}
-
-	usecs += a->tv_usec - b->tv_usec;
-
-	sec += a->tv_sec - b->tv_sec;
-	sec *= 1000;
-	usecs /= 1000;
-	sec += usecs;
-
-	if (sec < 0)
-		sec = 1000;
-
-	return sec;
-}
-
 /**
  * The directional pad behaves a bit differently, depending on whether this is
  * one of the older ffdc devices or a newer device. Newer devices appear to
@@ -1191,16 +1168,16 @@ static inline int tv2int(const struct timeval *a, const struct timeval *b)
  */
 static int stabilize(int a, int b, u16 timeout, u16 threshold)
 {
-	struct timeval ct;
-	static struct timeval prev_time = {0, 0};
-	static struct timeval hit_time  = {0, 0};
+	ktime_t ct;
+	static ktime_t prev_time;
+	static ktime_t hit_time;
 	static int x, y, prev_result, hits;
 	int result = 0;
-	int msec, msec_hit;
+	long msec, msec_hit;
 
-	do_gettimeofday(&ct);
-	msec = tv2int(&ct, &prev_time);
-	msec_hit = tv2int(&ct, &hit_time);
+	ct = ktime_get();
+	msec = ktime_ms_delta(ct, prev_time);
+	msec_hit = ktime_ms_delta(ct, hit_time);
 
 	if (msec > 100) {
 		x = 0;
@@ -1596,9 +1573,9 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	int i;
 	u64 scancode;
 	int press_type = 0;
-	int msec;
-	struct timeval t;
-	static struct timeval prev_time = { 0, 0 };
+	long msec;
+	ktime_t t;
+	static ktime_t prev_time;
 	u8 ktype;
 
 	/* filter out junk data on the older 0xffdc imon devices */
@@ -1692,10 +1669,10 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	/* Only panel type events left to process now */
 	spin_lock_irqsave(&ictx->kc_lock, flags);
 
-	do_gettimeofday(&t);
+	t = ktime_get();
 	/* KEY_MUTE repeats from knob need to be suppressed */
 	if (ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode) {
-		msec = tv2int(&t, &prev_time);
+		msec = ktime_ms_delta(t, prev_time);
 		if (msec < ictx->idev->rep[REP_DELAY]) {
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
-- 
1.7.9.5

