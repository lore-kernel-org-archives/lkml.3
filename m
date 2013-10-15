Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3JOFQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3JOFQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:16:03 -0400
Date: Mon, 14 Oct 2013 22:15:48 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-7181a6714efc5039ffb50db7462d5cefe15b5630@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libperl'
Git-Commit-ID: 7181a6714efc5039ffb50db7462d5cefe15b5630
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:15:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7181a6714efc5039ffb50db7462d5cefe15b5630
Gitweb:     http://git.kernel.org/tip/7181a6714efc5039ffb50db7462d5cefe15b5630
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 15:15:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:43 +0200

tools/perf/build: Split out feature check: 'libperl'

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
index 3d3d435..8124dd5 100644
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
