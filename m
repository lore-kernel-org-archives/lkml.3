Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaFMCMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:12:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29227 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751444AbaFMCL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:11:58 -0400
Message-Id: <20140613021157.291421941@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 12 Jun 2014 22:10:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 3/4] tools lib traceevent: Add back in kvm plugins nested_vmexit events
References: <20140613021002.444608350@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tools-lib-traceevent-Add-back-in-kvm-plugin-s-nested.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The nested vmexit events were removed from the backport from trace-cmd because
they were considered buggy. They have since been updated in trace-cmd but
are still missing from the traceevent library. Add back in the buggy
version to be able to backport the fixes.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/plugin_kvm.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 2d7d1d7df0a8..0d437837569f 100644
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
2.0.0.rc2


