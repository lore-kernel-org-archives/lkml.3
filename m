Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3JHKVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:21:05 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34612 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3JHKM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:27 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 24/52] tools/perf/build: Split out feature check: 'libpython'
Date: Tue,  8 Oct 2013 12:10:54 +0200
Message-Id: <1381227082-22039-25-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-9wfutfb8ufFHrddrwlejqrai@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                        |  3 ++-
 tools/perf/config/feature-checks/Makefile         | 18 ++++++++++++++++++
 tools/perf/config/feature-checks/test-libpython.c |  7 +++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 145b519..1b3ced4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -119,6 +119,7 @@ FEATURE_TESTS =				\
 	gtk2				\
 	gtk2-infobar			\
 	libperl				\
+	libpython			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -357,7 +358,7 @@ else
       PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
       FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
+      ifneq ($(feature-libpython), 1)
         $(call disable-python,Python.h (for Python 2.x))
       else
 
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 3033c25..e7ed05a 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -17,6 +17,7 @@ FILES=					\
 	test-gtk2			\
 	test-gtk2-infobar		\
 	test-libperl			\
+	test-libpython			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -90,6 +91,23 @@ FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 test-libperl:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
+override PYTHON := python
+override PYTHON_CONFIG := python-config
+
+escape-for-shell-sq =  $(subst ','\'',$(1))
+shell-sq = '$(escape-for-shell-sq)'
+
+PYTHON_CONFIG_SQ = $(call shell-sq,$(PYTHON_CONFIG))
+
+PYTHON_EMBED_LDOPTS = $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+test-libpython:
+	$(BUILD) $(FLAGS_PYTHON_EMBED)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libpython.c b/tools/perf/config/feature-checks/test-libpython.c
new file mode 100644
index 0000000..7226797
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libpython.c
@@ -0,0 +1,7 @@
+#include <Python.h>
+#
+int main(void)
+{
+	Py_Initialize();
+	return 0;
+}
-- 
1.8.3.1

