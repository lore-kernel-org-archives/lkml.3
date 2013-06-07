Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3FGXGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:06:53 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44499 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3FGXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:54 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 23/31] mips/kvm: Hook into CP unusable exception handler.
Date: Fri,  7 Jun 2013 16:03:27 -0700
Message-Id: <1370646215-6543-24-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The MIPS VZ KVM code needs this to be able to manage the FPU.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/traps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index fca0a2f..2bdeb32 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -56,6 +56,7 @@
 #include <asm/types.h>
 #include <asm/stacktrace.h>
 #include <asm/uasm.h>
+#include <asm/kvm_mips_vz.h>
 
 extern void check_wait(void);
 extern asmlinkage void rollback_handle_int(void);
@@ -1045,6 +1046,13 @@ asmlinkage void do_cpu(struct pt_regs *regs)
 	int status;
 	unsigned long __maybe_unused flags;
 
+#ifdef CONFIG_KVM_MIPSVZ
+	if (test_tsk_thread_flag(current, TIF_GUESTMODE)) {
+		if (mipsvz_cp_unusable(regs))
+			return;
+	}
+#endif
+
 	die_if_kernel("do_cpu invoked from kernel context!", regs);
 
 	cpid = (regs->cp0_cause >> CAUSEB_CE) & 3;
-- 
1.7.11.7

