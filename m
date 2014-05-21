Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaEUF4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:56:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60591 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaEUF4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:56:20 -0400
Date: Tue, 20 May 2014 22:55:52 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-97eac381b113932bd7bd4a5c3c68b18e9ff7a2a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, jean.pihet@linaro.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, will.deacon@arm.com,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1400229672-16104-4-git-send-email-jean.pihet@linaro.org>
References: <1400229672-16104-4-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add libdw DWARF post unwind support for ARM
Git-Commit-ID: 97eac381b113932bd7bd4a5c3c68b18e9ff7a2a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97eac381b113932bd7bd4a5c3c68b18e9ff7a2a0
Gitweb:     http://git.kernel.org/tip/97eac381b113932bd7bd4a5c3c68b18e9ff7a2a0
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Fri, 16 May 2014 10:41:12 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 16 May 2014 11:39:29 +0200

perf tools: Add libdw DWARF post unwind support for ARM

Adding libdw DWARF post unwind support, which is part
of elfutils-devel/libdw-dev package from version 0.158.

The new code is contained in unwin-libdw.c object, and
implements unwind__get_entries unwind interface function.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1400229672-16104-4-git-send-email-jean.pihet@linaro.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/arm/Makefile            |  5 +++++
 tools/perf/arch/arm/util/unwind-libdw.c | 36 +++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 221f21d..09d6215 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -4,6 +4,11 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
+endif
+ifndef NO_LIBDW_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
+endif
+ifndef NO_DWARF_UNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/arm/util/unwind-libdw.c b/tools/perf/arch/arm/util/unwind-libdw.c
new file mode 100644
index 0000000..b4176c6
--- /dev/null
+++ b/tools/perf/arch/arm/util/unwind-libdw.c
@@ -0,0 +1,36 @@
+#include <elfutils/libdwfl.h>
+#include "../../util/unwind-libdw.h"
+#include "../../util/perf_regs.h"
+
+bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct regs_dump *user_regs = &ui->sample->user_regs;
+	Dwarf_Word dwarf_regs[PERF_REG_ARM_MAX];
+
+#define REG(r) ({						\
+	Dwarf_Word val = 0;					\
+	perf_reg_value(&val, user_regs, PERF_REG_ARM_##r);	\
+	val;							\
+})
+
+	dwarf_regs[0]  = REG(R0);
+	dwarf_regs[1]  = REG(R1);
+	dwarf_regs[2]  = REG(R2);
+	dwarf_regs[3]  = REG(R3);
+	dwarf_regs[4]  = REG(R4);
+	dwarf_regs[5]  = REG(R5);
+	dwarf_regs[6]  = REG(R6);
+	dwarf_regs[7]  = REG(R7);
+	dwarf_regs[8]  = REG(R8);
+	dwarf_regs[9]  = REG(R9);
+	dwarf_regs[10] = REG(R10);
+	dwarf_regs[11] = REG(FP);
+	dwarf_regs[12] = REG(IP);
+	dwarf_regs[13] = REG(SP);
+	dwarf_regs[14] = REG(LR);
+	dwarf_regs[15] = REG(PC);
+
+	return dwfl_thread_state_registers(thread, 0, PERF_REG_ARM_MAX,
+					   dwarf_regs);
+}
