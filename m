Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaFYSo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaFYSoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:44:54 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/1] perf: Prevent race in PERF_SAMPLE_READ group format sample output
Date: Wed, 25 Jun 2014 20:44:35 +0200
Message-Id: <1403721875-15669-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403721875-15669-1-git-send-email-jolsa@kernel.org>
References: <1403721875-15669-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

While iterating siblings in perf_output_read_group we could
race with addition and removal of sibling in perf_group_attach
and perf_group_detach respective.

While in perf_output_read_group we are under active context,
so the only sibling_list modification could come via IPI in:
  perf_install_in_context or perf_remove_from_context

Disable interrupts before iterating siblings to prevent
this race.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2b..66649d3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4509,6 +4509,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 {
 	struct perf_event *leader = event->group_leader, *sub;
 	u64 read_format = event->attr.read_format;
+	unsigned long flags;
 	u64 values[5];
 	int n = 0;
 
@@ -4529,6 +4530,15 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 
 	__output_copy(handle, values, n * sizeof(u64));
 
+	/*
+	 * We are now under active context, so the only sibling_list
+	 * modification could come via IPI in:
+	 *   perf_install_in_context and perf_remove_from_context
+	 *
+	 * Disable interrupts to prevent this race.
+	 */
+	local_irq_save(flags);
+
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
 
@@ -4542,6 +4552,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 
 		__output_copy(handle, values, n * sizeof(u64));
 	}
+	local_irq_restore(flags);
 }
 
 #define PERF_FORMAT_TOTAL_TIMES (PERF_FORMAT_TOTAL_TIME_ENABLED|\
-- 
1.8.3.1

