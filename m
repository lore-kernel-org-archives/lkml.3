Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab3HGQwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:52:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab3HGQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:51:15 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=TkhgC8ROfJwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IqgdLC5rw34A:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=pXe2VPY2L4gVTgH6VXkA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807165113.652538059@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 12:49:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/4] x86/jump-label: Use best default nops for inital jump label calls
References: <20130807164934.149920591@goodmis.org>
Content-Disposition: inline; filename=0001-x86-jump-label-Use-best-default-nops-for-inital-jump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As specified by H. Peter Anvin, the best nops for x86 without knowing
the running computer is:

32bit:
  0x3e, 0x8d, 0x74, 0x26, 0x00 also known as GENERIC_NOP5_ATOMIC

64bit:
  0x0f, 0x1f, 0x44, 0x00, 0x00  also known as P6_NOP5_ATOMIC

Currently the default nop that is used by jump label is:

 0xe9 0x00 0x00 0x00 0x00

Which is really a 5byte jump to the next position.

It's better to use a real nop than a jmp.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/jump_label.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 3a16c14..64507f3 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -3,18 +3,23 @@
 
 #ifdef __KERNEL__
 
+#include <linux/stringify.h>
 #include <linux/types.h>
 #include <asm/nops.h>
 #include <asm/asm.h>
 
 #define JUMP_LABEL_NOP_SIZE 5
 
-#define STATIC_KEY_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+#ifdef CONFIG_X86_64
+# define STATIC_KEY_INIT_NOP P6_NOP5_ATOMIC
+#else
+# define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
+#endif
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:"
-		STATIC_KEY_INITIAL_NOP
+		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
-- 
1.7.10.4


