Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaDZTDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 15:03:21 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:57540 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaDZTDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 15:03:20 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf x86: Fix perf to use non-executable stack, again
Date: Sat, 26 Apr 2014 21:02:45 +0200
Message-Id: <1398538965-10620-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/tests/regs_load.S is missing the linker note about the stack
requirements, therefore making the linker fall back to an executable
stack. As this object gets linked against the final perf binary, it'll
needlessly end up with an executable stack.

Fix this by adding the appropriate linker note.

Fixes: 3c8b06f981 ("perf tests x86: Introduce perf_regs_load function")
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>

---
 tools/perf/arch/x86/tests/regs_load.S |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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
-- 
1.7.10.4

