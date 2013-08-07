Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3HGQvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:51:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18980 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab3HGQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:51:15 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=if_WWjHuaHkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pLi8QA9iOc4A:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=nTqW6CzA5JgN1M89fUwA:9 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807165113.974746364@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 12:49:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 3/4] x86/jump-label: Add safety checks to jump label conversions
References: <20130807164934.149920591@goodmis.org>
Content-Disposition: inline; filename=0003-x86-jump-label-Add-safety-checks-to-jump-label-conve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As with all modifying of kernel text, we need to be very paranoid.

When converting the jump label locations to and from nops to jumps
a check has been added to make sure what we are replacing is what we
expect, otherwise we bug.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index ae3d8fb..24cf2b2 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -26,16 +26,40 @@ union jump_code_union {
 
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
-				   void *(*poker)(void *, const void *, size_t))
+				   void *(*poker)(void *, const void *, size_t),
+				   int init)
 {
 	union jump_code_union code;
+	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
 	if (type == JUMP_LABEL_ENABLE) {
+		/*
+		 * We are enabling this jump label. If it is not a nop
+		 * then something must have gone wrong.
+		 */
+		BUG_ON(memcmp((void *)entry->code, ideal_nop, 5) != 0);
+
 		code.jump = 0xe9;
 		code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-	} else
+	} else {
+		/*
+		 * We are disabling this jump label. If it is not what
+		 * we think it is, then something must have gone wrong.
+		 * If this is the first initialization call, then we
+		 * are converting the default nop to the ideal nop.
+		 */
+		if (init) {
+			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
+			BUG_ON(memcmp((void *)entry->code, default_nop, 5) != 0);
+		} else {
+			code.jump = 0xe9;
+			code.offset = entry->target -
+				(entry->code + JUMP_LABEL_NOP_SIZE);
+			BUG_ON(memcmp((void *)entry->code, &code, 5) != 0);
+		}
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+	}
 
 	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 }
@@ -45,7 +69,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 {
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	__jump_label_transform(entry, type, text_poke_smp);
+	__jump_label_transform(entry, type, text_poke_smp, 0);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
@@ -76,7 +100,7 @@ __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 			jlstate = JL_STATE_NO_UPDATE;
 	}
 	if (jlstate == JL_STATE_UPDATE)
-		__jump_label_transform(entry, type, text_poke_early);
+		__jump_label_transform(entry, type, text_poke_early, 1);
 }
 
 #endif
-- 
1.7.10.4


