Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3DOUf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:35:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab3DOUfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:35:24 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] rpm-pkg: Do not write to the parent directory
Date: Mon, 15 Apr 2013 22:35:06 +0200
Message-Id: <1366058108-3500-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
References: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we only package explicitly listed files to the tarball, there
is no need to abuse the parent directory.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/package/Makefile |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index b70b33e..ab203c2 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -32,7 +32,6 @@ TAR_CONTENT := $(KBUILD_ALLDIRS) kernel.spec .config .scmversion Makefile \
                Kbuild Kconfig COPYING $(wildcard localversion*)
 TAR_CONTENT := $(addprefix $(KERNELPATH)/,$(TAR_CONTENT))
 MKSPEC     := $(srctree)/scripts/package/mkspec
-PREV       := set -e; cd -P ..;
 
 # rpm-pkg
 # ---------------------------------------------------------------------------
@@ -47,18 +46,17 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
 		false; \
 	fi
 	$(MAKE) clean
-	$(PREV) ln -sf $(srctree) $(KERNELPATH)
+	ln -sf $(srctree) $(KERNELPATH)
 	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --save-scmversion
-	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(TAR_CONTENT)
-	$(PREV) rm $(KERNELPATH)
+	tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(TAR_CONTENT)
+	rm $(KERNELPATH)
 	rm -f $(objtree)/.scmversion
 	set -e; \
 	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
-
-	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
-	rm ../$(KERNELPATH).tar.gz
+	$(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta $(KERNELPATH).tar.gz
+	rm $(KERNELPATH).tar.gz
 
 clean-files := $(objtree)/kernel.spec
 
-- 
1.7.3.1

