Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3D2TUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:20:43 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35522 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab3D2TUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:20:40 -0400
Message-ID: <517EC806.6040403@gmail.com>
Date: Mon, 29 Apr 2013 15:20:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        kosaki.motohiro@gmail.com
Subject: [PATCH 6/2] posix-cpu-timers: timer functions must use timer time
 instead of clock time
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For process timer, we use cpu_clock_sample_group() and cpu_timer_sample_group
correctly. However for thread timer, we always use cpu_clock_sample().
That's wrong becuase cpu_clock_sample() account uncommited delta_exec too.

This is not big matter because following workaround code in
posix_cpu_timer_get() hide the timer inversion issue. However it makes wrong
rq lock held and would be better to fix.

  if (cpu_time_before(timer->it_clock, now, timer->it.cpu.expires)) {
    ...
  } else {
    /*
     * The timer should have expired already, but the firing
     * hasn't taken place yet.  Say it's just about to expire.
     */
     itp->it_value.tv_nsec = 1;
     itp->it_value.tv_sec = 0;

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/posix-cpu-timers.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9088023..472394b 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -700,7 +700,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 * check if it's already passed.  In short, we need a sample.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		do_cpu_clock_sample(timer->it_clock, p, false, &val);
+		cpu_timer_sample(timer->it_clock, p, &val);
 	} else {
 		cpu_timer_sample_group(timer->it_clock, p, &val);
 	}
@@ -840,7 +840,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	 * Sample the clock to take the difference with the expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		cpu_clock_sample(timer->it_clock, p, &now);
+		cpu_timer_sample(timer->it_clock, p, &now);
 		clear_dead = p->exit_state;
 	} else {
 		read_lock(&tasklist_lock);
@@ -1165,7 +1165,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	 * Fetch the current sample and update the timer's expiry time.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		cpu_clock_sample(timer->it_clock, p, &now);
+		cpu_timer_sample(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		if (unlikely(p->exit_state)) {
 			clear_dead_task(timer, now);
-- 
1.7.1


