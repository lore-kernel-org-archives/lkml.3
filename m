Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3JGL7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:59:53 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:35653 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab3JGL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:33 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 46/50] tools/perf/build: Make sure autodep feature binaries honor the O= setting
Date: Mon,  7 Oct 2013 13:56:39 +0200
Message-Id: <1381147003-2574-47-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo noticed that the feature-check binaries are generated in the
config/check-features/ directory even if O= is specified.

Implement $(OUTPUT) logic for config/check-features/Makefile.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-NLwlnv5prsubuey0vfocebym@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6ae1dc4..72404e2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -88,9 +88,14 @@ CFLAGS += -std=gnu99
 
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
+ifneq ($(OUTPUT),)
+  OUTPUT_FEATURES = $(OUTPUT)config/feature-checks/
+  $(shell mkdir -p $(OUTPUT_FEATURES))
+endif
+
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -137,7 +142,7 @@ CORE_FEATURE_TESTS =			\
 # to skip the print-out of the long features list if the file
 # existed before and after it was built:
 #
-ifeq ($(wildcard config/feature-checks/test-all),)
+ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
   test-all-failed := 1
 else
   test-all-failed := 0
@@ -167,7 +172,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
-- 
1.7.11.7

