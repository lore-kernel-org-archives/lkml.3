Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaIZKCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:02:41 -0400
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36569 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaIZKCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:02:36 -0400
From: Thomas Shao <huishao@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, mps.surcouf.lkml@gmail.com
Cc: kys@microsoft.com, haiyangz@microsoft.com,
        Thomas Shao <huishao@microsoft.com>
Subject: [PATCH] Drivers: hv: util: Implement Time Synchronization using host time sample
Date: Fri, 26 Sep 2014 10:02:16 +0000
Message-Id: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
X-Mailer: git-send-email 1.7.1
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
 drivers/hv/hv_util.c |  133 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 125 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 3b9c9ef..9b167c6 100644
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
@@ -160,18 +179,83 @@ static void shutdown_onchannelcallback(void *context)
 		schedule_work(&shutdown_work);
 }
 
+/* helper function to call adjtimex command in user mode */
+static void run_adjtimex_cmd(s64 tickvalue)
+{
+	char *argv[4], *envp[3];
+	char str_tickvalue[20];
+
+	sprintf(str_tickvalue, "%lld", tickvalue);
+
+	argv[0] = "/sbin/adjtimex";
+	argv[1] = "-t";
+	argv[2] = str_tickvalue;
+	argv[3] = NULL;
+
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = NULL;
+
+	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+}
+
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
+	s64 tickchg, tickval;
+	int diff_sign;
 
 	host_tns = (hosttime - WLTIMEDELTA) * 100;
 	host_ts = ns_to_timespec(host_tns);
 
-	do_settimeofday(&host_ts);
+	if (forceSync) {
+		do_settimeofday(&host_ts);
+	} else {
+		/* for the first time, reset the tick value */
+		if (adj_interval == 1) {
+			run_adjtimex_cmd(TICK_USEC);
+			adj_interval = adj_interval * 2;
+			do_settimeofday(&host_ts);
+			return;
+		}
+
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
+			tickchg = diff * TICK_USEC /
+					(TIMESAMPLE_INTERVAL * adj_interval);
+
+			if (tickchg > TICK_USEC/10)
+				tickchg = TICK_USEC/10;
+
+			tickval = TICK_USEC + diff_sign * tickchg;
+			run_adjtimex_cmd(tickval);
+
+		} else {
+			/* double the polling interval*/
+			if (adj_interval < TIME_ADJ_MAX_INTERVAL)
+				adj_interval = adj_interval * 2;
+		}
+	}
 }
 
 /*
@@ -179,8 +263,9 @@ static inline void do_adj_guesttime(u64 hosttime)
  */
 
 struct adj_time_work {
-	struct work_struct work;
+	struct	work_struct work;
 	u64	host_time;
+	bool	forceSync;
 };
 
 static void hv_set_host_time(struct work_struct *work)
@@ -188,7 +273,7 @@ static void hv_set_host_time(struct work_struct *work)
 	struct adj_time_work	*wrk;
 
 	wrk = container_of(work, struct adj_time_work, work);
-	do_adj_guesttime(wrk->host_time);
+	do_adj_guesttime(wrk->host_time, wrk->forceSync);
 	kfree(wrk);
 }
 
@@ -202,11 +287,14 @@ static void hv_set_host_time(struct work_struct *work)
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
@@ -214,6 +302,7 @@ static inline void adj_guesttime(u64 hosttime, u8 flags)
 
 	wrk->host_time = hosttime;
 	if ((flags & ICTIMESYNCFLAG_SYNC) != 0) {
+		wrk->forceSync = true;
 		INIT_WORK(&wrk->work, hv_set_host_time);
 		schedule_work(&wrk->work);
 		return;
@@ -221,10 +310,38 @@ static inline void adj_guesttime(u64 hosttime, u8 flags)
 
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
-- 
1.7.1

