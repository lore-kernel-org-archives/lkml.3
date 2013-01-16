Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3APQli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:41:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab3APQFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pawel Moll <pawel.moll@arm.com>, Michal Marek <mmarek@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 121/222] kbuild: Do not remove vmlinux when cleaning external module
Date: Wed, 16 Jan 2013 13:55:21 -0200
Message-Id: <1358351822-7675-122-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Moll <pawel.moll@arm.com>

commit bd1ee804af8bdf2fd5131234330615f8aecbd9ed upstream.

Since commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 "kbuild:
link of vmlinux moved to a script" make clean with M=<dir>
argument (so cleaning external module) removes vmlinux,
System.map and couple of other files from the *main* kernel
build directory! This not what was happening before and almost
certainly not what one would expect.

This patch moves makes the clean target of the script called
only when !KBUILD_EXTMOD.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 Makefile |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index de1e58b..d253746 100644
--- a/Makefile
+++ b/Makefile
@@ -1003,11 +1003,14 @@ clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
 clean-dirs      := $(addprefix _clean_, . $(vmlinux-alldirs) Documentation samples)
 
-PHONY += $(clean-dirs) clean archclean
+PHONY += $(clean-dirs) clean archclean vmlinuxclean
 $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
-clean: archclean
+vmlinuxclean:
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
+
+clean: archclean vmlinuxclean
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1234,7 +1237,6 @@ scripts: ;
 endif # KBUILD_EXTMOD
 
 clean: $(clean-dirs)
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
-- 
1.7.9.5

