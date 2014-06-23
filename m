Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaFWH7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:59:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaFWH7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:59:31 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/7] tools lib traceevent: Report unknown VMX exit reasons with code
Date: Mon, 23 Jun 2014 09:59:12 +0200
Message-Id: <1403510358-4573-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
References: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Allows to parse the result even if the KVM plugin does not yet
understand a specific exit code.

Link: http://lkml.kernel.org/r/5207446F.1090703@web.de

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 9e0e8c6..3e61220 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -240,9 +240,8 @@ static const char *find_exit_reason(unsigned isa, int val)
 	for (i = 0; strings[i].val >= 0; i++)
 		if (strings[i].val == val)
 			break;
-	if (strings[i].str)
-		return strings[i].str;
-	return "UNKNOWN";
+
+	return strings[i].str;
 }
 
 static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
@@ -251,6 +250,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
 	unsigned long long isa;
 	unsigned long long val;
 	unsigned long long info1 = 0, info2 = 0;
+	const char *reason;
 
 	if (pevent_get_field_val(s, event, "exit_reason", record, &val, 1) < 0)
 		return -1;
@@ -258,7 +258,11 @@ static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
 	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
 		isa = 1;
 
-	trace_seq_printf(s, "reason %s", find_exit_reason(isa, val));
+	reason = find_exit_reason(isa, val);
+	if (reason)
+		trace_seq_printf(s, "reason %s", reason);
+	else
+		trace_seq_printf(s, "reason UNKNOWN (%llu)", val);
 
 	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
-- 
1.8.3.1

