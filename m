Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3EMR42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:56:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12675 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3EMR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:56:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363132800"; 
   d="scan'208";a="23728917"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] timekeeping: sync persistent clock and RTC on system time step changes
Date: Mon, 13 May 2013 18:56:07 +0100
Message-ID: <1368467768-2316-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The persistent clock or the RTC is only synchronized with system time
every 11 minutes if NTP is running.  This gives a window where the
persistent clock may be incorrect after a step change in the time
(such as on first boot).

This particularly affects Xen guests as until an update to the control
domain's persistent clock, new guests will start with the incorrect
system time.

When there is a step change in the system time, call
update_persistent_clock or rtc_set_ntp_time() to synchronize the
persistent clock or RTC to the new system time.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 kernel/time/timekeeping.c |   46 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 98cd470..56f2349 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -240,12 +240,54 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
+#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
+
+static void __sync_persistent_clock(struct work_struct *work)
+{
+	struct timespec now;
+	int ret = 0;
+
+	getnstimeofday(&now);
+
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
+	ret = update_persistent_clock(now);
+#endif
+#ifdef CONFIG_RTC_SYSTOHC
+	if (ret == -ENODEV)
+		rtc_set_ntp_time(now);
+#endif
+}
+
+static DECLARE_DELAYED_WORK(sync_persistent_clock_work, __sync_persistent_clock);
+
+static void sync_persistent_clock(struct timekeeper *tk)
+{
+	u64 nsecs;
+	u32 remainder;
+
+	/* Many RTCs require updates 500 ms before the next second. */
+	nsecs = timekeeping_get_ns(tk);
+	div_u64_rem(nsecs, NSEC_PER_SEC, &remainder);
+	if (remainder > NSEC_PER_SEC / 2)
+		nsecs = remainder - NSEC_PER_SEC / 2;
+	else
+		nsecs = remainder + NSEC_PER_SEC / 2;
+
+	if (system_wq)
+		schedule_delayed_work(&sync_persistent_clock_work, nsecs_to_jiffies(nsecs));
+}
+
+#endif
+
 /* must hold timekeeper_lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
+static void timekeeping_update(struct timekeeper *tk, bool step, bool mirror)
 {
-	if (clearntp) {
+	if (step) {
 		tk->ntp_error = 0;
 		ntp_clear();
+#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
+		sync_persistent_clock(tk);
+#endif
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk);
-- 
1.7.2.5

