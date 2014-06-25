Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaFYFtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:49:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaFYFtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:49:15 -0400
Date: Tue, 24 Jun 2014 22:48:55 -0700
From: tip-bot for Jan Kiszka <tipbot@zytor.com>
Message-ID: <tip-6f21037b3295d4ba20ad2cc7cd4073ec64440f8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, jan.kiszka@siemens.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, jan.kiszka@siemens.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <619c418c8af87f03027b8c8013b0443996605700.1388855989.git.jan.kiszka@web.de>
References: <619c418c8af87f03027b8c8013b0443996605700.1388855989.git.jan.kiszka@web.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Factor out print_exit_reason in kvm plugin
Git-Commit-ID: 6f21037b3295d4ba20ad2cc7cd4073ec64440f8f
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

Commit-ID:  6f21037b3295d4ba20ad2cc7cd4073ec64440f8f
Gitweb:     http://git.kernel.org/tip/6f21037b3295d4ba20ad2cc7cd4073ec64440f8f
Author:     Jan Kiszka <jan.kiszka@siemens.com>
AuthorDate: Thu, 12 Jun 2014 22:10:04 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:18:20 +0200

tools lib traceevent: Factor out print_exit_reason in kvm plugin

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
 
