Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640AbaKLBoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:44:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965251AbaKLBoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:44:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.14 094/203] MIPS: ftrace: Fix a microMIPS build problem
Date: Wed, 12 Nov 2014 10:16:04 +0900
Message-Id: <20141112011547.007475206@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit aedd153f5bb5b1f1d6d9142014f521ae2ec294cc upstream.

Code before the .fixup section needs to have the .insn directive.
This has no side effects on MIPS32/64 but it affects the way microMIPS
loads the address for the return label.

Fixes the following build problem:
mips-linux-gnu-ld: arch/mips/built-in.o: .fixup+0x4a0: Unsupported jump between
ISA modes; consider recompiling with interlinking enabled.
mips-linux-gnu-ld: final link failed: Bad value
Makefile:819: recipe for target 'vmlinux' failed

The fix is similar to 1658f914ff91c3bf ("MIPS: microMIPS:
Disable LL/SC and fix linker bug.")

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8117/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/ftrace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -24,7 +24,7 @@ do {							\
 	asm volatile (					\
 		"1: " load " %[tmp_dst], 0(%[tmp_src])\n"	\
 		"   li %[tmp_err], 0\n"			\
-		"2:\n"					\
+		"2: .insn\n"				\
 							\
 		".section .fixup, \"ax\"\n"		\
 		"3: li %[tmp_err], 1\n"			\
@@ -46,7 +46,7 @@ do {						\
 	asm volatile (				\
 		"1: " store " %[tmp_src], 0(%[tmp_dst])\n"\
 		"   li %[tmp_err], 0\n"		\
-		"2:\n"				\
+		"2: .insn\n"			\
 						\
 		".section .fixup, \"ax\"\n"	\
 		"3: li %[tmp_err], 1\n"		\


