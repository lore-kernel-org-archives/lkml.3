Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbaGQQNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:13:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:52058 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbaGQQND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:03 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/33] perf kvm: Add skip_event() for --duration option
Date: Thu, 17 Jul 2014 13:12:05 -0300
Message-Id: <1405613555-23380-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Current code skips output of the x86 specific HLT event in order to
avoid flooding the output with enabled --duration option. The events to
be skipped should be architecture dependent, though.

Let's add an architecture specific array of events to be skipped and
introduce a skip_event() function checking against that array.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1404397747-20939-4-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/util/kvm-stat.c |  5 +++++
 tools/perf/builtin-kvm.c            | 13 ++++++++++++-
 tools/perf/util/kvm-stat.h          |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/kvm-stat.c b/tools/perf/arch/x86/util/kvm-stat.c
index 2f8d2c1af5ca..14e4e668fad7 100644
--- a/tools/perf/arch/x86/util/kvm-stat.c
+++ b/tools/perf/arch/x86/util/kvm-stat.c
@@ -136,6 +136,11 @@ struct kvm_reg_events_ops kvm_reg_events_ops[] = {
 	{ NULL, NULL },
 };
 
+const char * const kvm_skip_events[] = {
+	"HLT",
+	NULL,
+};
+
 int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
 {
 	if (strstr(cpuid, "Intel")) {
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 75ee8c1a6baf..fc2d63d3e791 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -261,6 +261,17 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
+static bool skip_event(const char *event)
+{
+	const char * const *skip_events;
+
+	for (skip_events = kvm_skip_events; *skip_events; skip_events++)
+		if (!strcmp(event, *skip_events))
+			return true;
+
+	return false;
+}
+
 static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
@@ -312,7 +323,7 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
 		char decode[DECODE_STR_LEN];
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
-		if (strcmp(decode, "HLT")) {
+		if (!skip_event(decode)) {
 			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
 				 sample->time, sample->pid, vcpu_record->vcpu_id,
 				 decode, time_diff/1000);
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index d0d9fb1ae52a..ba937caa28ac 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -126,5 +126,6 @@ int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid);
 
 extern const char * const kvm_events_tp[];
 extern struct kvm_reg_events_ops kvm_reg_events_ops[];
+extern const char * const kvm_skip_events[];
 
 #endif /* __PERF_KVM_STAT_H */
-- 
1.9.3

