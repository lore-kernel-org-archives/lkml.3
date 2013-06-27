Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3F0Kgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:36:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:45700 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3F0Kf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:35:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,951,1363132800"; 
   d="scan'208";a="32154649"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/5] time: pass flags instead of multiple bools to timekeeping_update()
Date: Thu, 27 Jun 2013 11:35:45 +0100
Message-ID: <1372329348-20841-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Instead of passing multiple bools to timekeeping_updated(), define
flags and use a single 'action' parameter.  It is then more obvious
what each timekeeping_update() call does.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 kernel/time/timekeeping.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..7aed2b0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -26,6 +26,9 @@
 #include "tick-internal.h"
 #include "ntp_internal.h"
 
+#define TK_CLEAR_NTP (1 << 0)
+#define TK_MIRROR (1 << 1)
+
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static seqcount_t timekeeper_seq;
@@ -241,16 +244,16 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
 /* must hold timekeeper_lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
+static void timekeeping_update(struct timekeeper *tk, unsigned action)
 {
-	if (clearntp) {
+	if (action & TK_CLEAR_NTP) {
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk);
 
-	if (mirror)
+	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
@@ -508,7 +511,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -552,7 +555,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -633,7 +636,7 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -872,7 +875,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -954,7 +957,7 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, false, true);
+	timekeeping_update(tk, TK_MIRROR);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1415,7 +1418,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, false, false);
+	timekeeping_update(real_tk, 0);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-- 
1.7.2.5

