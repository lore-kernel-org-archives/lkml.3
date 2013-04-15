Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3DOUfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:35:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab3DOUfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:35:19 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] rpm-pkg: Do not package the whole source directory
Date: Mon, 15 Apr 2013 22:35:05 +0200
Message-Id: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source tree can contain lots of uninteresting data like tag or
cscope files, packaging which slows down make rpm needlessly. It can
also break the build, if the tree contains an unrelated file named
*.spec. The downside of this change is that new subdirectories have to
be added to the KBUILD_ALLDIR variable in the top-level Makefile. The
upside is that the behavior is more predictable.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile                 |    2 ++
 scripts/package/Makefile |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 5bd9f770..84392df 100644
--- a/Makefile
+++ b/Makefile
@@ -756,6 +756,8 @@ export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
 export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
 export KBUILD_LDS          := arch/$(SRCARCH)/kernel/vmlinux.lds
 export LDFLAGS_vmlinux
+# used by scripts/pacmage/Makefile
+export KBUILD_ALLDIRS := $(sort $(filter-out arch/%,$(vmlinux-alldirs)) arch Documentation include samples scripts tools virt)
 
 vmlinux-deps := $(KBUILD_LDS) $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN)
 
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index d7b3285..b70b33e 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -27,6 +27,10 @@ RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
 
 # Remove hyphens since they have special meaning in RPM filenames
 KERNELPATH := kernel-$(subst -,_,$(KERNELRELEASE))
+# Include only those top-level files that are needed by make, plus the GPL copy
+TAR_CONTENT := $(KBUILD_ALLDIRS) kernel.spec .config .scmversion Makefile \
+               Kbuild Kconfig COPYING $(wildcard localversion*)
+TAR_CONTENT := $(addprefix $(KERNELPATH)/,$(TAR_CONTENT))
 MKSPEC     := $(srctree)/scripts/package/mkspec
 PREV       := set -e; cd -P ..;
 
@@ -45,7 +49,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 	$(MAKE) clean
 	$(PREV) ln -sf $(srctree) $(KERNELPATH)
 	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --save-scmversion
-	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
+	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(TAR_CONTENT)
 	$(PREV) rm $(KERNELPATH)
 	rm -f $(objtree)/.scmversion
 	set -e; \
-- 
1.7.3.1

