Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaFYFt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:49:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaFYFtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:49:23 -0400
Date: Tue, 24 Jun 2014 22:49:08 -0700
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-ea092aeb6d4725048c5a46d1c9cbb4fea49b80b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <20140613021157.291421941@goodmis.org>
References: <20140613021157.291421941@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add back in kvm plugins nested_vmexit events
Git-Commit-ID: ea092aeb6d4725048c5a46d1c9cbb4fea49b80b0
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

Commit-ID:  ea092aeb6d4725048c5a46d1c9cbb4fea49b80b0
Gitweb:     http://git.kernel.org/tip/ea092aeb6d4725048c5a46d1c9cbb4fea49b80b0
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Thu, 12 Jun 2014 22:10:05 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:18:25 +0200

tools lib traceevent: Add back in kvm plugins nested_vmexit events

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
 
