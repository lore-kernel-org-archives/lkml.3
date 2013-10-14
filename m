Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3JNUoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:44:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38547 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab3JNUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 049/161] tools/perf/build: Fix non-canonical directory names in O=
Date: Mon, 14 Oct 2013 17:00:38 -0300
Message-Id: <1381780950-25642-50-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

This was a long-standing bug, relative pathnames like O=dir did not fully
work in the build system:

    $ make O=localdir clean

    SUBDIR Documentation
    ../../scripts/Makefile.include:3: *** O=localdir does not exist.  Stop.
    make[1]: *** [clean] Error 2
    make: *** [clean] Error 2

Fix this by canonizing the directory before passing it to Makefile.perf.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-hchMp1hozn9tqgswWcooxcru@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74f52d8f9631..9580ebe260e0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -30,12 +30,19 @@ ifeq ($(JOBS),)
   endif
 endif
 
+#
+# Only pass canonical directory names as the output directory:
+#
+ifneq ($(O),)
+  FULL_O := $(shell readlink -f $(O))
+endif
+
 define print_msg
   @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
-  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(O) $@
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $@
 endef
 
 #
-- 
1.8.1.4

