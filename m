Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3GKQ1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:27:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42850 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3GKQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:27:18 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 11/11] perf kvm: debug for missing vmexit/vmentry event
Date: Thu, 11 Jul 2013 10:26:42 -0600
Message-Id: <1373560002-14618-12-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
References: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expected to have missing events for each vcpu when perf is
started. After that should not have missing events.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index c2fede6..76cfe59 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -568,11 +568,22 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 	    (kvm->trace_vcpu != vcpu_record->vcpu_id))
 		return true;
 
-	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
+	if (kvm->events_ops->is_begin_event(evsel, sample, &key)) {
+		if (vcpu_record->start_time) {
+			pr_debug("consecutive begin events (%s) for pid %d, vcpu %d\n",
+				 evsel->name, sample->pid, vcpu_record->vcpu_id);
+		}
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
+	}
+
 
-	if (kvm->events_ops->is_end_event(evsel, sample, &key))
+	if (kvm->events_ops->is_end_event(evsel, sample, &key)) {
+		if (vcpu_record->start_time == 0) {
+			pr_debug("consecutive end events (%s) for pid %d, vcpu %d\n",
+				 evsel->name, sample->pid, vcpu_record->vcpu_id);
+		}
 		return handle_end_event(kvm, vcpu_record, &key, sample);
+	}
 
 	return true;
 }
-- 
1.7.10.1

