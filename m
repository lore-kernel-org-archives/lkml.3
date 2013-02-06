Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3BFPPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:15:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab3BFPPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:15:20 -0500
Date: Wed, 6 Feb 2013 16:15:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] posix-cpu-timers: fix nanosleep task_struct leak
Message-ID: <20130206151550.GA1758@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
 <alpine.LFD.2.02.1302011450160.11905@ionos>
 <20130204193223.GA11910@redhat.com>
 <20130205103455.GB18313@redhat.com>
 <alpine.LFD.2.02.1302051155000.11905@ionos>
 <20130206112327.GA1824@redhat.com>
 <CA+ydwtrdNL_7AvZpmJ__06YUCVhSr7YPO8D=wzXhZiWp1-DVqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ydwtrdNL_7AvZpmJ__06YUCVhSr7YPO8D=wzXhZiWp1-DVqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In do_cpu_nanosleep() we do posix_cpu_timer_create(), but forgot
corresponding posix_cpu_timer_del(), what lead to task_struct leak.

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a278cad..a01caac 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1403,6 +1403,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 				/*
 				 * Our timer fired and was reset.
 				 */
+				posix_cpu_timer_del(&timer);
 				spin_unlock_irq(&timer.it_lock);
 				return 0;
 			}
@@ -1420,9 +1421,17 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		 * We were interrupted by a signal.
 		 */
 		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
-		posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		if (!error)
+			posix_cpu_timer_del(&timer);
 		spin_unlock_irq(&timer.it_lock);
 
+		while (error == TIMER_RETRY) {
+			spin_lock_irq(&timer.it_lock);
+			error = posix_cpu_timer_del(&timer);
+			spin_unlock_irq(&timer.it_lock);
+		}
+
 		if ((it->it_value.tv_sec | it->it_value.tv_nsec) == 0) {
 			/*
 			 * It actually did fire already.
-- 
1.7.11.7

