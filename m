Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaKFWyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:54:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaKFWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/162] MIPS: ftrace: Fix a microMIPS build problem
Date: Thu,  6 Nov 2014 14:35:59 -0800
Message-Id: <1415313426-9622-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/include/asm/ftrace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index ce35c9a..370ae7c 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -24,7 +24,7 @@ do {							\
 	asm volatile (					\
 		"1: " load " %[" STR(dst) "], 0(%[" STR(src) "])\n"\
 		"   li %[" STR(error) "], 0\n"		\
-		"2:\n"					\
+		"2: .insn\n"				\
 							\
 		".section .fixup, \"ax\"\n"		\
 		"3: li %[" STR(error) "], 1\n"		\
@@ -46,7 +46,7 @@ do {						\
 	asm volatile (				\
 		"1: " store " %[" STR(src) "], 0(%[" STR(dst) "])\n"\
 		"   li %[" STR(error) "], 0\n"	\
-		"2:\n"				\
+		"2: .insn\n"			\
 						\
 		".section .fixup, \"ax\"\n"	\
 		"3: li %[" STR(error) "], 1\n"	\
-- 
1.9.1

