Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3GEJym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:54:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GEJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:54:41 -0400
Date: Fri, 5 Jul 2013 02:54:29 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-e5302920da9ef23f9d19d4e9ac85704cc25bee7a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20130704223010.GA30625@quad>
References: <20130704223010.GA30625@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix interrupt handler timing harness
Git-Commit-ID: e5302920da9ef23f9d19d4e9ac85704cc25bee7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 02:54:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5302920da9ef23f9d19d4e9ac85704cc25bee7a
Gitweb:     http://git.kernel.org/tip/e5302920da9ef23f9d19d4e9ac85704cc25bee7a
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 5 Jul 2013 00:30:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Jul 2013 08:54:43 +0200

perf: Fix interrupt handler timing harness

This patch fixes a serious bug in:

  14c63f17b1fd perf: Drop sample rate when sampling is too slow

There was an misunderstanding on the API of the do_div()
macro. It returns the remainder of the division and this
was not what the function expected leading to disabling the
interrupt latency watchdog.

This patch also remove a duplicate assignment in
perf_sample_event_took().

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: dave.hansen@linux.intel.com
Cc: ak@linux.intel.com
Cc: jolsa@redhat.com
Link: http://lkml.kernel.org/r/20130704223010.GA30625@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
