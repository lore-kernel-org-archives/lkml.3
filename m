Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaEAGcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:32:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaEAGcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:32:24 -0400
Date: Wed, 30 Apr 2014 23:32:05 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-2cf9040714f3e63f94935c9f1ed4e5bc54265ddb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1398676935-6615-1-git-send-email-jolsa@kernel.org>
References: <1398676935-6615-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix bfd dependency libraries detection
Git-Commit-ID: 2cf9040714f3e63f94935c9f1ed4e5bc54265ddb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cf9040714f3e63f94935c9f1ed4e5bc54265ddb
Gitweb:     http://git.kernel.org/tip/2cf9040714f3e63f94935c9f1ed4e5bc54265ddb
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 23 Apr 2014 16:53:25 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 30 Apr 2014 16:48:50 +0200

perf tools: Fix bfd dependency libraries detection

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
