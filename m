Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3JNUrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:47:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38473 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3JNUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 023/161] tools/perf/build: Split out feature check: 'libperl'
Date: Mon, 14 Oct 2013 17:00:12 -0300
Message-Id: <1381780950-25642-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
 create mode 100644 tools/perf/config/feature-checks/test-libperl.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 3d3d435b41fa..8124dd55b05c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -118,6 +118,7 @@ FEATURE_TESTS =				\
 	libslang			\
 	gtk2				\
 	gtk2-infobar			\
+	libperl				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -321,7 +322,7 @@ else
   PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-  ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+  ifneq ($(feature-libperl), 1)
     CFLAGS += -DNO_LIBPERL
     NO_LIBPERL := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 017918f809ff..3033c25f00b4 100644
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
index 000000000000..8871f6a0fdb4
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
1.8.1.4

