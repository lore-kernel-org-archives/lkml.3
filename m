Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3IYMH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:07:57 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:50077 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3IYMH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:07:56 -0400
Message-ID: <5242D207.10306@t-online.de>
Date: Wed, 25 Sep 2013 14:07:35 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: Prevent divide by zero exception in kernel/events/core.c
Content-Type: multipart/mixed;
 boundary="------------090208090900050901060200"
X-ID: Tv6ZiBZfghpMkoWsolKHjG-HbCLkkWP20r-atp1TbUFlcU2VnNQOF6ud01ed6ziQVx
X-TOI-MSGID: a59a8d6b-4a14-4c78-8170-92b0ebaecbfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090208090900050901060200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Any value written to /proc/sys/kernel/perf_event_max_sample_rate
is accepted and used as a divisor in perf_proc_update_handler().

Obviously that is wrong. 0 will cause a divide by 0 exception,
and negative values are unreasonable.

The attached patch enforces a lower limit of 1.

cu,
  Knut

--------------090208090900050901060200
Content-Type: text/x-patch;
 name="0001-Enforce-1-as-lower-limit-for-perf_event_max_sample_r.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Enforce-1-as-lower-limit-for-perf_event_max_sample_r.pa";
 filename*1="tch"

>From 7f468bd7bad2f2fec2e93c89a48008d1cba99001 Mon Sep 17 00:00:00 2001
From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Wed, 25 Sep 2013 13:34:57 +0200
Subject: [PATCH] Enforce 1 as lower limit for perf_event_max_sample_rate

/proc/sys/kernel/perf_event_max_sample_rate will accept
negative values as well as 0.

Negative values are unreasonable, and 0 causes a
divide by zero exception in perf_proc_update_handler.

This patch enforces a lower limit of 1.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..350bb53 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -198,6 +198,9 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 	if (ret || !write)
 		return ret;
 
+	if (sysctl_perf_event_sample_rate <= 0)
+		sysctl_perf_event_sample_rate = 1;
+
 	max_samples_per_tick = DIV_ROUND_UP(sysctl_perf_event_sample_rate, HZ);
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
 	update_perf_cpu_limits();
-- 
1.8.1.4


--------------090208090900050901060200--
