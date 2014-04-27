Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaD0QvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 12:51:21 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54281 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaD0QvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 12:51:20 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH v2] perf x86: Fix perf to use non-executable stack, again
Date: Sun, 27 Apr 2014 18:51:05 +0200
Message-Id: <1398617466-22749-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/tests/regs_load.S is missing the linker note about the stack
requirements, therefore making the linker fall back to an executable
stack. As this object gets linked against the final perf binary, it'll
needlessly end up with an executable stack. Fix this by adding the
appropriate linker note.

Also add a global linker flag to prevent future regressions, as
suggested by Jiri. This way perf won't get an executable stack even if
we fail to add the .GNU-stack linker note to future assembler files.
Though, doing so might create regressions the other way around, when
(statically) linking against libraries needing an executable stack.
But, apparently, regressing in that direction is wanted as it is an
indicator of poor code quality -- or just missing linker notes.

Fixes: 3c8b06f981 ("perf tests x86: Introduce perf_regs_load function")
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/arch/x86/tests/regs_load.S |    8 +++++++-
 tools/perf/config/Makefile            |    4 ++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
index 99167bf644..60875d5c55 100644
--- a/tools/perf/arch/x86/tests/regs_load.S
+++ b/tools/perf/arch/x86/tests/regs_load.S
@@ -1,4 +1,3 @@
-
 #include <linux/linkage.h>
 
 #define AX	 0
@@ -90,3 +89,10 @@ ENTRY(perf_regs_load)
 	ret
 ENDPROC(perf_regs_load)
 #endif
+
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ee21fa95eb..d529291287 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -109,6 +109,10 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
+# Enforce a non-executable stack, as we may regress (again) in the future by
+# adding assembler files missing the .GNU-stack linker note.
+LDFLAGS += -Wl,-z,noexecstack
+
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifneq ($(OUTPUT),)
-- 
1.7.10.4

