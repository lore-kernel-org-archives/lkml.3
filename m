Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3CNMZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:25:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56838
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501Ab3CNMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:23:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/8] perf tools: check if -DFORTIFY_SOURCE=2 is allowed
Date: Thu, 14 Mar 2013 09:23:10 -0300
Message-Id: <1363263795-31485-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363263795-31485-1-git-send-email-acme@infradead.org>
References: <1363263795-31485-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

It seems gcc (4.7.2) defines _FORTIFY_SOURCE internally and becomes
confused when it sees another definition in flags.

For me, build failed like this:

CHK glibc
Makefile:548: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static. Stop.

and only with V=1 it printed:

<command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
<stdin>:1:0: note: this is the location of the previous definition

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361113416-8662-1-git-send-email-marcin.slusarz@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..bb74c79 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -95,7 +95,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
+  CFLAGS_OPTIMIZE = -O6
 endif
 
 ifdef PARSER_DEBUG
@@ -180,6 +180,12 @@ ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-W
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
1.7.1

