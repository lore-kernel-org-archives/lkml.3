Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbaFSQjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaFSQjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:39:03 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/9] tools lib traceevent: Factor out print_exit_reason in kvm plugin
Date: Thu, 19 Jun 2014 18:38:41 +0200
Message-Id: <1403195928-1331-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
References: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

We will reuse it for nested vmexit tracepoints.

Link: http://lkml.kernel.org/r/619c418c8af87f03027b8c8013b0443996605700.1388855989.git.jan.kiszka@web.de

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_kvm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 3e61220..2d7d1d7 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -244,15 +244,14 @@ static const char *find_exit_reason(unsigned isa, int val)
 	return strings[i].str;
 }
 
-static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
-			    struct event_format *event, void *context)
+static int print_exit_reason(struct trace_seq *s, struct pevent_record *record,
+			     struct event_format *event, const char *field)
 {
 	unsigned long long isa;
 	unsigned long long val;
-	unsigned long long info1 = 0, info2 = 0;
 	const char *reason;
 
-	if (pevent_get_field_val(s, event, "exit_reason", record, &val, 1) < 0)
+	if (pevent_get_field_val(s, event, field, record, &val, 1) < 0)
 		return -1;
 
 	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
@@ -263,6 +262,16 @@ static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
 		trace_seq_printf(s, "reason %s", reason);
 	else
 		trace_seq_printf(s, "reason UNKNOWN (%llu)", val);
+	return 0;
+}
+
+static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
+			    struct event_format *event, void *context)
+{
+	unsigned long long info1 = 0, info2 = 0;
+
+	if (print_exit_reason(s, record, event, "exit_reason") < 0)
+		return -1;
 
 	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
-- 
1.8.3.1

