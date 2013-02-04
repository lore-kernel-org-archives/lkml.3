Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3BDMGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:06:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57645 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab3BDMGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:06:04 -0500
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] perf: Check for flex and bison before continuing building
Date: Mon,  4 Feb 2013 13:05:54 +0100
Message-Id: <1359979554-9160-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Check whether both executables are present on the system before
continuing with the build instead of failing halfway, if either are
missing.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/perf/Makefile | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4b1044cbd84c..a158309a65ef 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -149,6 +149,8 @@ RM = rm -f
 MKDIR = mkdir
 FIND = find
 INSTALL = install
+FLEX = flex
+BISON= bison
 
 # sparse is architecture-neutral, which means that we need to tell it
 # explicitly what architecture to check for. Fix this up for yours..
@@ -158,6 +160,14 @@ ifneq ($(MAKECMDGOALS),clean)
 ifneq ($(MAKECMDGOALS),tags)
 -include config/feature-tests.mak
 
+ifeq ($(call get-executable,$(FLEX)),)
+	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
+endif
+
+ifeq ($(call get-executable,$(BISON)),)
+	dummy := $(error Error: $(BISON) is missing on this system, please install it)
+endif
+
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
@@ -282,9 +292,6 @@ endif
 
 export PERL_PATH
 
-FLEX = flex
-BISON= bison
-
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
-- 
1.8.1.2.422.g08c0e7f

