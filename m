Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3JGL6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:14 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39114 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab3JGL6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:06 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 20/50] tools/perf/build: Split out feature check: 'libslang'
Date: Mon,  7 Oct 2013 13:56:13 +0200
Message-Id: <1381147003-2574-21-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-FGmpkydfwqlkaw7yy8ewjpza@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 6 +++---
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libslang.c | 6 ++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e82e0b8..5bd4b87 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -115,6 +115,7 @@ FEATURE_TESTS =				\
 	libelf-getphdrnum		\
 	libunwind			\
 	libaudit			\
+	libslang			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -269,8 +270,7 @@ ifdef NO_NEWT
 endif
 
 ifndef NO_SLANG
-  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+  ifneq ($(feature-libslang), 1)
     msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
     NO_SLANG := 1
   else
@@ -283,7 +283,7 @@ endif
 
 ifndef NO_GTK2
   FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+  ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8e49fa0..c9b15b0 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -13,6 +13,7 @@ FILES=					\
 	test-libelf-getphdrnum		\
 	test-libunwind			\
 	test-libaudit			\
+	test-libslang			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -65,6 +66,9 @@ test-libunwind:
 test-libaudit:
 	$(BUILD) -laudit
 
+test-libslang:
+	$(BUILD) -I/usr/include/slang -lslang
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libslang.c b/tools/perf/config/feature-checks/test-libslang.c
new file mode 100644
index 0000000..22ff22e
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libslang.c
@@ -0,0 +1,6 @@
+#include <slang.h>
+
+int main(void)
+{
+	return SLsmg_init_smg();
+}
-- 
1.7.11.7

