Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3JNUDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:03:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38544 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab3JNUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 050/161] tools/perf/build: Fix O=/some/dir perf.o type of targets
Date: Mon, 14 Oct 2013 17:00:39 -0300
Message-Id: <1381780950-25642-51-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

If someone specifies a single target, mixed with O=, the following way:

    hubble:~/tip/tools/perf> make O=/tmp/perf util/stat.o
    BUILD: Doing 'make -j8' parallel build
    gcc  -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k [...]

The build might even fail, if a target depends on other targets:

    hubble:~/tip/tools/perf> make O=/tmp/perf perf.o
    ...
    perf.c: In function ‘handle_options’:
    perf.c:155:21: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)

The correct way to invoke such targets is:

    hubble:~/tip/tools/perf> make O=/tmp/perf /tmp/perf/perf.o
    BUILD: Doing 'make -j8' parallel build
    GEN /tmp/perf/common-cmds.h
    CC /tmp/perf/perf.o

But that's unnecessary typing and it's also easy to mistakenly build into the
source directory.

To fix this remove the generic suffix rules and add redirection to $(OUTPUT)
for the most popular .o targets.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-mk0oiukmhgSbrll6chrPkkqr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile.perf | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 178a1c87db13..a24f6c280b95 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -576,7 +576,21 @@ $(OUTPUT)perf.o perf.spec \
 	: $(OUTPUT)PERF-VERSION-FILE
 
 .SUFFIXES:
-.SUFFIXES: .o .c .S .s
+
+#
+# If a target does not match any of the later rules then prefix it by $(OUTPUT)
+# This makes targets like 'make O=/tmp/perf perf.o' work in a natural way.
+#
+ifneq ($(OUTPUT),)
+%.o: $(OUTPUT)%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
+util/%.o: $(OUTPUT)util/%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
+bench/%.o: $(OUTPUT)bench/%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
+tests/%.o: $(OUTPUT)tests/%.o
+	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
+endif
 
 # These two need to be here so that when O= is not used they take precedence
 # over the general rule for .o
-- 
1.8.1.4

