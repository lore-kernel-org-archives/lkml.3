Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3JOFOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3JOFON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:13 -0400
Date: Mon, 14 Oct 2013 22:13:59 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8f7f8005f526c23d3e5537f5ab68c1c3fb422453@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libelf'
Git-Commit-ID: 8f7f8005f526c23d3e5537f5ab68c1c3fb422453
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f7f8005f526c23d3e5537f5ab68c1c3fb422453
Gitweb:     http://git.kernel.org/tip/8f7f8005f526c23d3e5537f5ab68c1c3fb422453
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:20:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:34 +0200

tools/perf/build: Split out feature check: 'libelf'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-qznhihaasbysfqO7ffvRsf9q@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 4 ++--
 tools/perf/config/feature-checks/Makefile      | 4 ++++
 tools/perf/config/feature-checks/test-libelf.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a2e0e1b..6865428 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -108,6 +108,7 @@ FEATURE_TESTS =				\
 	volatile-register-var		\
 	fortify-source			\
 	bionic				\
+	libelf				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -164,8 +165,7 @@ ifdef NO_LIBELF
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
 else
-  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+  ifeq ($(feature-libelf), 0)
     FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
     ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
       LIBC_SUPPORT := 1
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 191df97..789a38d 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -6,6 +6,7 @@ FILES=					\
 	test-volatile-register-var	\
 	test-fortify-source		\
 	test-bionic			\
+	test-libelf			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -34,6 +35,9 @@ test-fortify-source:
 test-bionic:
 	$(BUILD)
 
+test-libelf:
+	$(BUILD) -lelf
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-libelf.c b/tools/perf/config/feature-checks/test-libelf.c
new file mode 100644
index 0000000..1a08f97
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
