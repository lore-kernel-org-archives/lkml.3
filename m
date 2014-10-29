Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaJ2H15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:27:57 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:49546 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaJ2H1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:27:55 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: collect shorthands into the top Makefile
Date: Wed, 29 Oct 2014 16:27:31 +0900
Message-Id: <1414567651-2503-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The motivation of this commit is to avoid duplicated definitions
of "clean" and "hdr-inst" shorthands.

The shorthand "clean" is defined in both the top Makefile and
scripts/Makefile.clean.

Likewise, "hdr-inst" is defined in both the top Makefile and
scripts/Makefile.headersinst.

The idea here is define and export them in the top Makefile
because $(srctree) is constant during the build process.

For consistency, "build" and "modbuiltin" should be also moved.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Makefile                     | 13 ++++++-------
 scripts/Kbuild.include       | 12 ------------
 scripts/Makefile.clean       |  5 -----
 scripts/Makefile.headersinst |  1 -
 4 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/Makefile b/Makefile
index 52c1297..cb29318 100644
--- a/Makefile
+++ b/Makefile
@@ -440,6 +440,12 @@ export RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o    \
 export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn \
 			 --exclude CVS --exclude .pc --exclude .hg --exclude .git
 
+# Shorthands
+export build := -f $(srctree)/scripts/Makefile.build obj
+export modbuiltin := -f $(srctree)/scripts/Makefile.modbuiltin obj
+export clean := -f $(srctree)/scripts/Makefile.clean obj
+export hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+
 # ===========================================================================
 # Rules shared between *config targets and build targets
 
@@ -1035,8 +1041,6 @@ firmware_install: FORCE
 #Default location for installed headers
 export INSTALL_HDR_PATH = $(objtree)/usr
 
-hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
-
 # If we do an all arch process set dst to asm-$(hdr-arch)
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
@@ -1580,11 +1584,6 @@ ifneq ($(cmd_files),)
   include $(cmd_files)
 endif
 
-# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.clean obj=dir
-# Usage:
-# $(Q)$(MAKE) $(clean)=dir
-clean := -f $(srctree)/scripts/Makefile.clean obj
-
 endif	# skip-makefile
 
 PHONY += FORCE
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 65e7b08..98f081b 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -167,18 +167,6 @@ ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
 
 ######
 
-###
-# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
-# Usage:
-# $(Q)$(MAKE) $(build)=dir
-build := -f $(srctree)/scripts/Makefile.build obj
-
-###
-# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.modbuiltin obj=
-# Usage:
-# $(Q)$(MAKE) $(modbuiltin)=dir
-modbuiltin := -f $(srctree)/scripts/Makefile.modbuiltin obj
-
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
 addtree = $(if $(patsubst -I%,%,$(1)), \
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index b1c668d..2acaabd 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -7,11 +7,6 @@ src := $(obj)
 PHONY := __clean
 __clean:
 
-# Shorthand for $(Q)$(MAKE) scripts/Makefile.clean obj=dir
-# Usage:
-# $(Q)$(MAKE) $(clean)=dir
-clean := -f $(srctree)/scripts/Makefile.clean obj
-
 # The filename Kbuild has precedence over Makefile
 kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
 include $(if $(wildcard $(kbuild-dir)/Kbuild), $(kbuild-dir)/Kbuild, $(kbuild-dir)/Makefile)
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 8ccf830..1106d6c 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -122,7 +122,6 @@ $(check-file): scripts/headers_check.pl $(output-files) FORCE
 endif
 
 # Recursion
-hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 .PHONY: $(subdirs)
 $(subdirs):
 	$(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@
-- 
1.9.1

