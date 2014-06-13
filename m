Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaFMCMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:12:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:28365 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602AbaFMCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:11:59 -0400
Message-Id: <20140613021157.484318137@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 12 Jun 2014 22:10:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 4/4] tools lib traceevent: Fix and cleanup kvm_nested_vmexit tracepoints
References: <20140613021002.444608350@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tools-lib-traceevent-Fix-and-cleanup-kvm_nested_vmex.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Fix several issues of kvm_nested_vmexit[_inject]: field width aren't
supported with pevent_print, rip was printed twice/incorrectly, SVM ISA
was hard-coded, we don't use ':' to separate field names.

Link: http://lkml.kernel.org/r/8e6c02b22ea8136c139a91c69d6cc73b8c5c184b.1388855989.git.jan.kiszka@web.de

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/plugin_kvm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 0d437837569f..0575e59c65f0 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -330,19 +330,13 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_record *record,
 					    struct event_format *event, void *context)
 {
-	unsigned long long val;
-
-	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
-
-	if (pevent_get_field_val(s, event, "exit_code", record, &val, 1) < 0)
+	if (print_exit_reason(s, record, event, "exit_code") < 0)
 		return -1;
 
-	trace_seq_printf(s, "reason %s", find_exit_reason(2, val));
-
-	pevent_print_num_field(s, " ext_inf1: %0x016llx", event, "exit_info1", record, 1);
-	pevent_print_num_field(s, " ext_inf2: %0x016llx", event, "exit_info2", record, 1);
-	pevent_print_num_field(s, " ext_int: %0x016llx", event, "exit_int_info", record, 1);
-	pevent_print_num_field(s, " ext_int_err: %0x016llx", event, "exit_int_info_err", record, 1);
+	pevent_print_num_field(s, " info1 %llx", event, "exit_info1", record, 1);
+	pevent_print_num_field(s, " info2 %llx", event, "exit_info2", record, 1);
+	pevent_print_num_field(s, " int_info %llx", event, "exit_int_info", record, 1);
+	pevent_print_num_field(s, " int_info_err %llx", event, "exit_int_info_err", record, 1);
 
 	return 0;
 }
@@ -350,7 +344,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_r
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
 				     struct event_format *event, void *context)
 {
-	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
+	pevent_print_num_field(s, "rip %lx ", event, "rip", record, 1);
 
 	return kvm_nested_vmexit_inject_handler(s, record, event, context);
 }
-- 
2.0.0.rc2


