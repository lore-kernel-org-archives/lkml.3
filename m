Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3JHKMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:38 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39409 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3JHKM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:27 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 23/52] tools/perf/build: Split out feature check: 'libperl'
Date: Tue,  8 Oct 2013 12:10:53 +0200
Message-Id: <1381227082-22039-24-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-ggucqbwFwpxyuxde6dm7itHq@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      |  3 ++-
 tools/perf/config/feature-checks/Makefile       | 13 +++++++++++++
 tools/perf/config/feature-checks/test-libperl.c |  9 +++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ca59b56..145b519 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -118,6 +118,7 @@ FEATURE_TESTS =				\
 	libslang			\
 	gtk2				\
 	gtk2-infobar			\
+	libperl				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -311,7 +312,7 @@ else
   PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-  ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+  ifneq ($(feature-libperl), 1)
     CFLAGS += -DNO_LIBPERL
     NO_LIBPERL := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 017918f..3033c25 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -16,6 +16,7 @@ FILES=					\
 	test-libslang			\
 	test-gtk2			\
 	test-gtk2-infobar		\
+	test-libperl			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -77,6 +78,18 @@ test-gtk2:
 test-gtk2-infobar:
 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 
+grep-libs  = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+test-libperl:
+	$(BUILD) $(FLAGS_PERL_EMBED)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libperl.c b/tools/perf/config/feature-checks/test-libperl.c
new file mode 100644
index 0000000..8871f6a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libperl.c
@@ -0,0 +1,9 @@
+#include <EXTERN.h>
+#include <perl.h>
+
+int main(void)
+{
+	perl_alloc();
+
+	return 0;
+}
-- 
1.8.3.1

