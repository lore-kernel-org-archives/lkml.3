Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3KFFnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:43:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44222 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3KFFnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:43:40 -0500
Date: Tue, 5 Nov 2013 21:43:25 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-5febff0066b8111785d58903b54d414e9ec6a3d0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
References: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Fix detection of non-core features
Git-Commit-ID: 5febff0066b8111785d58903b54d414e9ec6a3d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 05 Nov 2013 21:43:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5febff0066b8111785d58903b54d414e9ec6a3d0
Gitweb:     http://git.kernel.org/tip/5febff0066b8111785d58903b54d414e9ec6a3d0
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 29 Oct 2013 10:43:15 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Nov 2013 10:08:03 -0300

tools/perf/build: Fix detection of non-core features

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
index be8bb9a..58b2d37 100644
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
