Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3JGPw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:52:28 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41937 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab3JGPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:52:26 -0400
Date: Mon, 7 Oct 2013 17:51:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf/build: Pass through LDFLAGS to feature tests
Message-ID: <20131007155129.GA1066@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <5252BCB4.5030802@gmail.com>
 <20131007141100.GA21873@gmail.com>
 <5252D4DB.30302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252D4DB.30302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/7/13 8:11 AM, Ingo Molnar wrote:
> >These changes are not yet committed into any stable Git tree - I've pushed
> >them out into:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.perf
> >
> >(it might take a few minutes for kernel.org to sync up.)
> 
> Tested on Fedora 12, 14, 16 with varying degrees of feature support
> installed. The tests that failed are all static builds with the
> command line:
> 
> make O=/tmp/junk -C tools/perf LDFLAGS=-static NO_DWARF=1
> 
> Passing LDFLAGS to the feature tests should handle that.

Indeed. Does the patch below fix it for you?

Thanks,

	Ingo

-------------------->
Subject: tools/perf/build: Pass through LDFLAGS to feature tests
From: Ingo Molnar <mingo@kernel.org>
Date: Mon Oct 7 17:48:56 CEST 2013

David Ahern reported that when passing in LDFLAGS=-static then the
feature checks still succeed - causing build failures down the
line because the static libraries are missing.

Solve this by passing through LDFLAGS to the feature-check Makefile.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                |    4 ++--
 tools/perf/config/feature-checks/Makefile |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: tip/tools/perf/config/Makefile
===================================================================
--- tip.orig/tools/perf/config/Makefile
+++ tip/tools/perf/config/Makefile
@@ -95,7 +95,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -172,7 +172,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
Index: tip/tools/perf/config/feature-checks/Makefile
===================================================================
--- tip.orig/tools/perf/config/feature-checks/Makefile
+++ tip/tools/perf/config/feature-checks/Makefile
@@ -32,7 +32,7 @@ CC := $(CC) -MD
 
 all: $(FILES)
 
-BUILD = $(CC) -o $(OUTPUT)$@ $@.c
+BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 
 ###############################
 

