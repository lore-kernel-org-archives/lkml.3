Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaDOSqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:46:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33448 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaDOSp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:45:58 -0400
Date: Tue, 15 Apr 2014 11:45:44 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-03e6bdc5c4d0fc166bfd5d3cf749a5a0c1b5b1bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org,
        tglx@linutronix.de
In-Reply-To: <80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org>
References: <80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick-sched: Don't call update_wall_time()
  when delta is lesser than tick_period
Git-Commit-ID: 03e6bdc5c4d0fc166bfd5d3cf749a5a0c1b5b1bd
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

Commit-ID:  03e6bdc5c4d0fc166bfd5d3cf749a5a0c1b5b1bd
Gitweb:     http://git.kernel.org/tip/03e6bdc5c4d0fc166bfd5d3cf749a5a0c1b5b1bd
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 15 Apr 2014 10:54:40 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Apr 2014 20:26:45 +0200

tick-sched: Don't call update_wall_time() when delta is lesser than tick_period

In tick_do_update_jiffies64() we are processing ticks only if delta is
greater than tick_period. This is what we are supposed to do here and
it broke a bit with this patch:

commit 47a1b796 (tick/timekeeping: Call update_wall_time outside the
jiffies lock)

With above patch, we might end up calling update_wall_time() even if
delta is found to be smaller that tick_period. Fix this by returning
when the delta is less than tick period.

[ tglx: Made it a 3 liner and massaged changelog ]

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: Arvind.Chauhan@arm.com
Cc: linaro-networking@linaro.org
Cc: John Stultz <john.stultz@linaro.org>
Cc: <stable@vger.kernel.org> # v3.14+
Link: http://lkml.kernel.org/r/80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9f8af69..e947d96 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -84,6 +84,9 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
+	} else {
+		write_sequnlock(&jiffies_lock);
+		return;
 	}
 	write_sequnlock(&jiffies_lock);
 	update_wall_time();
