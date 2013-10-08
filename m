Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3JHKNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:13:14 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:56983 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3JHKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:51 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 52/52] tools/perf/build: Pass through LDFLAGS to feature tests
Date: Tue,  8 Oct 2013 12:11:22 +0200
Message-Id: <1381227082-22039-53-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern reported that when passing in LDFLAGS=-static then
the feature checks still succeed - causing build failures down
the line because the static libraries are missing.

Solve this by passing through LDFLAGS to the feature-check
Makefile.

Reported-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20131007155129.GA1066@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                | 4 ++--
 tools/perf/config/feature-checks/Makefile | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 593983f..c98ca34 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -95,7 +95,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -173,7 +173,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 69c5f63..604d55c 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -32,7 +32,7 @@ CC := $(CC) -MD
 
 all: $(FILES)
 
-BUILD = $(CC) -o $(OUTPUT)$@ $@.c
+BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 
 ###############################
 
-- 
1.8.3.1

