Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3HGQvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:51:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31426 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab3HGQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:51:15 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Z5wj0-MXZUkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=n9eEBXj4wC8A:10 a=20KFwNOVAAAA:8 a=11smRfc0_RqT7KlUWkcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807165114.147890467@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 12:49:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: [PATCH 4/4] x86/jump-label: Show where and what was wrong on errors
References: <20130807164934.149920591@goodmis.org>
Content-Disposition: inline; filename=0004-x86-jump-label-Show-where-and-what-was-wrong-on-erro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When modifying text sections for jump labels, a paranoid check is
performed. If the check fails, the system "bugs". But why it failed
is not shown.

The BUG_ON()s in the jump label update code is replaced with bug_at(ip).
This is a function that will show what pointer failed, and what was
at the location of the failure that made jump label panic.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 24cf2b2..912a528 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,6 +24,18 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
+static void bug_at(unsigned char *ip, int line)
+{
+	/*
+	 * The location is not an op that we were expecting.
+	 * Something went wrong. Crash the box, as something could be
+	 * corrupting the kernel.
+	 */
+	pr_warning("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
+	       ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
+	BUG();
+}
+
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
 				   void *(*poker)(void *, const void *, size_t),
@@ -37,7 +49,8 @@ static void __jump_label_transform(struct jump_entry *entry,
 		 * We are enabling this jump label. If it is not a nop
 		 * then something must have gone wrong.
 		 */
-		BUG_ON(memcmp((void *)entry->code, ideal_nop, 5) != 0);
+		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
+			bug_at((void *)entry->code, __LINE__);
 
 		code.jump = 0xe9;
 		code.offset = entry->target -
@@ -51,12 +64,14 @@ static void __jump_label_transform(struct jump_entry *entry,
 		 */
 		if (init) {
 			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
-			BUG_ON(memcmp((void *)entry->code, default_nop, 5) != 0);
+			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
+				bug_at((void *)entry->code, __LINE__);
 		} else {
 			code.jump = 0xe9;
 			code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-			BUG_ON(memcmp((void *)entry->code, &code, 5) != 0);
+			if (unlikely(memcmp((void *)entry->code, &code, 5) != 0))
+				bug_at((void *)entry->code, __LINE__);
 		}
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
 	}
-- 
1.7.10.4


