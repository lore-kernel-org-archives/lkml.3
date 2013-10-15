Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab3JOFU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:20:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3JOFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:20:21 -0400
Date: Mon, 14 Oct 2013 22:20:07 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-aa4acf6cf102f639a2023b389ca8be8b8d9cad52@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20131007155129.GA1066@gmail.com>
References: <20131007155129.GA1066@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Pass through LDFLAGS to feature tests
Git-Commit-ID: aa4acf6cf102f639a2023b389ca8be8b8d9cad52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:20:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa4acf6cf102f639a2023b389ca8be8b8d9cad52
Gitweb:     http://git.kernel.org/tip/aa4acf6cf102f639a2023b389ca8be8b8d9cad52
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 17:51:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:03 +0200

tools/perf/build: Pass through LDFLAGS to feature tests

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
index 3d656e3..78f3b3e 100644
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
index e21bceb..8ecac19 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -32,7 +32,7 @@ CC := $(CC) -MD
 
 all: $(FILES)
 
-BUILD = $(CC) -o $(OUTPUT)$@ $@.c
+BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 
 ###############################
 
