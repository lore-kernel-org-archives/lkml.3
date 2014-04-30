Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422679AbaD3Ped (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252AbaD3PdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:20 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6/7] perf x86: Fix perf to use non-executable stack, again
Date: Wed, 30 Apr 2014 17:32:50 +0200
Message-Id: <1398871971-381-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

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

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1398617466-22749-1-git-send-email-minipli@googlemail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/x86/tests/regs_load.S | 8 +++++++-
 tools/perf/config/Makefile            | 4 ++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
index 99167bf..60875d5 100644
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
index a57d59e..802cf54 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -117,6 +117,10 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
+# Enforce a non-executable stack, as we may regress (again) in the future by
+# adding assembler files missing the .GNU-stack linker note.
+LDFLAGS += -Wl,-z,noexecstack
+
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifneq ($(OUTPUT),)
-- 
1.8.3.1

