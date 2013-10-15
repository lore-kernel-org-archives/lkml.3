Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3JOFQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:16:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3JOFQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:16:20 -0400
Date: Mon, 14 Oct 2013 22:16:06 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-95d061c8a9f36e8c2cc458f97bc67716571b3fee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libpython-version'
Git-Commit-ID: 95d061c8a9f36e8c2cc458f97bc67716571b3fee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:16:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95d061c8a9f36e8c2cc458f97bc67716571b3fee
Gitweb:     http://git.kernel.org/tip/95d061c8a9f36e8c2cc458f97bc67716571b3fee
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 15:40:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:44 +0200

tools/perf/build: Split out feature check: 'libpython-version'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-raHmlqlnv0zexsrPau8hhane@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                         | 3 ++-
 tools/perf/config/feature-checks/Makefile                          | 4 ++++
 .../feature-checks/{test-libpython.c => test-libpython-version.c}  | 7 +++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 595c0e0..63ba069 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -120,6 +120,7 @@ FEATURE_TESTS =				\
 	gtk2-infobar			\
 	libperl				\
 	libpython			\
+	libpython-version		\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -372,7 +373,7 @@ else
         $(call disable-python,Python.h (for Python 2.x))
       else
 
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+        ifneq ($(feature-libpython-version), 1)
           $(warning Python 3 is not yet supported; please set)
           $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
           $(warning If you also have Python 2 installed, then)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index e7ed05a..d15074d 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -18,6 +18,7 @@ FILES=					\
 	test-gtk2-infobar		\
 	test-libperl			\
 	test-libpython			\
+	test-libpython-version		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -108,6 +109,9 @@ FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 test-libpython:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
+test-libpython-version:
+	$(BUILD) $(FLAGS_PYTHON_EMBED)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libpython.c b/tools/perf/config/feature-checks/test-libpython-version.c
similarity index 50%
copy from tools/perf/config/feature-checks/test-libpython.c
copy to tools/perf/config/feature-checks/test-libpython-version.c
index 7226797..facea12 100644
--- a/tools/perf/config/feature-checks/test-libpython.c
+++ b/tools/perf/config/feature-checks/test-libpython-version.c
@@ -1,7 +1,10 @@
 #include <Python.h>
-#
+
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+
 int main(void)
 {
-	Py_Initialize();
 	return 0;
 }
