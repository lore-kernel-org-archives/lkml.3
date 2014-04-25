Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaDYRrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaDYRrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:47:45 -0400
Date: Fri, 25 Apr 2014 19:47:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] uprobes/x86: Cleanup the usage of
	arch_uprobe->def.fixups, make it u8
Message-ID: <20140425174721.GA7966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425174704.GA7898@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_riprel_insn() assumes that nobody else could modify ->fixups
before. This is correct but fragile, change it to use "|=".

Also make ->fixups u8, we are going to add the new members into the
union. It is not clear why UPROBE_FIX_RIP_.X lived in the upper byte,
redefine them so that they can fit into u8.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 72caff7..9ce25ce 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -53,7 +53,7 @@ struct arch_uprobe {
 #ifdef CONFIG_X86_64
 			long	riprel_target;
 #endif
-			u16	fixups;
+			u8	fixups;
 		} 			def;
 	};
 };
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 69b2d61..37e73b6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -33,16 +33,16 @@
 /* Post-execution fixups. */
 
 /* Adjust IP back to vicinity of actual insn */
-#define UPROBE_FIX_IP		0x1
+#define UPROBE_FIX_IP		0x01
 
 /* Adjust the return address of a call insn */
-#define UPROBE_FIX_CALL	0x2
+#define UPROBE_FIX_CALL		0x02
 
 /* Instruction will modify TF, don't change it */
-#define UPROBE_FIX_SETF	0x4
+#define UPROBE_FIX_SETF		0x04
 
-#define UPROBE_FIX_RIP_AX	0x8000
-#define UPROBE_FIX_RIP_CX	0x4000
+#define UPROBE_FIX_RIP_AX	0x08
+#define UPROBE_FIX_RIP_CX	0x10
 
 #define	UPROBE_TRAP_NR		UINT_MAX
 
@@ -307,12 +307,12 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 		 * is NOT the register operand, so we use %rcx (register
 		 * #1) for the scratch register.
 		 */
-		auprobe->def.fixups = UPROBE_FIX_RIP_CX;
+		auprobe->def.fixups |= UPROBE_FIX_RIP_CX;
 		/* Change modrm from 00 000 101 to 00 000 001. */
 		*cursor = 0x1;
 	} else {
 		/* Use %rax (register #0) for the scratch register. */
-		auprobe->def.fixups = UPROBE_FIX_RIP_AX;
+		auprobe->def.fixups |= UPROBE_FIX_RIP_AX;
 		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
 		*cursor = (reg << 3);
 	}
-- 
1.5.5.1

