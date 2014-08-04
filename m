Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaHDRJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:09:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56517 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Borislav Petkov" <bp@alien8.de>,
        "Michal Hocko" <mhocko@suse.cz>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.692541084@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 65/94] nohz: Fix another inconsistency between
 CONFIG_NO_HZ=n and nohz=off
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0e576acbc1d9600cf2d9b4a141a2554639959d50 upstream.

If CONFIG_NO_HZ=n tick_nohz_get_sleep_length() returns NSEC_PER_SEC/HZ.

If CONFIG_NO_HZ=y and the nohz functionality is disabled via the
command line option "nohz=off" or not enabled due to missing hardware
support, then tick_nohz_get_sleep_length() returns 0. That happens
because ts->sleep_length is never set in that case.

Set it to NSEC_PER_SEC/HZ when the NOHZ mode is inactive.

Reported-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/tick-sched.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,8 +325,10 @@ void tick_nohz_stop_sched_tick(int inidl
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		ts->sleep_length = (ktime_t) { .tv64 = NSEC_PER_SEC/HZ };
 		goto end;
+	}
 
 	if (need_resched())
 		goto end;

