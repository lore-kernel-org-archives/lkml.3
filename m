Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3GDWaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 18:30:04 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43045 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab3GDWaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 18:30:01 -0400
Date: Fri, 5 Jul 2013 00:30:11 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, dave.hansen@linux.intel.com,
        ak@linux.intel.com, jolsa@redhat.com
Subject: [PATCH] perf: fix interrupt handler timing harness
Message-ID: <20130704223010.GA30625@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a serious bug in:

commit 14c63f17b1fde5a575a28e96547a22b451c71fb5
Author: Dave Hansen <dave.hansen@linux.intel.com>
Date:   Fri Jun 21 08:51:36 2013 -0700

    perf: Drop sample rate when sampling is too slow
    

There was an misunderstanding on the API of the do_div()
macro. It returns the remainder of the division and this
was not what the function expected leading to disabling the
interrupt latency watchdog.

This patch also remove a duplicate assignment in
perf_sample_event_took().

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1db3af9..1833bc5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -182,7 +182,7 @@ void update_perf_cpu_limits(void)
 	u64 tmp = perf_sample_period_ns;
 
 	tmp *= sysctl_perf_cpu_time_max_percent;
-	tmp = do_div(tmp, 100);
+	do_div(tmp, 100);
 	atomic_set(&perf_sample_allowed_ns, tmp);
 }
 
@@ -232,7 +232,7 @@ DEFINE_PER_CPU(u64, running_sample_length);
 void perf_sample_event_took(u64 sample_len_ns)
 {
 	u64 avg_local_sample_len;
-	u64 local_samples_len = __get_cpu_var(running_sample_length);
+	u64 local_samples_len;
 
 	if (atomic_read(&perf_sample_allowed_ns) == 0)
 		return;
