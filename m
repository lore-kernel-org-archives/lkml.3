Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbaD3OcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52352 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759220AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 14/16] kgr: x86: refuse to build without fentry support
Date: Wed, 30 Apr 2014 16:30:47 +0200
Message-Id: <1398868249-26169-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

The only reliable way for function redirection through ftrace_ops (when
modifying pt_regs->rip in the handler) is fentry.

The alternative -- mcount -- is problematic in several ways. Namely the
caller's function prologue (that has already been executed by the time
mcount callsite has been reached) is not known to the callee, and can be
completely incompatible to the calee, resulting in a havoc on return from
the function.

fentry doesn't suffer from this, as it's located at the very beginning of
the function, even before prologue has been executed, and therefore callee
is the owner of both function prologue and epilogue.

Fixing mcount to properly fix everything up would be non-trivial, and
Steven is not in favor of doing that.

Both kGraft and upstream kernel (patch to be submitted) should error out
when this unsupported and non-working configuration is detected.

According to Michael Matz, the -mfentry gcc option is x86 specific. Other
architectures insert the respective profile calls before the prologue by
default.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/kgr.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kgr.h b/arch/x86/include/asm/kgr.h
index f36661681b33..8a3819886e4b 100644
--- a/arch/x86/include/asm/kgr.h
+++ b/arch/x86/include/asm/kgr.h
@@ -1,6 +1,10 @@
 #ifndef ASM_KGR_H
 #define ASM_KGR_H
 
+#ifndef CC_USING_FENTRY
+#error Your compiler has to support -mfentry for kGraft to work on x86
+#endif
+
 #include <linux/linkage.h>
 
 /*
-- 
1.9.2

