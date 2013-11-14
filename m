Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3KNRHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:07:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3KNRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:07:44 -0500
Date: Thu, 14 Nov 2013 09:06:38 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-e310718d0e83aeb9969264dc577c45db16d9104d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        jean.pihet@linaro.org, rmk@arm.linux.org.uk, jolsa@redhat.com,
        acme@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        jean.pihet@linaro.org, rmk@arm.linux.org.uk, jolsa@redhat.com,
        acme@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools/perf/build:
  Fix feature-libunwind-debug-frame handling
Git-Commit-ID: e310718d0e83aeb9969264dc577c45db16d9104d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 09:06:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e310718d0e83aeb9969264dc577c45db16d9104d
Gitweb:     http://git.kernel.org/tip/e310718d0e83aeb9969264dc577c45db16d9104d
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 14 Nov 2013 08:25:24 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Nov 2013 18:00:45 +0100

tools/perf/build: Fix feature-libunwind-debug-frame handling

Set feature-libunwind-debug-frame. We don't want it in
CORE_FEATURE_TESTS because it's not the generic case, but we
need to set it in the !feature-libunwind case.

Also, because x86 distributions typically don't have
dwarf_find_debug_frame() unwinding method:

  test-libunwind-debug-frame.c:(.text+0x31): undefined reference to `_Ux86_64_dwarf_find_debug_frame'

Restrict this new API to ARM for the time being.

With this patch test-all.c works again, so repeat perf builds
are  fast again:

  comet:~/tip> perf stat --null --repeat 5 make -C tools/perf/
  [...]

       0,452899660 seconds time elapsed                                          ( +-  0,11% )

While with before it was:

  comet:~/tip> perf stat --null --repeat 5 make -C tools/perf/
  [...]

       1,674001829 seconds time elapsed                                          ( +-  0,16% )

[ Includes fix to config/feature-checks/Makefile from Will Deacon. ]

Tested-by: Will Deacon <will.deacon@arm.com>
Tested-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-scsoctqzmou3rpkixCHezy9e@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                  | 10 ++++++++--
 tools/perf/config/feature-checks/Makefile   |  3 +++
 tools/perf/config/feature-checks/test-all.c |  4 ----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 861379e..f7d11a8 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -329,8 +329,14 @@ ifndef NO_LIBUNWIND
     msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
     NO_LIBUNWIND := 1
   else
-    ifneq ($(feature-libunwind-debug-frame), 1)
-      msg := $(warning No debug_frame support found in libunwind);
+    ifeq ($(ARCH),arm)
+      $(call feature_check,libunwind-debug-frame)
+      ifneq ($(feature-libunwind-debug-frame), 1)
+        msg := $(warning No debug_frame support found in libunwind);
+        CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
+      endif
+    else
+      # non-ARM has no dwarf_find_debug_frame() function:
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
   endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index e8e195f..87e7900 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -76,6 +76,9 @@ test-libnuma:
 test-libunwind:
 	$(BUILD) $(LIBUNWIND_LIBS) -lelf
 
+test-libunwind-debug-frame:
+	$(BUILD) $(LIBUNWIND_LIBS) -lelf
+
 test-libaudit:
 	$(BUILD) -laudit
 
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 799865b..59e7a70 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -49,10 +49,6 @@
 # include "test-libunwind.c"
 #undef main
 
-#define main main_test_libunwind_debug_frame
-# include "test-libunwind-debug-frame.c"
-#undef main
-
 #define main main_test_libaudit
 # include "test-libaudit.c"
 #undef main
