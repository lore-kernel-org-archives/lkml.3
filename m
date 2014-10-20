Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaJTLAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:00:15 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:37852 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaJTLAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:00:05 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 1/2] kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
Date: Mon, 20 Oct 2014 12:59:53 +0200
Message-Id: <1413802794-38998-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413802794-38998-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1413802794-38998-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102011-0009-0000-0000-000001987E75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow architectures to implement handling of kprobes on function
tracer call sites on their own, without depending on common code.

This patch removes the kprobes check if a kprobe is being placed
on a function tracer call site and therefore gives full responsibility
of handling this correctly to the architecture.

This patch also introduces a user space visible change: if a kprobe
is placed into the middle of an ftrace instruction the return value
is changed from -EINVAL to -EILSEQ also for architectures which do
not support KPROBES_ON_FTRACE.
However in reality this change shouldn't matter at all.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig     |  8 ++++++++
 kernel/kprobes.c | 36 +++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 05d7a8a458d5..e1a8e0edf03f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -85,6 +85,14 @@ config KPROBES_ON_FTRACE
 	 passing of pt_regs to function tracing, then kprobes can
 	 optimize on top of function tracing.
 
+config ARCH_HANDLES_KPROBES_ON_FTRACE
+	def_bool n
+	help
+	 If an architecture can handle kprobes on function tracer call
+	 sites on own, then this option should be selected. This option
+	 removes the check which otherwise prevents to set kprobes on
+	 function tracer call sites.
+
 config UPROBES
 	def_bool n
 	select PERCPU_RWSEM
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f546d0f3..4b57fe9fbeb7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1410,28 +1410,34 @@ static inline int check_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
-static int check_kprobe_address_safe(struct kprobe *p,
-				     struct module **probed_mod)
+static int check_ftrace_location(struct kprobe *p)
 {
-	int ret = 0;
 	unsigned long ftrace_addr;
 
-	/*
-	 * If the address is located on a ftrace nop, set the
-	 * breakpoint to the following instruction.
-	 */
 	ftrace_addr = ftrace_location((unsigned long)p->addr);
-	if (ftrace_addr) {
-#ifdef CONFIG_KPROBES_ON_FTRACE
-		/* Given address is not on the instruction boundary */
-		if ((unsigned long)p->addr != ftrace_addr)
-			return -EILSEQ;
+	if (!ftrace_addr)
+		return 0;
+	/* Given address is not on the instruction boundary */
+	if ((unsigned long)p->addr != ftrace_addr)
+		return -EILSEQ;
+	/* If an architecture handles kprobes on ftrace, we're done */
+	if (IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
+		return 0;
+	if (IS_ENABLED(CONFIG_KPROBES_ON_FTRACE)) {
 		p->flags |= KPROBE_FLAG_FTRACE;
-#else	/* !CONFIG_KPROBES_ON_FTRACE */
-		return -EINVAL;
-#endif
+		return 0;
 	}
+	return -EINVAL;
+}
+
+static int check_kprobe_address_safe(struct kprobe *p,
+				     struct module **probed_mod)
+{
+	int ret;
 
+	ret = check_ftrace_location(p);
+	if (ret)
+		return ret;
 	jump_label_lock();
 	preempt_disable();
 
-- 
1.8.5.5

