Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3JGMHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:07:03 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45689 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3JGL6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:05 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 19/50] tools/perf/build: Split out feature check: 'libaudit'
Date: Mon,  7 Oct 2013 13:56:12 +0200
Message-Id: <1381147003-2574-20-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-orhejqtjao3vf4wxwBUdzhaz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 6 +++---
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libaudit.c | 7 +++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 890f264..e82e0b8 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -114,6 +114,7 @@ FEATURE_TESTS =				\
 	libelf-mmap			\
 	libelf-getphdrnum		\
 	libunwind			\
+	libaudit			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -240,7 +241,7 @@ ifneq ($(ARCH),x86)
 endif
 
 ifndef NO_LIBUNWIND
-  ifeq ($(feature-libunwind), 1)
+  ifneq ($(feature-libunwind), 1)
     msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
     NO_LIBUNWIND := 1
   endif
@@ -254,8 +255,7 @@ ifndef NO_LIBUNWIND
 endif
 
 ifndef NO_LIBAUDIT
-  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
-  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+  ifneq ($(feature-libaudit), 1)
     msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
     NO_LIBAUDIT := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d6d9570..8e49fa0 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -12,6 +12,7 @@ FILES=					\
 	test-libelf-mmap		\
 	test-libelf-getphdrnum		\
 	test-libunwind			\
+	test-libaudit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -61,6 +62,9 @@ test-libnuma:
 test-libunwind:
 	$(BUILD) -lunwind -lunwind-x86_64 -lelf
 
+test-libaudit:
+	$(BUILD) -laudit
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
new file mode 100644
index 0000000..854a65d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -0,0 +1,7 @@
+#include <libaudit.h>
+
+int main(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+	return audit_open();
+}
-- 
1.7.11.7

