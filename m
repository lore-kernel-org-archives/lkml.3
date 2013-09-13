Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3IMNnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:43:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:30479 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573Ab3IMNnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,898,1371106800"; 
   d="scan'208";a="401177298"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf tools: fix compile with libelf without get_phdrnum
Date: Fri, 13 Sep 2013 16:49:30 +0300
Message-Id: <1379080170-6608-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a feature check for get_phdrnum() and implement
a replacement if it is not present.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/config/Makefile          |  3 +++
 tools/perf/config/feature-tests.mak |  9 +++++++++
 tools/perf/util/symbol-elf.c        | 16 ++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 214e17e..346ee92 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -180,6 +180,9 @@ FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
   CFLAGS += -DLIBELF_MMAP
 endif
+ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM),y)
+  CFLAGS += -DHAVE_ELF_GETPHDRNUM
+endif
 
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..6d3c04a 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -61,6 +61,15 @@ int main(void)
 }
 endef
 
+define SOURCE_ELF_GETPHDRNUM
+#include <libelf.h>
+int main(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
+endef
+
 ifndef NO_SLANG
 define SOURCE_SLANG
 #include <slang.h>
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a7b9ab5..a9c829b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -8,6 +8,22 @@
 #include "symbol.h"
 #include "debug.h"
 
+#ifndef HAVE_ELF_GETPHDRNUM
+static int elf_getphdrnum(Elf *elf, size_t *dst)
+{
+	GElf_Ehdr gehdr;
+	GElf_Ehdr *ehdr;
+
+	ehdr = gelf_getehdr(elf, &gehdr);
+	if (!ehdr)
+		return -1;
+
+	*dst = ehdr->e_phnum;
+
+	return 0;
+}
+#endif
+
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
 #endif
-- 
1.7.11.7

