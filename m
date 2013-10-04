Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3JDRcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:32:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JDRci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:32:38 -0400
Date: Fri, 4 Oct 2013 10:32:08 -0700
From: tip-bot for Knut Petersen <tipbot@zytor.com>
Message-ID: <tip-723478c8a471403c53cf144999701f6e0c4bbd11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, Knut_Petersen@t-online.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Knut_Petersen@t-online.de, tglx@linutronix.de
In-Reply-To: <5242DB0C.4070005@t-online.de>
References: <5242DB0C.4070005@t-online.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Enforce 1 as lower limit for perf_event_max_sample_rate
Git-Commit-ID: 723478c8a471403c53cf144999701f6e0c4bbd11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:32:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  723478c8a471403c53cf144999701f6e0c4bbd11
Gitweb:     http://git.kernel.org/tip/723478c8a471403c53cf144999701f6e0c4bbd11
Author:     Knut Petersen <Knut_Petersen@t-online.de>
AuthorDate: Wed, 25 Sep 2013 14:29:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:06:07 +0200

perf: Enforce 1 as lower limit for perf_event_max_sample_rate

/proc/sys/kernel/perf_event_max_sample_rate will accept
negative values as well as 0.

Negative values are unreasonable, and 0 causes a
divide by zero exception in perf_proc_update_handler.

This patch enforces a lower limit of 1.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5242DB0C.4070005@t-online.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 kernel/sysctl.c      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d49a9d2..b25d65c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -193,7 +193,7 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (ret || !write)
 		return ret;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..2a9db91 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1049,6 +1049,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
 		.mode		= 0644,
 		.proc_handler	= perf_proc_update_handler,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "perf_cpu_time_max_percent",
