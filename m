Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3JOFPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:15:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3JOFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:59 -0400
Date: Mon, 14 Oct 2013 22:14:44 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b7bcef6f8e61580e883672b6c97148d4f89e9874@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libelf-getphdrnum'
Git-Commit-ID: b7bcef6f8e61580e883672b6c97148d4f89e9874
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:14:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7bcef6f8e61580e883672b6c97148d4f89e9874
Gitweb:     http://git.kernel.org/tip/b7bcef6f8e61580e883672b6c97148d4f89e9874
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:35:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:37 +0200

tools/perf/build: Split out feature check: 'libelf-getphdrnum'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-wa9qstb8erbjreLxiHepzjfw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                | 5 +++--
 tools/perf/config/feature-checks/Makefile                 | 4 ++++
 tools/perf/config/feature-checks/test-libelf-getphdrnum.c | 7 +++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index bf1f021..718b476 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -112,6 +112,7 @@ FEATURE_TESTS =				\
 	glibc				\
 	dwarf				\
 	libelf-mmap			\
+	libelf-getphdrnum		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -207,7 +208,7 @@ ifndef NO_LIBELF
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
   endif
 
-  ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM_SUPPORT),y)
+  ifeq ($(feature-libelf-getphdrnum), 1)
     CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
   endif
 
@@ -230,7 +231,7 @@ ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
   ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
-  endif # try-cc
+  endif
 endif # NO_LIBELF
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index bf96e34..83b3a02 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -10,6 +10,7 @@ FILES=					\
 	test-glibc			\
 	test-dwarf			\
 	test-libelf-mmap		\
+	test-libelf-getphdrnum		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -50,6 +51,9 @@ test-dwarf:
 test-libelf-mmap:
 	$(BUILD) -lelf
 
+test-libelf-getphdrnum:
+	$(BUILD) -lelf
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
new file mode 100644
index 0000000..58eca53
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+#
+int main(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
