Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaJNHYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:24:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:60040
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaJNHYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:24:48 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 03:24:48 EDT
x-originating-ip: 72.167.245.219
From: Thomas Shao <huishao@microsoft.com>
To: tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Cc: Thomas Shao <huishao@microsoft.com>
Subject: [PATCH] hyperv: Implement Time Synchronization using host time sample
Date: Tue, 14 Oct 2014 01:23:46 -0700
Message-Id: <1413275026-5645-1-git-send-email-huishao@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current hyper-v time sync service,it only gets the initial clock time
from the host. It didn't process the following time samples. This change
introduced a module parameter called host_time_sync. If it is set to true,
the guest will periodically sychronize it's time with the host clock using
host time sample. By default it is disabled, because we still recommend
user to configure NTP for time synchronization.

Signed-off-by: Thomas Shao <huishao@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_util.c      |  114 +++++++++++++++++++++++++++++++++++++++++---
 kernel/time/timekeeping.c |    1 +
 2 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 3b9c9ef..1d8390c 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -51,11 +51,30 @@
 #define HB_WS2008_MAJOR	1
 #define HB_WS2008_VERSION	(HB_WS2008_MAJOR << 16 | HB_MINOR)
 
+#define  TIMESAMPLE_INTERVAL 5000000000L  /* 5s in nanosecond */
+
+/*host sends time sample for every 5s.So the max polling interval
+ *is 128*5 = 640s.
+*/
+#define  TIME_ADJ_MAX_INTERVAL 128 /*Max polling interval */
+
 static int sd_srv_version;
 static int ts_srv_version;
 static int hb_srv_version;
 static int util_fw_version;
 
+/*host sends time sample for every 5s.So the initial polling interval
+ *is 5s.
+*/
+static s32 adj_interval = 1;
+
+/*The host_time_sync module parameter is used to control the time
+  sync between host and guest.
+*/
+static bool host_time_sync;
+module_param(host_time_sync, bool, (S_IRUGO | S_IWUSR));
+MODULE_PARM_DESC(host_time_sync, "If the guest sync time with host");
+
 static void shutdown_onchannelcallback(void *context);
 static struct hv_util_service util_shutdown = {
 	.util_cb = shutdown_onchannelcallback,
@@ -163,15 +182,61 @@ static void shutdown_onchannelcallback(void *context)
 /*
  * Set guest time to host UTC time.
  */
-static inline void do_adj_guesttime(u64 hosttime)
+static inline void do_adj_guesttime(u64 hosttime, bool forceSync)
 {
-	s64 host_tns;
-	struct timespec host_ts;
+	s64 host_tns, guest_tns, diff;
+	struct timespec host_ts, guest_ts;
+	struct timex txc;
+	s64 tickchg;
+	int diff_sign;
 
 	host_tns = (hosttime - WLTIMEDELTA) * 100;
 	host_ts = ns_to_timespec(host_tns);
 
-	do_settimeofday(&host_ts);
+	if (forceSync) {
+		do_settimeofday(&host_ts);
+	} else {
+		guest_ts = CURRENT_TIME;
+		guest_tns = timespec_to_ns(&guest_ts);
+		diff = host_tns - guest_tns;
+		if (diff >= 0) {
+			diff_sign = 1;
+		} else {
+			diff_sign = -1;
+			diff = -diff;
+		}
+
+		/*1s in nanosecond */
+		if (diff > 1000000000 || diff < -1000000000) {
+			do_settimeofday(&host_ts);
+			return;
+		}
+
+		/*1ms in nanosecond */
+		if (diff > 1000000 || diff < -1000000) {
+			/* get the current tick value */
+			txc.modes = 0;
+			do_adjtimex(&txc);
+
+			tickchg = diff * TICK_USEC /
+					(TIMESAMPLE_INTERVAL * adj_interval);
+
+			if (tickchg > TICK_USEC/10)
+				tickchg = TICK_USEC/10;
+
+			if (txc.tick == TICK_USEC + diff_sign * tickchg)
+				return;
+
+			txc.modes = ADJ_TICK;
+			txc.tick = TICK_USEC + diff_sign * tickchg;
+
+			do_adjtimex(&txc);
+		} else {
+			/* double the polling interval*/
+			if (adj_interval < TIME_ADJ_MAX_INTERVAL)
+				adj_interval = adj_interval * 2;
+		}
+	}
 }
 
 /*
@@ -179,8 +244,9 @@ static inline void do_adj_guesttime(u64 hosttime)
  */
 
 struct adj_time_work {
-	struct work_struct work;
+	struct	work_struct work;
 	u64	host_time;
+	bool	forceSync;
 };
 
 static void hv_set_host_time(struct work_struct *work)
@@ -188,7 +254,7 @@ static void hv_set_host_time(struct work_struct *work)
 	struct adj_time_work	*wrk;
 
 	wrk = container_of(work, struct adj_time_work, work);
-	do_adj_guesttime(wrk->host_time);
+	do_adj_guesttime(wrk->host_time, wrk->forceSync);
 	kfree(wrk);
 }
 
@@ -202,11 +268,14 @@ static void hv_set_host_time(struct work_struct *work)
  * thing is, systime is automatically set to emulated hardware clock which may
  * not be UTC time or in the same time zone. So, to override these effects, we
  * use the first 50 time samples for initial system time setting.
+ * If the host_time_sync module parameter is set, we will use the host time
+ * samples to adjust guest time after the first 50 samples.
  */
 static inline void adj_guesttime(u64 hosttime, u8 flags)
 {
 	struct adj_time_work    *wrk;
 	static s32 scnt = 50;
+	static s32 sample_count;
 
 	wrk = kmalloc(sizeof(struct adj_time_work), GFP_ATOMIC);
 	if (wrk == NULL)
@@ -214,6 +283,7 @@ static inline void adj_guesttime(u64 hosttime, u8 flags)
 
 	wrk->host_time = hosttime;
 	if ((flags & ICTIMESYNCFLAG_SYNC) != 0) {
+		wrk->forceSync = true;
 		INIT_WORK(&wrk->work, hv_set_host_time);
 		schedule_work(&wrk->work);
 		return;
@@ -221,10 +291,38 @@ static inline void adj_guesttime(u64 hosttime, u8 flags)
 
 	if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0 && scnt > 0) {
 		scnt--;
+		wrk->forceSync = true;
 		INIT_WORK(&wrk->work, hv_set_host_time);
 		schedule_work(&wrk->work);
-	} else
-		kfree(wrk);
+		return;
+	}
+
+	if (host_time_sync) {
+		/*
+		* Use the Hyper-V time sample to adjust the guest time. The
+		* algorithm is: If the sample offsets exceeds 1 second, we
+		* directly set the clock to the server time. If the offset is
+		* less than 1ms, we ignore the time sample. Otherwise we adjust
+		* the clock.
+		*/
+
+		if ((flags & ICTIMESYNCFLAG_SAMPLE) != 0) {
+			if (sample_count < adj_interval) {
+				sample_count++;
+				goto cleanup;
+			}
+			/* reset the polling interval */
+			sample_count = 0;
+			wrk->forceSync = false;
+			INIT_WORK(&wrk->work, hv_set_host_time);
+			schedule_work(&wrk->work);
+			return;
+		}
+	}
+
+cleanup:
+	kfree(wrk);
+
 }
 
 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..381a1ca 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
 
 	return ret;
 }
+EXPORT_SYMBOL(do_adjtimex);
 
 #ifdef CONFIG_NTP_PPS
 /**
-- 
1.7.1

