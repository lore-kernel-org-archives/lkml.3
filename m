Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3JNUxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:53:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38416 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3JNUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 013/161] tools/perf/build: Split out feature check: 'dwarf'
Date: Mon, 14 Oct 2013 17:00:02 -0300
Message-Id: <1381780950-25642-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-dsx0fn9mjwfprizboANvtuup@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                    | 4 ++--
 tools/perf/config/feature-checks/Makefile     | 4 ++++
 tools/perf/config/feature-checks/test-dwarf.c | 9 +++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-dwarf.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8cd0fd82967c..89630b8c8d59 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -110,6 +110,7 @@ FEATURE_TESTS =				\
 	bionic				\
 	libelf				\
 	glibc				\
+	dwarf				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -190,8 +191,7 @@ else
       LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
     endif
 
-    FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
-    ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
+    ifneq ($(feature-dwarf), 1)
       msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
       NO_DWARF := 1
     endif # Dwarf support
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index c0569c7edb89..566a71dd6168 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -8,6 +8,7 @@ FILES=					\
 	test-bionic			\
 	test-libelf			\
 	test-glibc			\
+	test-dwarf			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -42,6 +43,9 @@ test-libelf:
 test-glibc:
 	$(BUILD)
 
+test-dwarf:
+	$(BUILD) -ldw
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-dwarf.c b/tools/perf/config/feature-checks/test-dwarf.c
new file mode 100644
index 000000000000..783dfcd9a5c4
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-dwarf.c
@@ -0,0 +1,9 @@
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+
+int main(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+	return (long)dbg;
+}
-- 
1.8.1.4

