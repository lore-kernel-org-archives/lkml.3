Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaFYFtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:49:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFYFtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:49:13 -0400
Date: Tue, 24 Jun 2014 22:48:43 -0700
From: tip-bot for Jan Kiszka <tipbot@zytor.com>
Message-ID: <tip-20d3cbd75ef17b96dfb4f5f1600c0278d330f5ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, jan.kiszka@siemens.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, jan.kiszka@siemens.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <5207446F.1090703@web.de>
References: <5207446F.1090703@web.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Report unknown VMX exit reasons with code
Git-Commit-ID: 20d3cbd75ef17b96dfb4f5f1600c0278d330f5ca
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

Commit-ID:  20d3cbd75ef17b96dfb4f5f1600c0278d330f5ca
Gitweb:     http://git.kernel.org/tip/20d3cbd75ef17b96dfb4f5f1600c0278d330f5ca
Author:     Jan Kiszka <jan.kiszka@siemens.com>
AuthorDate: Thu, 12 Jun 2014 22:10:03 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:17:54 +0200

tools lib traceevent: Report unknown VMX exit reasons with code

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
 
