Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaADRUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:20:54 -0500
Received: from mout.web.de ([212.227.15.3]:57064 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbaADRUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:20:07 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [PATCH 2/3] trace-cmd: Factor out print_exit_reason in kvm plugin
Date: Sat,  4 Jan 2014 18:19:49 +0100
Message-Id: <619c418c8af87f03027b8c8013b0443996605700.1388855989.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1388855989.git.jan.kiszka@web.de>
References: <cover.1388855989.git.jan.kiszka@web.de>
In-Reply-To: <cover.1388855989.git.jan.kiszka@web.de>
References: <cover.1388855989.git.jan.kiszka@web.de>
X-Provags-ID: V03:K0:ZO17KSBkxZJbtUcJydnY62EZBfZE5R8W6/9Pcosx9ehtzqhobtm
 9l6XSU4VdMWu2CRgp3Iwt+Ojj0byU/IozLLyRu2rLzUxMU4GqEP6vBMu8Gp2+9LS7tlp2i2
 MYh1w7L0X4JW14bSsbAfby8nD3mAp1bRP8XZ26RdDLaR7WM+f3KfZ4pUzzhEXrphRWqgn29
 FRa6TxAqPRPBFdADL6XqQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

We will reuse it for nested vmexit tracepoints.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 plugin_kvm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index 59443e5..c407e55 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
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
1.8.1.1.298.ge7eed54

