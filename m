Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3JOFVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:21:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3JOFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:19:47 -0400
Date: Mon, 14 Oct 2013 22:19:23 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-1c2d1d8cf4dbef33b8c6af6888bed2f4e659220e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Make sure autodep feature binaries honor the O= setting
Git-Commit-ID: 1c2d1d8cf4dbef33b8c6af6888bed2f4e659220e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:19:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c2d1d8cf4dbef33b8c6af6888bed2f4e659220e
Gitweb:     http://git.kernel.org/tip/1c2d1d8cf4dbef33b8c6af6888bed2f4e659220e
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 3 Oct 2013 15:05:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:00 +0200

tools/perf/build: Make sure autodep feature binaries honor the O= setting

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
index e80ffe8..3d656e3 100644
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
@@ -138,7 +143,7 @@ CORE_FEATURE_TESTS =			\
 # to skip the print-out of the long features list if the file
 # existed before and after it was built:
 #
-ifeq ($(wildcard config/feature-checks/test-all),)
+ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
   test-all-failed := 1
 else
   test-all-failed := 0
@@ -168,7 +173,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
