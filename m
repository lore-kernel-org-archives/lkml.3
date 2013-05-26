Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3EZA0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:26:44 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37958 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab3EZA0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:26:40 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 06/16] perf kvm: handle realloc failures
Date: Sat, 25 May 2013 18:24:46 -0600
Message-Id: <1369527896-3650-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save previous pointer and free on failure.

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
 tools/perf/builtin-kvm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 533501e..24b78ae 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -328,6 +328,7 @@ static int kvm_events_hash_fn(u64 key)
 static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 {
 	int old_max_vcpu = event->max_vcpu;
+	void *prev;
 
 	if (vcpu_id < event->max_vcpu)
 		return true;
@@ -335,9 +336,11 @@ static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 	while (event->max_vcpu <= vcpu_id)
 		event->max_vcpu += DEFAULT_VCPU_NUM;
 
+	prev = event->vcpu;
 	event->vcpu = realloc(event->vcpu,
 			      event->max_vcpu * sizeof(*event->vcpu));
 	if (!event->vcpu) {
+		free(prev);
 		pr_err("Not enough memory\n");
 		return false;
 	}
-- 
1.7.10.1

