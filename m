Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3JOFOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab3JOFN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:58 -0400
Date: Mon, 14 Oct 2013 22:13:42 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-78e9d6550807aedfc1f81c199bd4681c09d80ac5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 bionic'
Git-Commit-ID: 78e9d6550807aedfc1f81c199bd4681c09d80ac5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:13:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78e9d6550807aedfc1f81c199bd4681c09d80ac5
Gitweb:     http://git.kernel.org/tip/78e9d6550807aedfc1f81c199bd4681c09d80ac5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:11:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:33 +0200

tools/perf/build: Split out feature check: 'bionic'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-xjfVewprrfhlo2wuzbnpVb1k@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 12 +++++++-----
 tools/perf/config/feature-checks/Makefile      |  4 ++++
 tools/perf/config/feature-checks/test-bionic.c |  6 ++++++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7a614f9..09e2ecc 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -107,6 +107,7 @@ FEATURE_TESTS =				\
 	stackprotector			\
 	volatile-register-var		\
 	fortify-source			\
+	bionic				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -150,12 +151,13 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-  BIONIC := 1
-  EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
-  EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  $(feature_check,bionic)
+  ifeq ($(feature-bionic), 1)
+    BIONIC := 1
+    EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+    EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  endif
 endif
-endif # NO_BIONIC
 
 ifdef NO_LIBELF
   NO_DWARF := 1
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 529317e..191df97 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -5,6 +5,7 @@ FILES=					\
 	test-stackprotector		\
 	test-volatile-register-var	\
 	test-fortify-source		\
+	test-bionic			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -30,6 +31,9 @@ test-volatile-register-var:
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
+test-bionic:
+	$(BUILD)
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-bionic.c b/tools/perf/config/feature-checks/test-bionic.c
new file mode 100644
index 0000000..eac24e9
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-bionic.c
@@ -0,0 +1,6 @@
+#include <android/api-level.h>
+
+int main(void)
+{
+	return __ANDROID_API__;
+}
