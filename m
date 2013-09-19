Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3ISSlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:41:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43975 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3ISSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:40:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf tools: Fix compile with libelf without get_phdrnum
Date: Thu, 19 Sep 2013 15:40:28 -0300
Message-Id: <1379616032-13061-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379616032-13061-1-git-send-email-acme@infradead.org>
References: <1379616032-13061-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a feature check for get_phdrnum() and implement a replacement if it
is not present.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1379080170-6608-1-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 7f550c1..d5a8dd4 100644
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
1.8.1.4

