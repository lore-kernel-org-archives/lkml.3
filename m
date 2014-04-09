Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbaDIGwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:52:00 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:60866 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaDIGv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:51:59 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: support simultaneous "make %config" and "make all"
Date: Wed,  9 Apr 2014 15:51:35 +0900
Message-Id: <1397026295-13822-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild is supposed to support mixed targets. (%config and build targets)

But "make all" did nothing if it was run with configuration targets.
For example,

  $ LANG=C make defconfig all
    HOSTCC  scripts/basic/fixdep
    HOSTCC  scripts/kconfig/conf.o
    SHIPPED scripts/kconfig/zconf.tab.c
    SHIPPED scripts/kconfig/zconf.lex.c
    SHIPPED scripts/kconfig/zconf.hash.c
    HOSTCC  scripts/kconfig/zconf.tab.o
    HOSTLD  scripts/kconfig/conf
  *** Default configuration is based on 'x86_64_defconfig'
  #
  # configuration written to .config
  #
  make: Nothing to be done for `all'.

This commits allows "make %config all" and makes sure
mixed targets are built one by one in the given order.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Michal Marek <mmarek@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile           | 12 ++++++++++--
 scripts/mkmakefile | 15 ++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index 4eadf2d..40f731b 100644
--- a/Makefile
+++ b/Makefile
@@ -486,8 +486,16 @@ ifeq ($(mixed-targets),1)
 # We're called with mixed targets (*config and build targets).
 # Handle them one by one.
 
-%:: FORCE
-	$(Q)$(MAKE) -C $(srctree) KBUILD_SRC= $@
+PHONY += $(MAKECMDGOALS) __build_one_by_one
+
+$(filter-out __build_one_by_one, $(MAKECMDGOALS)): __build_one_by_one
+	@:
+
+__build_one_by_one:
+	$(Q)set -e; \
+	for i in $(MAKECMDGOALS); do \
+		$(MAKE) -f $(srctree)/Makefile $$i; \
+	done
 
 else
 ifeq ($(config-targets),1)
diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 0cc0442..84af27b 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -42,18 +42,11 @@ MAKEARGS += O=\$(if \$(patsubst /%,,\$(makedir)),\$(CURDIR)/)\$(patsubst %/,%,\$
 
 MAKEFLAGS += --no-print-directory
 
-.PHONY: all \$(MAKECMDGOALS)
+.PHONY: __sub-make \$(MAKECMDGOALS)
 
-all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
+__sub-make:
+	\$(Q)\$(MAKE) \$(MAKEARGS) \$(MAKECMDGOALS)
 
-all:
-	\$(Q)\$(MAKE) \$(MAKEARGS) \$(all)
-
-Makefile:;
-
-\$(all): all
-	@:
-
-%/: all
+\$(filter-out __sub-make, \$(MAKECMDGOALS)): __sub-make
 	@:
 EOF
-- 
1.8.3.2

