Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3F1VTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:19:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3F1VTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:19:15 -0400
Date: Fri, 28 Jun 2013 14:18:55 -0700
From: tip-bot for David Vrabel <tipbot@zytor.com>
Message-ID: <tip-04397fe94ad65289884b9862b6a0c722ececaadf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1372329348-20841-3-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-3-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping:
  Pass flags instead of multiple bools to timekeeping_update()
Git-Commit-ID: 04397fe94ad65289884b9862b6a0c722ececaadf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 14:19:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04397fe94ad65289884b9862b6a0c722ececaadf
Gitweb:     http://git.kernel.org/tip/04397fe94ad65289884b9862b6a0c722ececaadf
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Thu, 27 Jun 2013 11:35:45 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 23:15:06 +0200

timekeeping: Pass flags instead of multiple bools to timekeeping_update()

Instead of passing multiple bools to timekeeping_updated(), define
flags and use a single 'action' parameter.  It is then more obvious
what each timekeeping_update() call does.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>
Link: http://lkml.kernel.org/r/1372329348-20841-3-git-send-email-david.vrabel@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 838fc07..d8b23a9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -27,6 +27,9 @@
 #include "ntp_internal.h"
 #include "timekeeping_internal.h"
 
+#define TK_CLEAR_NTP		(1 << 0)
+#define TK_MIRROR		(1 << 1)
+
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static seqcount_t timekeeper_seq;
@@ -242,16 +245,16 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
 /* must hold timekeeper_lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
+static void timekeeping_update(struct timekeeper *tk, unsigned int action)
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
 
@@ -509,7 +512,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -553,7 +556,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -643,7 +646,7 @@ static int change_clocksource(void *data)
 			module_put(new->owner);
 		}
 	}
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -884,7 +887,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -966,7 +969,7 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, false, true);
+	timekeeping_update(tk, TK_MIRROR);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1419,7 +1422,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, false, false);
+	timekeeping_update(real_tk, 0);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
