Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaGIG1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:27:53 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:32879 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaGIG1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:27:52 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: Use symbolic link to the source tree for out-of-tree build
Date: Wed,  9 Jul 2014 15:27:21 +0900
Message-Id: <1404887241-14455-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9da0763bd, the variable 'srctree' is set as follows:

[1] Building in the source tree
      => srctree is set to '.'
[2] Building in a subdir right under the source tree
      => srctree is set to '..'
[3] Other cases
      => srctree is set to the absolute path to the source tree

Pros are more readable compiler messages, WARN_ON() etc.
for case [1] and [2]. (but not [3])

Cons are we have to do build-test for 3 cases when adding
some changes to the build infrastructure.

We want to treat case [2] and [3] in the same way like prior to
commit 9da0763bd, keeping the compact log messages.

The idea here is to create a symbolic link 'srctree' pointing
to $(KBUILD_SRC) at the very early stage of the build process.

We created the symbolic link 'source' in outputmakefile: target,
but it is redundant and should be removed.
(I think 'srctree' is a more suitable symbolic link name than 'source')

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 4d75b4b..0089618 100644
--- a/Makefile
+++ b/Makefile
@@ -130,6 +130,7 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 # able to understand relative filenames.
 sub-make: FORCE
 	@echo "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
+	$(if $(KBUILD_VERBOSE:1=),@)ln -fsn $(CURDIR) $(KBUILD_OUTPUT)/srctree
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
 	KBUILD_SRC=$(CURDIR) \
 	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
@@ -152,17 +153,7 @@ else
 _all: modules
 endif
 
-ifeq ($(KBUILD_SRC),)
-        # building in the source tree
-        srctree := .
-else
-        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
-                # building in a subdirectory of the source tree
-                srctree := ..
-        else
-                srctree := $(KBUILD_SRC)
-        endif
-endif
+srctree		:= $(if $(KBUILD_SRC),srctree,.)
 objtree		:= .
 src		:= $(srctree)
 obj		:= $(objtree)
@@ -460,7 +451,6 @@ PHONY += outputmakefile
 # output directory.
 outputmakefile:
 ifneq ($(KBUILD_SRC),)
-	$(Q)ln -fsn $(srctree) source
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
 	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
 endif
-- 
1.9.1

