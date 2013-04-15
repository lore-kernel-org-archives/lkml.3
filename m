Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3DOUfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:35:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab3DOUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:35:30 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] rpm-pkg: Always regenerate the specfile
Date: Mon, 15 Apr 2013 22:35:07 +0200
Message-Id: <1366058108-3500-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
References: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *pkg targets are always run, so it makes no sense to cache the
generated specfile. This also fixes build errors when the specfile
becomes out of date, without the Makefile noticing it:

$ make rpm
  works
$ echo yadadada >localversion-test
$ make rpm
  fails, because kernel.spec assumes the old kernel release string

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/package/Makefile |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index ab203c2..08e4e2f 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -35,10 +35,7 @@ MKSPEC     := $(srctree)/scripts/package/mkspec
 
 # rpm-pkg
 # ---------------------------------------------------------------------------
-$(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
-	$(CONFIG_SHELL) $(MKSPEC) > $@
-
-rpm-pkg rpm: $(objtree)/kernel.spec FORCE
+rpm-pkg rpm: FORCE
 	@if test "$(objtree)" != "$(srctree)"; then \
 		echo "Building source + binary RPM is not possible outside the"; \
 		echo "kernel source tree. Don't set KBUILD_OUTPUT, or use the"; \
@@ -47,6 +44,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 	fi
 	$(MAKE) clean
 	ln -sf $(srctree) $(KERNELPATH)
+	$(CONFIG_SHELL) $(MKSPEC) >$(objtree)/kernel.spec
 	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --save-scmversion
 	tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(TAR_CONTENT)
 	rm $(KERNELPATH)
@@ -56,17 +54,13 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta $(KERNELPATH).tar.gz
-	rm $(KERNELPATH).tar.gz
-
-clean-files := $(objtree)/kernel.spec
+	rm $(KERNELPATH).tar.gz kernel.spec
 
 # binrpm-pkg
 # ---------------------------------------------------------------------------
-$(objtree)/binkernel.spec: $(MKSPEC) $(srctree)/Makefile
-	$(CONFIG_SHELL) $(MKSPEC) prebuilt > $@
-
-binrpm-pkg: $(objtree)/binkernel.spec FORCE
+binrpm-pkg: FORCE
 	$(MAKE) KBUILD_SRC=
+	$(CONFIG_SHELL) $(MKSPEC) prebuilt > $(objtree)/binkernel.spec
 	set -e; \
 	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
 	set -e; \
@@ -74,8 +68,7 @@ binrpm-pkg: $(objtree)/binkernel.spec FORCE
 
 	$(RPM) $(RPMOPTS) --define "_builddir $(objtree)" --target \
 		$(UTS_MACHINE) -bb $<
-
-clean-files += $(objtree)/binkernel.spec
+	rm binkernel.spec
 
 # Deb target
 # ---------------------------------------------------------------------------
-- 
1.7.3.1

