Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3IYMqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:46:20 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:38819 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3IYMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:46:18 -0400
Message-ID: <5242DB0C.4070005@t-online.de>
Date: Wed, 25 Sep 2013 14:46:04 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Prevent divide by zero exception in kernel/events/core.c
References: <5242D207.10306@t-online.de> <20130925121243.GK3081@twins.programming.kicks-ass.net>
In-Reply-To: <20130925121243.GK3081@twins.programming.kicks-ass.net>
Content-Type: multipart/mixed;
 boundary="------------010700070105000204090900"
X-ID: JlLtp+ZTwhu+WEqkvzFgSnk4z6il9N-z35odQcVvu+P-aTimRXeBdIAVOFyj-OPg2d
X-TOI-MSGID: 91b4f1ee-51dc-40e0-97a6-10918181f566
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010700070105000204090900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 25.09.2013 14:12, Peter Zijlstra wrote:
> The 'normal' way of doing that is changing the sysctl table entry to use
> proc_dointvec_minmax and set .extra = &one. See for example
> &sysctl_sched_cfs_bandwidth_slice in kernel/sysctl.c

Thanks. V2 attached.

cu,
  Knut

--------------010700070105000204090900
Content-Type: text/x-patch;
 name="0001-Enforce-1-as-lower-limit-for-perf_event_max_sample_r.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Enforce-1-as-lower-limit-for-perf_event_max_sample_r.pa";
 filename*1="tch"

>From 4ef9dabdd27a02e2ebd45c2d98afda7e43e82ab3 Mon Sep 17 00:00:00 2001
From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Wed, 25 Sep 2013 14:29:37 +0200
Subject: [PATCH] Enforce 1 as lower limit for perf_event_max_sample_rate

/proc/sys/kernel/perf_event_max_sample_rate will accept
negative values as well as 0.

Negative values are unreasonable, and 0 causes a
divide by zero exception in perf_proc_update_handler.

This patch enforces a lower limit of 1.

v2: Use proc_dointvec_minmax() as suggested by
Peter Zijlstra.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
---
 kernel/events/core.c | 2 +-
 kernel/sysctl.c      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..8721a17 100644
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
-- 
1.8.1.4


--------------010700070105000204090900--
