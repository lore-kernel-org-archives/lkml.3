Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaGREWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:22:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbaGREW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:22:28 -0400
Date: Thu, 17 Jul 2014 21:22:06 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-54c801ff71ba9c9ae41871e226b9d846ff9c6bab@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, jolsa@redhat.com, cornelia.huck@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1404397747-20939-4-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404397747-20939-4-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Add skip_event() for --duration option
Git-Commit-ID: 54c801ff71ba9c9ae41871e226b9d846ff9c6bab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54c801ff71ba9c9ae41871e226b9d846ff9c6bab
Gitweb:     http://git.kernel.org/tip/54c801ff71ba9c9ae41871e226b9d846ff9c6bab
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Jul 2014 18:29:06 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:32 -0300

perf kvm: Add skip_event() for --duration option

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
