Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaJOPqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:46:33 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48050 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaJOPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:46:28 -0400
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
Subject: [PATCH 1/2] kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
Date: Wed, 15 Oct 2014 17:46:17 +0200
Message-Id: <1413387978-984-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101515-0029-0000-0000-000001358640
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow architectures to implement handling of kprobes on function
tracer call sites on their own, without depending on common code.

This patch removes the kprobes check if a kprobe is being placed
on a function tracer call site and therefore gives full responsibility
of handling this correctly to the architecture.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig     | 8 ++++++++
 kernel/kprobes.c | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

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
index 3995f546d0f3..4cc48aa67635 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1428,7 +1428,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
 			return -EILSEQ;
 		p->flags |= KPROBE_FLAG_FTRACE;
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
-		return -EINVAL;
+		if (!IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
+			return -EINVAL;
 #endif
 	}
 
-- 
1.8.5.5

