Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3JOFOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3JOFOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:37 -0400
Date: Mon, 14 Oct 2013 22:14:08 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-e12762cfd9b4ec8f9bb5863eea403253175df9f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: 'glibc
 '
Git-Commit-ID: e12762cfd9b4ec8f9bb5863eea403253175df9f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e12762cfd9b4ec8f9bb5863eea403253175df9f1
Gitweb:     http://git.kernel.org/tip/e12762cfd9b4ec8f9bb5863eea403253175df9f1
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 10:34:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:35 +0200

tools/perf/build: Split out feature check: 'glibc'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-nqnnsptw7ivOzhzbNjiun7ds@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                    | 4 ++--
 tools/perf/config/feature-checks/Makefile     | 4 ++++
 tools/perf/config/feature-checks/test-glibc.c | 8 ++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6865428..8cd0fd8 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -109,6 +109,7 @@ FEATURE_TESTS =				\
 	fortify-source			\
 	bionic				\
 	libelf				\
+	glibc				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -166,8 +167,7 @@ ifdef NO_LIBELF
   NO_LIBUNWIND := 1
 else
   ifeq ($(feature-libelf), 0)
-    FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
-    ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+    ifeq ($(feature-glibc), 1)
       LIBC_SUPPORT := 1
     endif
     ifeq ($(BIONIC),1)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 789a38d..c0569c7 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -7,6 +7,7 @@ FILES=					\
 	test-fortify-source		\
 	test-bionic			\
 	test-libelf			\
+	test-glibc			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -38,6 +39,9 @@ test-bionic:
 test-libelf:
 	$(BUILD) -lelf
 
+test-glibc:
+	$(BUILD)
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-glibc.c b/tools/perf/config/feature-checks/test-glibc.c
new file mode 100644
index 0000000..13c66a5
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-glibc.c
@@ -0,0 +1,8 @@
+#include <gnu/libc-version.h>
+
+int main(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+
