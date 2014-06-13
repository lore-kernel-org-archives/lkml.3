Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaFMCMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:12:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:47094 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401AbaFMCL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:11:58 -0400
Message-Id: <20140613021156.878720045@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 12 Jun 2014 22:10:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 1/4] tools lib traceevent: Report unknown VMX exit reasons with code
References: <20140613021002.444608350@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tools-lib-traceevent-Report-unknown-VMX-exit-reasons.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Allows to parse the result even if the KVM plugin does not yet
understand a specific exit code.

Link: http://lkml.kernel.org/r/5207446F.1090703@web.de

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/plugin_kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 9e0e8c61b43b..3e6122067d67 100644
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
2.0.0.rc2


