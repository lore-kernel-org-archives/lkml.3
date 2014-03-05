Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbaCEPKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:10:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbaCEO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 066/131] perf: Enforce 1 as lower limit for perf_event_max_sample_rate
Date: Wed,  5 Mar 2014 14:23:10 +0000
Message-Id: <1394029455-23128-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Knut Petersen <Knut_Petersen@t-online.de>

commit 723478c8a471403c53cf144999701f6e0c4bbd11 upstream.

/proc/sys/kernel/perf_event_max_sample_rate will accept
negative values as well as 0.

Negative values are unreasonable, and 0 causes a
divide by zero exception in perf_proc_update_handler.

This patch enforces a lower limit of 1.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5242DB0C.4070005@t-online.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 2 +-
 kernel/sysctl.c      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f86599e..fc645f1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -192,7 +192,7 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (ret || !write)
 		return ret;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 07f6fc4..f252045 100644
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
-- 
1.9.0

