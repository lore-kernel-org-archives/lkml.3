Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaKZKbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:31:42 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:55079 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaKZKbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:31:40 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: collect shorthands into scripts/Kbuild.include
Date: Wed, 26 Nov 2014 19:31:13 +0900
Message-Id: <1416997873-3872-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shorthand "clean" is defined in both the top Makefile and
scripts/Makefile.clean.  Likewise, the "hdr-inst" is defined in
both the top Makefile and scripts/Makefile.headersinst.

To reduce code duplication, this commit collects them into
scripts/Kbuild.include like the "build" and "modbuiltin" shorthands.
It requires scripts/Makefile.clean to include scripts/Kbuild.include,
but its impact on the performance of "make clean" should be
negligible.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

Marek, please decide if this patch should be applied or not.

I am not so sure if 10% of performance regression is acceptable.
I do not mind at all if this patch is rejected.

Before this commit, on my box,

$ time make clean

real	0m2.916s
user	0m1.040s
sys	0m2.005s

After,

real	0m3.221s
user	0m1.109s
sys	0m2.271s


 Makefile                     |  7 -------
 scripts/Kbuild.include       | 12 ++++++++++++
 scripts/Makefile.clean       |  5 +----
 scripts/Makefile.headersinst |  1 -
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 2fd5c4e..257e08c 100644
--- a/Makefile
+++ b/Makefile
@@ -1036,8 +1036,6 @@ firmware_install: FORCE
 #Default location for installed headers
 export INSTALL_HDR_PATH = $(objtree)/usr
 
-hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
-
 # If we do an all arch process set dst to asm-$(hdr-arch)
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
@@ -1581,11 +1579,6 @@ ifneq ($(cmd_files),)
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
index 65e7b08..0f90981 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -179,6 +179,18 @@ build := -f $(srctree)/scripts/Makefile.build obj
 # $(Q)$(MAKE) $(modbuiltin)=dir
 modbuiltin := -f $(srctree)/scripts/Makefile.modbuiltin obj
 
+###
+# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.clean obj=
+# Usage:
+# $(Q)$(MAKE) $(clean)=dir
+clean := -f $(srctree)/scripts/Makefile.clean obj
+
+###
+# Shorthand for $(Q)$(MAKE) -rR -f scripts/Makefile.headersinst obj=
+# Usage:
+# $(Q)$(MAKE) $(hdr-inst)=dir
+hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
 addtree = $(if $(patsubst -I%,%,$(1)), \
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index b1c668d..0aa91a0 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -7,10 +7,7 @@ src := $(obj)
 PHONY := __clean
 __clean:
 
-# Shorthand for $(Q)$(MAKE) scripts/Makefile.clean obj=dir
-# Usage:
-# $(Q)$(MAKE) $(clean)=dir
-clean := -f $(srctree)/scripts/Makefile.clean obj
+include scripts/Kbuild.include
 
 # The filename Kbuild has precedence over Makefile
 kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
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

