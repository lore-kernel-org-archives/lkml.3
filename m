Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaFYFuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:50:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbaFYFuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:50:03 -0400
Date: Tue, 24 Jun 2014 22:49:20 -0700
From: tip-bot for Jan Kiszka <tipbot@zytor.com>
Message-ID: <tip-7f6e3635db39fb2400dc515192125e7b73258000@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, jan.kiszka@siemens.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, jan.kiszka@siemens.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <8e6c02b22ea8136c139a91c69d6cc73b8c5c184b.1388855989.git.jan.kiszka@web.de>
References: <8e6c02b22ea8136c139a91c69d6cc73b8c5c184b.1388855989.git.jan.kiszka@web.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix and cleanup kvm_nested_vmexit tracepoints
Git-Commit-ID: 7f6e3635db39fb2400dc515192125e7b73258000
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

Commit-ID:  7f6e3635db39fb2400dc515192125e7b73258000
Gitweb:     http://git.kernel.org/tip/7f6e3635db39fb2400dc515192125e7b73258000
Author:     Jan Kiszka <jan.kiszka@siemens.com>
AuthorDate: Thu, 12 Jun 2014 22:10:06 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:18:30 +0200

tools lib traceevent: Fix and cleanup kvm_nested_vmexit tracepoints

Fix several issues of kvm_nested_vmexit[_inject]: field width aren't
supported with pevent_print, rip was printed twice/incorrectly, SVM ISA
was hard-coded, we don't use ':' to separate field names.

Link: http://lkml.kernel.org/r/8e6c02b22ea8136c139a91c69d6cc73b8c5c184b.1388855989.git.jan.kiszka@web.de

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_kvm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 0d43783..0575e59 100644
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
