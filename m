Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3JXCvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 22:51:19 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:39003 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3JXCvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 22:51:18 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf: Fix library detection when building without libelf
Date: Wed, 23 Oct 2013 22:51:09 -0400
Message-Id: <1382583069-26121-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I attempt to build perf on a system with slang but without libelf,
'make' would wrongly complain that the slang library could not be found.

It turns out that this was happening because we are not filtering -lelf
from EXTLIBS early enough.  As a result, the library test for slang
(ditto for gtk, libaudit, etc) erroneously passes -lelf to try-cc, which
of course fails on a system without libelf.

This patch makes the filtering of -lelf from EXTLIBS occur right after
testing for libelf support, so that the subsequent library tests will
not erroneously pass -lelf to try-cc when building without libelf
support.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 tools/perf/Makefile        | 2 --
 tools/perf/config/Makefile | 4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64c043b..94635c8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -443,8 +443,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef NO_LIBELF
-EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
-
 # Remove ELF/DWARF dependent codes
 LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5f6f9b3..1748767 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -174,6 +174,10 @@ else
 endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
+ifdef NO_LIBELF
+EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
+endif
+
 ifndef NO_LIBELF
 CFLAGS += -DLIBELF_SUPPORT
 FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-- 
1.8.4.rc3

