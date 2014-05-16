Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaEPIlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:41:42 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34797 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbaEPIld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:41:33 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/4] perf tools: Add libdw DWARF post unwind support for ARM
Date: Fri, 16 May 2014 10:41:12 +0200
Message-Id: <1400229672-16104-4-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1400229672-16104-1-git-send-email-jean.pihet@linaro.org>
References: <CAFrcx1mkE-N+DYUe0ZK06_BL1tsZvmyMHpAynnFkgZBqjghE5Q@mail.gmail.com>
 <1400229672-16104-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding libdw DWARF post unwind support, which is part
of elfutils-devel/libdw-dev package from version 0.158.

The new code is contained in unwin-libdw.c object, and
implements unwind__get_entries unwind interface function.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/arch/arm/Makefile            |  5 +++++
 tools/perf/arch/arm/util/unwind-libdw.c | 36 +++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)
 create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c

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
-- 
1.7.11.7

