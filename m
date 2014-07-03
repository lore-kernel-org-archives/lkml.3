Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbaGCO32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:29:28 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:55942 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbaGCO3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:29:21 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 3/4] perf kvm: Add skip_event() for --duration option
Date: Thu,  3 Jul 2014 18:29:06 +0400
Message-Id: <1404397747-20939-4-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070314-2966-0000-0000-0000006A27AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code skips output of the x86 specific HLT event in order to
avoid flooding the output with enabled --duration option. The events to
be skipped should be architecture dependent, though.

Let's add an architecture specific array of events to be skipped and
introduce a skip_event() function checking against that array.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 tools/perf/arch/x86/util/kvm-stat.c |    5 +++++
 tools/perf/builtin-kvm.c            |   13 ++++++++++++-
 tools/perf/util/kvm-stat.h          |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/kvm-stat.c b/tools/perf/arch/x86/util/kvm-stat.c
index 2f8d2c1..14e4e66 100644
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
index 75ee8c1..fc2d63d 100644
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
index d0d9fb1..ba937ca 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -126,5 +126,6 @@ int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid);
 
 extern const char * const kvm_events_tp[];
 extern struct kvm_reg_events_ops kvm_reg_events_ops[];
+extern const char * const kvm_skip_events[];
 
 #endif /* __PERF_KVM_STAT_H */
-- 
1.7.9.5

