Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaIZRCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:02:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608AbaIZRCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:02:33 -0400
From: Will Deacon <will.deacon@arm.com>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] perf tools: fix build breakage on arm and arm64 targets
Date: Fri, 26 Sep 2014 18:01:58 +0100
Message-Id: <1411750918-25220-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to build the perf tool on arm or arm64 targets results in the
following failure:

arch/arm/util/unwind-libunwind.c: In function ‘libunwind__arch_reg_id’:
arch/arm/util/unwind-libunwind.c:43:3: error: implicit declaration of function ‘pr_err’ [-Werror=implicit-function-declaration]
   pr_err("unwind: invalid reg id %d\n", regnum);
   ^
This is due to commit 84f5d36f4866 ("perf tools: Move pr_* debug macros
into debug object") moving the pr_* macros into a new header file, but
failing to update architectures other than x86.

This patch adds the missing includes, and fixes the build again.

Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 tools/perf/arch/arm/tests/dwarf-unwind.c      | 1 +
 tools/perf/arch/arm/util/unwind-libunwind.c   | 1 +
 tools/perf/arch/arm64/util/unwind-libunwind.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
index 9f870d27cb39..62eff847f91c 100644
--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -3,6 +3,7 @@
 #include "thread.h"
 #include "map.h"
 #include "event.h"
+#include "debug.h"
 #include "tests/tests.h"
 
 #define STACK_SIZE 8192
diff --git a/tools/perf/arch/arm/util/unwind-libunwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
index 729ed69a6664..62c397ed3d97 100644
--- a/tools/perf/arch/arm/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
diff --git a/tools/perf/arch/arm64/util/unwind-libunwind.c b/tools/perf/arch/arm64/util/unwind-libunwind.c
index 436ee43859dc..a87afa91a99e 100644
--- a/tools/perf/arch/arm64/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
-- 
2.1.0

