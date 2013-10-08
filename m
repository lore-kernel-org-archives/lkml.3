Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3JHKY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:24:28 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59290 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3JHKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:18 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/52] tools/perf/build: Split out feature check: 'dwarf'
Date: Tue,  8 Oct 2013 12:10:43 +0200
Message-Id: <1381227082-22039-14-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8cd0fd8..89630b8 100644
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
index c0569c7..566a71d 100644
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
index 0000000..783dfcd
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
1.8.3.1

