Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3KEUKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:10:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3KEUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] tools/perf/build: Fix detection of non-core features
Date: Tue,  5 Nov 2013 17:09:54 -0300
Message-Id: <1383682201-19399-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

feature_check needs to be invoked through call, and LDFLAGS may not be
set so quotes are needed.

Thanks to Jiri for spotting the quotes around LDFLAGS; that one was
driving me nuts with the upcoming timerfd feature detection.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383064996-20933-1-git-send-email-dsahern@gmail.com
[ Fixed conflict with 8a0c4c2843d3 ("perf tools: Fix libunwind build and feature detection for 32-bit build") ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index be8bb9a77287..58b2d37ae23a 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -98,7 +98,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS="$(LDFLAGS)" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -235,7 +235,7 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
-  $(feature_check,bionic)
+  $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
     BIONIC := 1
     EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
@@ -479,15 +479,15 @@ else
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     ifneq ($(feature-libbfd), 1)
-      $(feature_check,liberty)
+      $(call feature_check,liberty)
       ifeq ($(feature-liberty), 1)
         EXTLIBS += -lbfd -liberty
       else
-        $(feature_check,liberty-z)
+        $(call feature_check,liberty-z)
         ifeq ($(feature-liberty-z), 1)
           EXTLIBS += -lbfd -liberty -lz
         else
-          $(feature_check,cplus-demangle)
+          $(call feature_check,cplus-demangle)
           ifeq ($(feature-cplus-demangle), 1)
             EXTLIBS += -liberty
             CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
-- 
1.8.1.4

