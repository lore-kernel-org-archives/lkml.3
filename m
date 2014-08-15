Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaHOMAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:00:11 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:45493 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHOMAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:00:09 -0400
Date: Fri, 15 Aug 2014 14:00:02 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] s390/ftrace: optimize function graph caller code
Message-ID: <20140815120002.GD4215@osiris>
References: <20140703120046.GA10664@suse.cz>
 <20140708080740.GA4491@osiris>
 <20140815115753.GA4215@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815115753.GA4215@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081512-5024-0000-0000-000000FF3646
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the function graph tracer is disabled we can skip three additional
instructions. So let's just do just this.

So if function tracing is enabled but function graph tracing is
runtime disabled, we get away with a single unconditional branch.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/ftrace.h |  1 +
 arch/s390/kernel/ftrace.c      | 24 ++++++++++++++++++++++++
 arch/s390/kernel/mcount64.S    | 15 +++++++++------
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 4b264caa0704..874f903c2eb4 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -4,6 +4,7 @@
 #ifndef __ASSEMBLY__
 
 extern void _mcount(void);
+extern char ftrace_graph_caller_end;
 
 struct dyn_arch_ftrace { };
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index ae4141fbcb07..7dc7df3857c4 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -170,6 +170,29 @@ out:
  * directly after the instructions. To enable the call we calculate
  * the original offset to prepare_ftrace_return and put it back.
  */
+
+#ifdef CONFIG_64BIT
+
+int ftrace_enable_ftrace_graph_caller(void)
+{
+	static unsigned short offset = 0x0002;
+
+	return probe_kernel_write((void *) ftrace_graph_caller + 2,
+				  &offset, sizeof(offset));
+}
+
+int ftrace_disable_ftrace_graph_caller(void)
+{
+	unsigned short offset;
+
+	offset = ((void *) &ftrace_graph_caller_end -
+		  (void *) ftrace_graph_caller) / 2;
+	return probe_kernel_write((void *) ftrace_graph_caller + 2,
+				  &offset, sizeof(offset));
+}
+
+#else /* CONFIG_64BIT */
+
 int ftrace_enable_ftrace_graph_caller(void)
 {
 	unsigned short offset;
@@ -188,5 +211,6 @@ int ftrace_disable_ftrace_graph_caller(void)
 				  &offset, sizeof(offset));
 }
 
+#endif /* CONFIG_64BIT */
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index c67a8bf0fd9a..b03896d29274 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -32,14 +32,17 @@ ENTRY(ftrace_caller)
 	lg	%r14,0(%r14)
 	basr	%r14,%r14
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+# The j instruction gets runtime patched to a nop instruction.
+# See ftrace_enable_ftrace_graph_caller. The patched instruction is:
+#	j	.+2
+ENTRY(ftrace_graph_caller)
+	j	ftrace_graph_caller_end
 	lg	%r2,168(%r15)
 	lg	%r3,272(%r15)
-ENTRY(ftrace_graph_caller)
-# The bras instruction gets runtime patched to call prepare_ftrace_return.
-# See ftrace_enable_ftrace_graph_caller. The patched instruction is:
-#	bras	%r14,prepare_ftrace_return
-	bras	%r14,0f
-0:	stg	%r2,168(%r15)
+	brasl	%r14,prepare_ftrace_return
+	stg	%r2,168(%r15)
+ftrace_graph_caller_end:
+	.globl	ftrace_graph_caller_end
 #endif
 	aghi	%r15,160
 	lmg	%r2,%r5,32(%r15)
-- 
1.8.5.5

