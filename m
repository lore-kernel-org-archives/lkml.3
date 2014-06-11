Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaFKTZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:25:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46278 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaFKTZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:25:32 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@fedoraproject.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2] x86,vdso: Fix vdso_install
Date: Wed, 11 Jun 2014 12:25:29 -0700
Message-Id: <5d5e221e59be20a3a7ceb99452e74e233383e7b4.1402514715.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <sam@ravnborg.org>
References: <sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filenames are different now.  Inspired by a patch from
Sam Ravnborg.

Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 9769df0..e3683d6 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -9,11 +9,6 @@ VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
 
-vdso-install-$(VDSO64-y)	+= vdso.so
-vdso-install-$(VDSOX32-y)	+= vdsox32.so
-vdso-install-$(VDSO32-y)	+= $(vdso32-images)
-
-
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
@@ -176,15 +171,20 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
 GCOV_PROFILE := n
 
 #
-# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
+# Install the unstripped copies of vdso*.so.
 #
-quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
-$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
+quiet_cmd_vdso_install = INSTALL $(@:install_%=%)
+      cmd_vdso_install = cp $< $(MODLIB)/vdso/$(@:install_%=%)
+
+vdso_img_insttargets := $(vdso_img_sodbg:%=install_%)
+
+$(MODLIB)/vdso: FORCE
 	@mkdir -p $(MODLIB)/vdso
+
+$(vdso_img_insttargets): install_%: $(obj)/% $(MODLIB)/vdso FORCE
 	$(call cmd,vdso_install)
 
-PHONY += vdso_install $(vdso-install-y)
-vdso_install: $(vdso-install-y)
+PHONY += vdso_install $(vdso_img_insttargets)
+vdso_install: $(vdso_img_insttargets) FORCE
 
 clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
-- 
1.9.3

