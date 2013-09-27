Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3I0Ocn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3I0Ocf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:32:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] perf tools: Separate lbfd check out of NO_DEMANGLE condition
Date: Fri, 27 Sep 2013 16:32:10 +0200
Message-Id: <1380292332-6518-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fail build with NO_DEMANGLE with missing -lbfd externals error.
The reason is that we now use bfd code in srcline object:
  perf tools: Implement addr2line directly using libbfd

So we need to check/add -lbfd always now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/Makefile | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 8b49a00..40a41c6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -360,6 +360,13 @@ else
   endif
 endif
 
+FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
+has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
+ifeq ($(has_bfd),y)
+  EXTLIBS += -lbfd
+  CFLAGS += -DLIBBFD_SUPPORT
+endif
+
 ifdef NO_DEMANGLE
   CFLAGS += -DNO_DEMANGLE
 else
@@ -367,11 +374,7 @@ else
     EXTLIBS += -liberty
     CFLAGS += -DHAVE_CPLUS_DEMANGLE
   else
-    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-    ifeq ($(has_bfd),y)
-      EXTLIBS += -lbfd
-    else
+    ifneq ($(has_bfd),y)
       FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
       has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
       ifeq ($(has_bfd_iberty),y)
@@ -397,10 +400,6 @@ else
   endif
 endif
 
-ifndef ($(filter -lbfd,$(EXTLIBS)),)
-  CFLAGS += -DLIBBFD_SUPPORT
-endif
-
 ifndef NO_STRLCPY
   ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
     CFLAGS += -DHAVE_STRLCPY
-- 
1.7.11.7

