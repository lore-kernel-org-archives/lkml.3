Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3JOFUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:20:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab3JOFUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:20:07 -0400
Date: Mon, 14 Oct 2013 22:19:49 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-1f7c645ab4b8326fef5afcd842795e071ecce9df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Fix O=/some/
 dir perf.o type of targets
Git-Commit-ID: 1f7c645ab4b8326fef5afcd842795e071ecce9df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:19:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f7c645ab4b8326fef5afcd842795e071ecce9df
Gitweb:     http://git.kernel.org/tip/1f7c645ab4b8326fef5afcd842795e071ecce9df
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 4 Oct 2013 12:14:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:02 +0200

tools/perf/build: Fix O=/some/dir perf.o type of targets

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
index 178a1c8..a24f6c2 100644
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
