Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaFMCMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:12:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:47094 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751746AbaFMCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:11:59 -0400
Message-Id: <20140613021157.080097734@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 12 Jun 2014 22:10:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 2/4] tools lib traceevent: Factor out print_exit_reason in kvm plugin
References: <20140613021002.444608350@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tools-lib-traceevent-Factor-out-print_exit_reason-in.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

We will reuse it for nested vmexit tracepoints.

Link: http://lkml.kernel.org/r/619c418c8af87f03027b8c8013b0443996605700.1388855989.git.jan.kiszka@web.de

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/plugin_kvm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 3e6122067d67..2d7d1d7df0a8 100644
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
2.0.0.rc2


