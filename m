Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3HGQvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:51:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab3HGQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:51:16 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6VAmUqW5lW4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ybpBYmcmEF8A:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VWnXU4kBQmB5lzw8e10A:9 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807165113.812095844@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 12:49:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/4] x86/jump-label: Do not bother updating nops if they are correct
References: <20130807164934.149920591@goodmis.org>
Content-Disposition: inline; filename=0002-x86-jump-label-Do-not-bother-updating-nops-if-they-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On boot up, the jump label init function scans all the jump label locations
and converts them to the best nop for the machine. If the nop is already
the ideal nop, do not bother with changing it.

Cc: Jason Baron <jbaron@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 2889b3d..ae3d8fb 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -50,10 +50,33 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
+static enum {
+	JL_STATE_START,
+	JL_STATE_NO_UPDATE,
+	JL_STATE_UPDATE,
+} jlstate __initdata_or_module = JL_STATE_START;
+
 __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
-	__jump_label_transform(entry, type, text_poke_early);
+	/*
+	 * This function is called at boot up and when modules are
+	 * first loaded. Check if the default nop, the one that is
+	 * inserted at compile time, is the ideal nop. If it is, then
+	 * we do not need to update the nop, and we can leave it as is.
+	 * If it is not, then we need to update the nop to the ideal nop.
+	 */
+	if (jlstate == JL_STATE_START) {
+		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
+		const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
+
+		if (memcmp(ideal_nop, default_nop, 5) != 0)
+			jlstate = JL_STATE_UPDATE;
+		else
+			jlstate = JL_STATE_NO_UPDATE;
+	}
+	if (jlstate == JL_STATE_UPDATE)
+		__jump_label_transform(entry, type, text_poke_early);
 }
 
 #endif
-- 
1.7.10.4


