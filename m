Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaFWH7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:59:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaFWH73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:59:29 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/7] tools lib traceevent: Add back in kvm plugins nested_vmexit events
Date: Mon, 23 Jun 2014 09:59:14 +0200
Message-Id: <1403510358-4573-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
References: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The nested vmexit events were removed from the backport from trace-cmd because
they were considered buggy. They have since been updated in trace-cmd but
are still missing from the traceevent library. Add back in the buggy
version to be able to backport the fixes.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140613021157.291421941@goodmis.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_kvm.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 2d7d1d7..0d43783 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -326,6 +326,35 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
 	return 0;
 }
 
+
+static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_record *record,
+					    struct event_format *event, void *context)
+{
+	unsigned long long val;
+
+	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
+
+	if (pevent_get_field_val(s, event, "exit_code", record, &val, 1) < 0)
+		return -1;
+
+	trace_seq_printf(s, "reason %s", find_exit_reason(2, val));
+
+	pevent_print_num_field(s, " ext_inf1: %0x016llx", event, "exit_info1", record, 1);
+	pevent_print_num_field(s, " ext_inf2: %0x016llx", event, "exit_info2", record, 1);
+	pevent_print_num_field(s, " ext_int: %0x016llx", event, "exit_int_info", record, 1);
+	pevent_print_num_field(s, " ext_int_err: %0x016llx", event, "exit_int_info_err", record, 1);
+
+	return 0;
+}
+
+static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
+				     struct event_format *event, void *context)
+{
+	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
+
+	return kvm_nested_vmexit_inject_handler(s, record, event, context);
+}
+
 union kvm_mmu_page_role {
 	unsigned word;
 	struct {
@@ -422,6 +451,12 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	pevent_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
 				      kvm_emulate_insn_handler, NULL);
 
+	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+				      kvm_nested_vmexit_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+				      kvm_nested_vmexit_inject_handler, NULL);
+
 	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
 				      kvm_mmu_get_page_handler, NULL);
 
@@ -456,6 +491,12 @@ void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
 					kvm_emulate_insn_handler, NULL);
 
+	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+					kvm_nested_vmexit_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+					kvm_nested_vmexit_inject_handler, NULL);
+
 	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
 					kvm_mmu_get_page_handler, NULL);
 
-- 
1.8.3.1

