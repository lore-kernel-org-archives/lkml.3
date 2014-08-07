Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaHGPD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:03:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53929 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbaHGPDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:03:38 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Doug Anderson <dianders@chromium.org>,
        Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/8] arm: kgdb: Handle read-only text / modules
Date: Thu,  7 Aug 2014 08:01:51 -0700
Message-Id: <1407423713-4160-7-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407423713-4160-1-git-send-email-keescook@chromium.org>
References: <1407423713-4160-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

Handle the case where someone has set the text segment of the kernel
as read-only by using the newly introduced "patch" mechanism.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/Makefile |  2 +-
 arch/arm/kernel/kgdb.c   | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

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
index a74b53c1b7df..b2b9ccb6be59 100644
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
@@ -244,6 +248,32 @@ void kgdb_arch_exit(void)
 	unregister_die_notifier(&kgdb_notifier);
 }
 
+int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
+{
+	int err;
+
+	/* patch_text() only supports int-sized breakpoints */
+	if (sizeof(int) != BREAK_INSTR_SIZE)
+		return -EINVAL;
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

