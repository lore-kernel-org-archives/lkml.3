Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3JOFOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3JOFOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:31 -0400
Date: Mon, 14 Oct 2013 22:14:17 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8295d4e27262dc49177e70dcc8ba34fa26343cf2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: 'dwarf
 '
Git-Commit-ID: 8295d4e27262dc49177e70dcc8ba34fa26343cf2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8295d4e27262dc49177e70dcc8ba34fa26343cf2
Gitweb:     http://git.kernel.org/tip/8295d4e27262dc49177e70dcc8ba34fa26343cf2
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 10:35:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:36 +0200

tools/perf/build: Split out feature check: 'dwarf'

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
