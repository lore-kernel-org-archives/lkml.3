Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab3J2QnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:43:23 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52888 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3J2QnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:43:21 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] tools/perf/build: Fix detection of non-core features
Date: Tue, 29 Oct 2013 10:43:15 -0600
Message-Id: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

feature_check needs to be invoked through call, and LDFLAGS may not be set
so quotes are needed.

Thanks to Jiri for spotting the quotes around LDFLAGS; that one was driving
me nuts with the upcoming timerfd feature detection.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 543aa953bab1..c82772207e6e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -96,7 +96,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS="$(LDFLAGS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -233,7 +233,7 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
-  $(feature_check,bionic)
+  $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
     BIONIC := 1
     EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
@@ -470,15 +470,15 @@ else
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
1.7.12.4 (Apple Git-37)

