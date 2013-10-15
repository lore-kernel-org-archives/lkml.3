Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3JOFOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3JOFOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:50 -0400
Date: Mon, 14 Oct 2013 22:14:35 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8869b17ee0bdd0da3d1f7d7ced284ab444c2c6d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libelf-mmap'
Git-Commit-ID: 8869b17ee0bdd0da3d1f7d7ced284ab444c2c6d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8869b17ee0bdd0da3d1f7d7ced284ab444c2c6d8
Gitweb:     http://git.kernel.org/tip/8869b17ee0bdd0da3d1f7d7ced284ab444c2c6d8
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 15:02:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:37 +0200

tools/perf/build: Split out feature check: 'libelf-mmap'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-9fxnxjcmrgbSvipxlwsdQ8fg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                          | 6 +++---
 tools/perf/config/feature-checks/Makefile                           | 4 ++++
 .../config/feature-checks/{test-libelf.c => test-libelf-mmap.c}     | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8a27de2..bf1f021 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -111,6 +111,7 @@ FEATURE_TESTS =				\
 	libelf				\
 	glibc				\
 	dwarf				\
+	libelf-mmap			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -202,7 +203,7 @@ ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
   FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
-  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+  ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif
 
@@ -227,8 +228,7 @@ endif # NO_LIBELF
 
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
-  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DHAVE_LIBELF_MMAP_SUPPORT),y)
+  ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif # try-cc
 endif # NO_LIBELF
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 566a71d..bf96e34 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -9,6 +9,7 @@ FILES=					\
 	test-libelf			\
 	test-glibc			\
 	test-dwarf			\
+	test-libelf-mmap		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -46,6 +47,9 @@ test-glibc:
 test-dwarf:
 	$(BUILD) -ldw
 
+test-libelf-mmap:
+	$(BUILD) -lelf
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-libelf.c b/tools/perf/config/feature-checks/test-libelf-mmap.c
similarity index 54%
copy from tools/perf/config/feature-checks/test-libelf.c
copy to tools/perf/config/feature-checks/test-libelf-mmap.c
index 1a08f97..1c64815 100644
--- a/tools/perf/config/feature-checks/test-libelf.c
+++ b/tools/perf/config/feature-checks/test-libelf-mmap.c
@@ -1,7 +1,7 @@
 #include <libelf.h>
-
+#
 int main(void)
 {
-	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
 	return (long)elf;
 }
