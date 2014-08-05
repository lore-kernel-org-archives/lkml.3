Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaHESjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:39:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaHESOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 21/39] sched_clock: Avoid corrupting hrtimer tree during suspend
Date: Tue,  5 Aug 2014 11:13:58 -0700
Message-Id: <20140805181336.685933287@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit f723aa1817dd8f4fe005aab52ba70c8ab0ef9457 upstream.

During suspend we call sched_clock_poll() to update the epoch and
accumulated time and reprogram the sched_clock_timer to fire
before the next wrap-around time. Unfortunately,
sched_clock_poll() doesn't restart the timer, instead it relies
on the hrtimer layer to do that and during suspend we aren't
calling that function from the hrtimer layer. Instead, we're
reprogramming the expires time while the hrtimer is enqueued,
which can cause the hrtimer tree to be corrupted. Furthermore, we
restart the timer during suspend but we update the epoch during
resume which seems counter-intuitive.

Let's fix this by saving the accumulated state and canceling the
timer during suspend. On resume we can update the epoch and
restart the timer similar to what we would do if we were starting
the clock for the first time.

Fixes: a08ca5d1089d "sched_clock: Use an hrtimer instead of timer"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1406174630-23458-1-git-send-email-john.stultz@linaro.org
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/sched_clock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -204,7 +204,8 @@ void __init sched_clock_postinit(void)
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(&sched_clock_timer);
+	update_sched_clock();
+	hrtimer_cancel(&sched_clock_timer);
 	cd.suspended = true;
 	return 0;
 }
@@ -212,6 +213,7 @@ static int sched_clock_suspend(void)
 static void sched_clock_resume(void)
 {
 	cd.epoch_cyc = read_sched_clock();
+	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
 	cd.suspended = false;
 }
 


