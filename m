Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaHMRHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:07:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36525 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbaHMRHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:07:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 6/8] arm: kgdb: Handle read-only text / modules
Date: Wed, 13 Aug 2014 10:06:31 -0700
Message-Id: <1407949593-16121-7-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407949593-16121-1-git-send-email-keescook@chromium.org>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

Handle the case where someone has set the text segment of the kernel
as read-only by using the newly introduced "patch" mechanism.

Signed-off-by: Doug Anderson <dianders@chromium.org>
[kees: switched structure size check to BUILD_BUG_ON (sboyd)]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/Makefile |  2 +-
 arch/arm/kernel/kgdb.c   | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f83d0e..70b730766330 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -67,7 +67,7 @@ test-kprobes-objs		+= kprobes-test-arm.o
 endif
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
 obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
-obj-$(CONFIG_KGDB)		+= kgdb.o
+obj-$(CONFIG_KGDB)		+= kgdb.o patch.o
 obj-$(CONFIG_ARM_UNWIND)	+= unwind.o
 obj-$(CONFIG_HAVE_TCM)		+= tcm.o
 obj-$(CONFIG_OF)		+= devtree.o
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index a74b53c1b7df..07db2f8a1b45 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -12,8 +12,12 @@
 #include <linux/irq.h>
 #include <linux/kdebug.h>
 #include <linux/kgdb.h>
+#include <linux/uaccess.h>
+
 #include <asm/traps.h>
 
+#include "patch.h"
+
 struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {
 	{ "r0", 4, offsetof(struct pt_regs, ARM_r0)},
@@ -244,6 +248,31 @@ void kgdb_arch_exit(void)
 	unregister_die_notifier(&kgdb_notifier);
 }
 
+int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
+{
+	int err;
+
+	/* patch_text() only supports int-sized breakpoints */
+	BUILD_BUG_ON(sizeof(int) != BREAK_INSTR_SIZE);
+
+	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+				BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+
+	patch_text((void *)bpt->bpt_addr,
+		   *(unsigned int *)arch_kgdb_ops.gdb_bpt_instr);
+
+	return err;
+}
+
+int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
+{
+	patch_text((void *)bpt->bpt_addr, *(unsigned int *)bpt->saved_instr);
+
+	return 0;
+}
+
 /*
  * Register our undef instruction hooks with ARM undef core.
  * We regsiter a hook specifically looking for the KGB break inst
-- 
1.9.1

