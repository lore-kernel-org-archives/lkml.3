Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaHOL7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:59:44 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:58019 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHOL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:59:43 -0400
Date: Fri, 15 Aug 2014 13:59:36 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] s390/ftrace: optimize patched mcount calling code
Message-ID: <20140815115936.GC4215@osiris>
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
x-cbid: 14081511-4966-0000-0000-00000109200C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can skip executing the first "stg" instruction of the patched
and disabled mcount code in function tracer enabled kernels.
This saves one instruction per function.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/ftrace.h |  2 +-
 arch/s390/kernel/ftrace.c      | 16 ++++++++--------
 scripts/recordmcount.c         |  2 +-
 scripts/recordmcount.pl        |  2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index bf246dae1367..4b264caa0704 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -18,7 +18,7 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_64BIT
-#define MCOUNT_INSN_SIZE  12
+#define MCOUNT_INSN_SIZE  18
 #else
 #define MCOUNT_INSN_SIZE  22
 #endif
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 54d6493c4a56..ae4141fbcb07 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -25,22 +25,22 @@ void ftrace_enable_insn(void);
 #ifdef CONFIG_64BIT
 /*
  * The 64-bit mcount code looks like this:
- *	stg	%r14,8(%r15)		# offset 0
+ * >	stg	%r14,8(%r15)		# offset 0
  * >	larl	%r1,<&counter>		# offset 6
  * >	brasl	%r14,_mcount		# offset 12
  *	lg	%r14,8(%r15)		# offset 18
- * Total length is 24 bytes. The middle two instructions of the mcount
+ * Total length is 24 bytes. The first three instructions of the mcount
  * block get overwritten by ftrace_make_nop / ftrace_make_call.
  * The 64-bit enabled ftrace code block looks like this:
- *	stg	%r14,8(%r15)		# offset 0
+ * >	stg	%r14,8(%r15)		# offset 0
  * >	lg	%r1,__LC_FTRACE_FUNC	# offset 6
  * >	lgr	%r0,%r0			# offset 12
  * >	basr	%r14,%r1		# offset 16
  *	lg	%r14,8(%15)		# offset 18
  * The return points of the mcount/ftrace function have the same offset 18.
  * The 64-bit disable ftrace code block looks like this:
- *	stg	%r14,8(%r15)		# offset 0
- * >	jg	.+18			# offset 6
+ * >	jg	.+24			# offset 6
+ * >	lg	%r1,__LC_FTRACE_FUNC	# offset 6
  * >	lgr	%r0,%r0			# offset 12
  * >	basr	%r14,%r1		# offset 16
  *	lg	%r14,8(%15)		# offset 18
@@ -50,13 +50,13 @@ void ftrace_enable_insn(void);
 asm(
 	"	.align	4\n"
 	"ftrace_disable_code:\n"
-	"	jg	0f\n"
+	"	jg	.+24\n"
+	"	lg	%r1,"__stringify(__LC_FTRACE_FUNC)"\n"
 	"	lgr	%r0,%r0\n"
 	"	basr	%r14,%r1\n"
-	"0:\n"
 	"	.align	4\n"
 	"ftrace_enable_insn:\n"
-	"	lg	%r1,"__stringify(__LC_FTRACE_FUNC)"\n");
+	"	stg	%r14,8(%r15)\n");
 
 #define FTRACE_INSN_SIZE	6
 
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 650ecc83d7d7..efca581d8553 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -408,7 +408,7 @@ do_file(char const *const fname)
 		}
 		if (w2(ghdr->e_machine) == EM_S390) {
 			reltype = R_390_64;
-			mcount_adjust_64 = -8;
+			mcount_adjust_64 = -14;
 		}
 		if (w2(ghdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_64;
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 397b6b84e8c5..2e260fc27a60 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -250,7 +250,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
-    $mcount_adjust = -8;
+    $mcount_adjust = -14;
     $alignment = 8;
     $type = ".quad";
     $ld .= " -m elf64_s390";
-- 
1.8.5.5

