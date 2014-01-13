Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaAMUyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40404 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/38] perf tools: Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all variables
Date: Mon, 13 Jan 2014 17:47:17 -0300
Message-Id: <1389646059-24881-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Instead of explicitly adding same value into
FEATURE_CHECK_(C|LD)FLAGS-all variables we can do that automatically.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f2bc659d20af..5d15b43b03c6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -53,9 +53,6 @@ else
   FEATURE_CHECK_LDFLAGS-libunwind = $(LIBUNWIND_LDFLAGS)
   FEATURE_CHECK_CFLAGS-libunwind-debug-frame = $(LIBUNWIND_CFLAGS)
   FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
-  #  and the flags for the test-all case
-  FEATURE_CHECK_CFLAGS-all += $(LIBUNWIND_CFLAGS)
-  FEATURE_CHECK_LDFLAGS-all += $(LIBUNWIND_LDFLAGS)
 endif
 
 ifeq ($(NO_PERF_REGS),0)
@@ -152,6 +149,17 @@ CORE_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd
 
+# Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
+# If in the future we need per-feature checks/flags for features not
+# mentioned in this list we need to refactor this ;-).
+set_test_all_flags = $(eval $(set_test_all_flags_code))
+define set_test_all_flags_code
+  FEATURE_CHECK_CFLAGS-all  += $(FEATURE_CHECK_CFLAGS-$(1))
+  FEATURE_CHECK_LDFLAGS-all += $(FEATURE_CHECK_LDFLAGS-$(1))
+endef
+
+$(foreach feat,$(CORE_FEATURE_TESTS),$(call set_test_all_flags,$(feat)))
+
 #
 # So here we detect whether test-all was rebuilt, to be able
 # to skip the print-out of the long features list if the file
-- 
1.8.1.4

