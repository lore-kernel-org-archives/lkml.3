Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaADRUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:20:55 -0500
Received: from mout.web.de ([212.227.17.11]:54122 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaADRUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:20:06 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [PATCH 1/3] trace-cmd: Report unknown VMX exit reasons with code
Date: Sat,  4 Jan 2014 18:19:48 +0100
Message-Id: <c83c84ee4b4ba769e4d8a87929281d6b0fa6713a.1388855989.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1388855989.git.jan.kiszka@web.de>
References: <cover.1388855989.git.jan.kiszka@web.de>
In-Reply-To: <cover.1388855989.git.jan.kiszka@web.de>
References: <cover.1388855989.git.jan.kiszka@web.de>
X-Provags-ID: V03:K0:KzVaJLx3m52x/hRmMemnQDZtKz8szY2W4eJShD42b1hGii1mowZ
 uPIklQSA80Wq4XvumY2bstDsH8T8j2EshMRaKaD1wivv1CSdo+ZoVxU3VihjIPNFubNEiMC
 o9sf4rHBoo1jXnF5tN/5qL7NeLDMDZONbw4EnqoE/1biAF34XPeiSFi8UckeTEj4QUG3l57
 6qs/L6EGyYhyywV7v+GIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Allows to parse the result even if the KVM plugin does not yet
understand a specific exit code.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 plugin_kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index 8a25cf1..59443e5 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
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
1.8.1.1.298.ge7eed54

