Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaAGMsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaAGMrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:47:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 01/16] perf tools: Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all variables
Date: Tue,  7 Jan 2014 13:47:18 +0100
Message-Id: <1389098853-14466-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of explicitly adding same value into
FEATURE_CHECK_(C|LD)FLAGS-all variables we can
do that automatically.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/config/Makefile | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f2bc659..5d15b43 100644
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
1.8.3.1

