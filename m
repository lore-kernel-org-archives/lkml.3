Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3BQPDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:03:33 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39395 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3BQPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:03:30 -0500
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf: check if -DFORTIFY_SOURCE=2 is allowed
Date: Sun, 17 Feb 2013 16:03:36 +0100
Message-Id: <1361113416-8662-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems gcc (4.7.2) defines _FORTIFY_SOURCE internally and becomes confused
when it sees another definition in flags.

For me, build failed like this:
CHK glibc
Makefile:548: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static. Stop.

and only with V=1 it printed:
<command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
<stdin>:1:0: note: this is the location of the previous definition

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8ab05e5..7925bb2 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -94,7 +94,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
+  CFLAGS_OPTIMIZE = -O6
 endif
 
 ifdef PARSER_DEBUG
@@ -167,6 +167,12 @@ ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-W
        CFLAGS := $(CFLAGS) -Wvolatile-register-var
 endif
 
+ifndef PERF_DEBUG
+	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
+	endif
+endif
+
 ### --- END CONFIGURATION SECTION ---
 
 ifeq ($(srctree),)
-- 
1.8.1

