Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaADRUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:20:52 -0500
Received: from mout.web.de ([212.227.15.3]:64018 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbaADRUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:20:07 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [PATCH 3/3] trace-cmd: Fix and cleanup kvm_nested_vmexit tracepoints
Date: Sat,  4 Jan 2014 18:19:50 +0100
Message-Id: <8e6c02b22ea8136c139a91c69d6cc73b8c5c184b.1388855989.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1388855989.git.jan.kiszka@web.de>
References: <cover.1388855989.git.jan.kiszka@web.de>
In-Reply-To: <cover.1388855989.git.jan.kiszka@web.de>
References: <cover.1388855989.git.jan.kiszka@web.de>
X-Provags-ID: V03:K0:NbqEWHS1kg5/BW3GDxBTVMigB6dBrpGmx22ZQcFbxNuDDImI3rl
 hOucyQ0npdSQuTWTkIIGhCSWhr4SbOoa8toyb6xZJZEjiEE/4F8PZnmiX0gz2ibRUzKsw2b
 KmKlkRpAc3rXnKtJ4Zgh5B5Nemwvs63jae3PWXwE/Xk65pH5l5S/iO+++dqZ7BQ9BTKYR11
 AC5tvyikLKLTYDiNbrmKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Fix several issues of kvm_nested_vmexit[_inject]: field width aren't
supported with pevent_print, rip was printed twice/incorrectly, SVM ISA
was hard-coded, we don't use ':' to separate field names.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 plugin_kvm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index c407e55..cb52e9e 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -330,19 +330,13 @@ static int kvm_emulate_insn_handler(struct trace_seq *s, struct pevent_record *r
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
1.8.1.1.298.ge7eed54

