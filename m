Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab3IAKvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab3IAKuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:50:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 17/24] tools list traceevent: Update kvm plugin with is_writable_pte helper
Date: Sun,  1 Sep 2013 12:48:42 +0200
Message-Id: <1378032529-18498-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding is_writable_pte print helper function,
so the kvmmmu:fast_page_fault print format
gets resolved properly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/plugin_kvm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index a776cd6..ce805c5 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -427,6 +427,16 @@ static int kvm_mmu_get_page_handler(struct trace_seq *s,
 	return kvm_mmu_print_role(s, record, event, context);
 }
 
+#define PT_WRITABLE_SHIFT 1
+#define PT_WRITABLE_MASK (1ULL << PT_WRITABLE_SHIFT)
+
+unsigned long long process_is_writable_pte(struct trace_seq *s,
+					   unsigned long long *args)
+{
+	unsigned long pte = args[0];
+	return pte & PT_WRITABLE_MASK;
+}
+
 int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 {
 	init_disassembler();
@@ -460,5 +470,11 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
+	pevent_register_print_function(pevent,
+				       process_is_writable_pte,
+				       PEVENT_FUNC_ARG_INT,
+				       "is_writable_pte",
+				       PEVENT_FUNC_ARG_LONG,
+				       PEVENT_FUNC_ARG_VOID);
 	return 0;
 }
-- 
1.7.11.7

