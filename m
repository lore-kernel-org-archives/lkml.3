Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3ITJ5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:57:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3ITJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:56:57 -0400
Date: Fri, 20 Sep 2013 02:56:19 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-e955d5c434009b661dbb200c601254b0c2d9940a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1379080170-6608-1-git-send-email-adrian.hunter@intel.com>
References: <1379080170-6608-1-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix compile with libelf without get_phdrnum
Git-Commit-ID: e955d5c434009b661dbb200c601254b0c2d9940a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:56:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e955d5c434009b661dbb200c601254b0c2d9940a
Gitweb:     http://git.kernel.org/tip/e955d5c434009b661dbb200c601254b0c2d9940a
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 13 Sep 2013 16:49:30 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Sep 2013 11:32:17 -0300

perf tools: Fix compile with libelf without get_phdrnum

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
