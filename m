Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaFWJeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:34:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaFWJeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:34:01 -0400
Date: Mon, 23 Jun 2014 02:33:48 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-d6f93829811a3e74f58e3c3823d507411eed651a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <1403393357-2070-2-git-send-email-fweisbec@gmail.com>
References: <1403393357-2070-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer: Store cpu-number in struct tvec_base
Git-Commit-ID: d6f93829811a3e74f58e3c3823d507411eed651a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6f93829811a3e74f58e3c3823d507411eed651a
Gitweb:     http://git.kernel.org/tip/d6f93829811a3e74f58e3c3823d507411eed651a
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Sun, 22 Jun 2014 01:29:13 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 23 Jun 2014 11:23:46 +0200

timer: Store cpu-number in struct tvec_base

Timers are serviced by the tick. But when a timer is enqueued on a
dynticks target, we need to kick it in order to make it reconsider the
next tick to schedule to correctly handle the timer's expiring time.

Now while this kick is correctly performed for add_timer_on(), the
mod_timer*() family has been a bit neglected.

To prepare for fixing this, we need internal_add_timer() to be able to
resolve the CPU target associated to a timer's object 'base' so that the
kick can be centralized there.

This can't be passed as an argument as not all the callers know the CPU
number of a timer's base. So lets store it in the struct tvec_base to
resolve the CPU without much overhead. It is set once for good at every
CPU's first boot.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1403393357-2070-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 3bb01a3..9e5f4f2 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -82,6 +82,7 @@ struct tvec_base {
 	unsigned long next_timer;
 	unsigned long active_timers;
 	unsigned long all_timers;
+	int cpu;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -1568,6 +1569,7 @@ static int init_timers_cpu(int cpu)
 		}
 		spin_lock_init(&base->lock);
 		tvec_base_done[cpu] = 1;
+		base->cpu = cpu;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
 	}
