Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaDYJPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:15:17 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44382 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaDYJMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:22 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 09/11] perf kvm: use defines of kvm events
Date: Fri, 25 Apr 2014 11:12:31 +0200
Message-Id: <1398417153-57347-10-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-8372-0000-0000-000009759E36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Currently perf-kvm uses string literals for kvm event names,
but it works only for x86, because other architectures may have
other names for those events.

This patch introduces defines for kvm_entry and kvm_exit events
and lets perf-kvm replace literals.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/include/uapi/asm/kvm.h |  8 ++++++++
 tools/perf/builtin-kvm.c        | 10 ++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d3a8778..88c0099 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -8,6 +8,8 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <asm/svm.h>
+#include <asm/vmx.h>
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
@@ -342,4 +344,10 @@ struct kvm_xcrs {
 struct kvm_sync_regs {
 };
 
+#define VCPU_ID "vcpu_id"
+
+#define KVM_ENTRY "kvm:kvm_entry"
+#define KVM_EXIT "kvm:kvm_exit"
+#define KVM_EXIT_REASON "exit_reason"
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 806c0e4..9a162ae 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -30,8 +30,6 @@
 #include <math.h>
 
 #ifdef HAVE_KVM_STAT_SUPPORT
-#include <asm/svm.h>
-#include <asm/vmx.h>
 #include <asm/kvm.h>
 
 struct event_key {
@@ -130,12 +128,12 @@ static void exit_event_get_key(struct perf_evsel *evsel,
 			       struct event_key *key)
 {
 	key->info = 0;
-	key->key = perf_evsel__intval(evsel, sample, "exit_reason");
+	key->key = perf_evsel__intval(evsel, sample, KVM_EXIT_REASON);
 }
 
 static bool kvm_exit_event(struct perf_evsel *evsel)
 {
-	return !strcmp(evsel->name, "kvm:kvm_exit");
+	return !strcmp(evsel->name, KVM_EXIT);
 }
 
 static bool exit_event_begin(struct perf_evsel *evsel,
@@ -151,7 +149,7 @@ static bool exit_event_begin(struct perf_evsel *evsel,
 
 static bool kvm_entry_event(struct perf_evsel *evsel)
 {
-	return !strcmp(evsel->name, "kvm:kvm_entry");
+	return !strcmp(evsel->name, KVM_ENTRY);
 }
 
 static bool exit_event_end(struct perf_evsel *evsel,
@@ -557,7 +555,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 			return NULL;
 		}
 
-		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, "vcpu_id");
+		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, VCPU_ID);
 		thread->priv = vcpu_record;
 	}
 
-- 
1.8.4.2

