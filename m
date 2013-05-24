Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3EXMgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:36:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab3EXMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:36:41 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 11/25] perf tools: Move libperl check config into config/Makefile
Date: Fri, 24 May 2013 14:35:14 +0200
Message-Id: <1369398928-9809-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libperl check config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile        | 20 +++-----------------
 tools/perf/config/Makefile | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8e59a4d..f856bb5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -530,23 +530,9 @@ ifndef NO_GTK2
 	LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
 endif
 
-ifdef NO_LIBPERL
-	BASIC_CFLAGS += -DNO_LIBPERL
-else
-       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
-       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
-       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
-	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
-
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
-		BASIC_CFLAGS += -DNO_LIBPERL
-	else
-               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
-               EXTLIBS += $(PERL_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-	endif
+ifndef NO_LIBPERL
+	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+	LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
 disable-python = $(eval $(disable-python_code))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6fc2089..2c9e0a5 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -240,3 +240,24 @@ ifndef NO_GTK2
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 	endif
 endif
+
+grep-libs  = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+ifdef NO_LIBPERL
+	BASIC_CFLAGS += -DNO_LIBPERL
+else
+	PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+	PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+	PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+		BASIC_CFLAGS += -DNO_LIBPERL
+		NO_LIBPERL := 1
+	else
+		ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+		EXTLIBS += $(PERL_EMBED_LIBADD)
+	endif
+endif
-- 
1.7.11.7

