Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab3JOFQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:16:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3JOFQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:16:12 -0400
Date: Mon, 14 Oct 2013 22:15:57 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-9734163b6ee1425c6fa4b65d7e6ce34c9079420d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libpython'
Git-Commit-ID: 9734163b6ee1425c6fa4b65d7e6ce34c9079420d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:16:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9734163b6ee1425c6fa4b65d7e6ce34c9079420d
Gitweb:     http://git.kernel.org/tip/9734163b6ee1425c6fa4b65d7e6ce34c9079420d
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 15:18:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:44 +0200

tools/perf/build: Split out feature check: 'libpython'

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
index 8124dd5..595c0e0 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -119,6 +119,7 @@ FEATURE_TESTS =				\
 	gtk2				\
 	gtk2-infobar			\
 	libperl				\
+	libpython			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -367,7 +368,7 @@ else
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
