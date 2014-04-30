Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbaD3PdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759187AbaD3PdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:18 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] perf tools: Fix bfd dependency libraries detection
Date: Wed, 30 Apr 2014 17:32:46 +0200
Message-Id: <1398871971-381-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's false assumption in the library detection code
assuming -liberty and -lz are always present once bfd
is detected. The fails on Ubuntu (14.04) as reported
by Ingo.

Forcing the bdf dependency libraries detection any
time bfd library is detected.

Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1398676935-6615-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/config/Makefile | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a71fb39..a57d59e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -194,7 +194,10 @@ VF_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd				\
 	libunwind-debug-frame		\
-	bionic
+	bionic				\
+	liberty				\
+	liberty-z			\
+	cplus-demangle
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -512,7 +515,21 @@ else
 endif
 
 ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd -lz -liberty
+  EXTLIBS += -lbfd
+
+  # call all detections now so we get correct
+  # status in VF output
+  $(call feature_check,liberty)
+  $(call feature_check,liberty-z)
+  $(call feature_check,cplus-demangle)
+
+  ifeq ($(feature-liberty), 1)
+    EXTLIBS += -liberty
+  else
+    ifeq ($(feature-liberty-z), 1)
+      EXTLIBS += -liberty -lz
+    endif
+  endif
 endif
 
 ifdef NO_DEMANGLE
@@ -523,15 +540,10 @@ else
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     ifneq ($(feature-libbfd), 1)
-      $(call feature_check,liberty)
-      ifeq ($(feature-liberty), 1)
-        EXTLIBS += -lbfd -liberty
-      else
-        $(call feature_check,liberty-z)
-        ifeq ($(feature-liberty-z), 1)
-          EXTLIBS += -lbfd -liberty -lz
-        else
-          $(call feature_check,cplus-demangle)
+      ifneq ($(feature-liberty), 1)
+        ifneq ($(feature-liberty-z), 1)
+          # we dont have neither HAVE_CPLUS_DEMANGLE_SUPPORT
+          # or any of 'bfd iberty z' trinity
           ifeq ($(feature-cplus-demangle), 1)
             EXTLIBS += -liberty
             CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
-- 
1.8.3.1

