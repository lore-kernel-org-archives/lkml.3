Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3JNULa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:11:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39139 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab3JNUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 143/161] perf tools: Separate lbfd check out of NO_DEMANGLE condition
Date: Mon, 14 Oct 2013 17:02:12 -0300
Message-Id: <1381780950-25642-144-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

We fail build with NO_DEMANGLE with missing -lbfd externals error.
The reason is that we now use bfd code in srcline object:
  perf tools: Implement addr2line directly using libbfd

So we need to check/add -lbfd always now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 29ad7d6c5311..96804247df08 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -470,6 +470,10 @@ else
   endif
 endif
 
+ifeq ($(feature-libbfd), 1)
+  EXTLIBS += -lbfd
+endif
+
 ifdef NO_DEMANGLE
   CFLAGS += -DNO_DEMANGLE
 else
@@ -477,9 +481,7 @@ else
     EXTLIBS += -liberty
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
-    ifeq ($(feature-libbfd), 1)
-      EXTLIBS += -lbfd
-    else
+    ifneq ($(feature-libbfd), 1)
       $(feature_check,liberty)
       ifeq ($(feature-liberty), 1)
         EXTLIBS += -lbfd -liberty
@@ -502,6 +504,10 @@ else
   endif
 endif
 
+ifneq ($(filter -lbfd,$(EXTLIBS)),)
+  CFLAGS += -DHAVE_LIBBFD_SUPPORT
+endif
+
 ifndef NO_ON_EXIT
   ifeq ($(feature-on-exit), 1)
     CFLAGS += -DHAVE_ON_EXIT_SUPPORT
@@ -524,10 +530,6 @@ ifndef NO_LIBNUMA
   endif
 endif
 
-ifndef ($(filter -lbfd,$(EXTLIBS)),)
-  CFLAGS += -DHAVE_LIBBFD_SUPPORT
-endif
-
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
-- 
1.8.1.4

