Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3JGL7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:59:21 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52200 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3JGL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:36 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 48/50] tools/perf/build: Fix non-canonical directory names in O=
Date: Mon,  7 Oct 2013 13:56:41 +0200
Message-Id: <1381147003-2574-49-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 74f52d8..9580ebe 100644
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
1.7.11.7

