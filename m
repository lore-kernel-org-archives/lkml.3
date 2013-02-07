Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab3BGQEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:04:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab3BGQEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:04:40 -0500
Date: Thu, 7 Feb 2013 17:04:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH v2] posix-cpu-timers: fix nanosleep task_struct leak
Message-ID: <20130207160427.GA6189@redhat.com>
References: <alpine.LFD.2.02.1302011450160.11905@ionos>
 <20130204193223.GA11910@redhat.com>
 <20130205103455.GB18313@redhat.com>
 <alpine.LFD.2.02.1302051155000.11905@ionos>
 <20130206112327.GA1824@redhat.com>
 <CA+ydwtrdNL_7AvZpmJ__06YUCVhSr7YPO8D=wzXhZiWp1-DVqg@mail.gmail.com>
 <20130206151550.GA1758@redhat.com>
 <20130206161011.GA11161@redhat.com>
 <20130207122212.GA2668@redhat.com>
 <20130207132455.GA25793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207132455.GA25793@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In do_cpu_nanosleep() we do posic_cpu_timer_create(), but forgot
corresponding posix_cpu_timer_del() what lead to task_struct leak.

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: add comments

 kernel/posix-cpu-timers.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a278cad..942ca27 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1401,8 +1401,10 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		while (!signal_pending(current)) {
 			if (timer.it.cpu.expires.sched == 0) {
 				/*
-				 * Our timer fired and was reset.
+				 * Our timer fired and was reset, below
+				 * deletion can not fail.
 				 */
+				posix_cpu_timer_del(&timer);
 				spin_unlock_irq(&timer.it_lock);
 				return 0;
 			}
@@ -1420,9 +1422,26 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		 * We were interrupted by a signal.
 		 */
 		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
-		posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		if (!error) {
+			/*
+			 * Timer is now unarmed, deletion can not fail.
+			 */
+			posix_cpu_timer_del(&timer);
+		}
 		spin_unlock_irq(&timer.it_lock);
 
+		while (error == TIMER_RETRY) {
+			/*
+			 * We need to handle case when timer was or is in the
+			 * middle of firing. In other cases we already freed
+			 * resources.
+			 */
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

