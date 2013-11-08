Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3KHJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:14:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015Ab3KHJOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:14:03 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 2/8] x86: return error code in text_poke_bp
Date: Fri,  8 Nov 2013 10:12:06 +0100
Message-Id: <1383901932-1945-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
References: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to use text_poke_bp in the dynamic ftrace which want to
know about errors. For example, it informs about them in the ftrace log.

Let's return the error code instead of the address. The address was just copied
from the first parameter, so it was no extra information. The return value
has not been used anywhere yet.

There is a question whether we should recover the original opcode when
the second or third text_poke_part fails in text_poke_bp. Well, the errors
were ignored until now. It did not cause any real life problems. There is
really small chance that the first byte (int3) can be written and the other
parts of the code can not be modified. It is probably not worth the extra
complexity.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/include/asm/alternative.h |  3 ++-
 arch/x86/kernel/alternative.c      | 18 +++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9..f2343d8 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -226,6 +226,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
+extern int text_poke_bp(void *addr, const void *opcode, size_t len,
+			void *handler);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 0586dc1..c459e62 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -673,9 +673,10 @@ int poke_int3_handler(struct pt_regs *regs)
  *
  * Note: must be called under text_mutex.
  */
-void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
+int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 {
 	unsigned char int3 = 0xcc;
+	int ret;
 
 	bp_int3_handler = handler;
 	bp_int3_addr = (u8 *)addr + sizeof(int3);
@@ -687,15 +688,19 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 */
 	smp_wmb();
 
-	text_poke_part(addr, &int3, sizeof(int3));
+	ret = text_poke_part(addr, &int3, sizeof(int3));
+	if (unlikely(ret))
+		goto fail;
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
 	if (len - sizeof(int3) > 0) {
 		/* patch all but the first byte */
-		text_poke_part((char *)addr + sizeof(int3),
+		ret = text_poke_part((char *)addr + sizeof(int3),
 			       (const char *) opcode + sizeof(int3),
 			       len - sizeof(int3));
+		if (unlikely(ret))
+			goto fail;
 		/*
 		 * According to Intel, this core syncing is very likely
 		 * not necessary and we'd be safe even without it. But
@@ -705,13 +710,16 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	}
 
 	/* patch the first byte */
-	text_poke_part(addr, opcode, sizeof(int3));
+	ret = text_poke_part(addr, opcode, sizeof(int3));
+	if (unlikely(ret))
+		goto fail;
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
+fail:
 	bp_patching_in_progress = false;
 	smp_wmb();
 
-	return addr;
+	return ret;
 }
 
-- 
1.8.4

