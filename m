Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3AOW2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:41510 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab3AOW2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pawel Moll <pawel.moll@arm.com>, Michal Marek <mmarek@suse.cz>
Subject: [ 058/221] kbuild: Do not remove vmlinux when cleaning external module
Date: Tue, 15 Jan 2013 10:49:45 -0800
Message-Id: <20130115185002.229167956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1021,11 +1021,14 @@ clean: rm-dirs  := $(CLEAN_DIRS)
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
@@ -1252,7 +1255,6 @@ scripts: ;
 endif # KBUILD_EXTMOD
 
 clean: $(clean-dirs)
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \


