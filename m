Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbaFKQU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:20:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44901 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbaFKQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:20:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@fedoraproject.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86,vdso: Fix vdso_install
Date: Wed, 11 Jun 2014 09:20:07 -0700
Message-Id: <fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402503408.git.luto@amacapital.net>
References: <5398749B.4090209@zytor.com>
 <cover.1402503408.git.luto@amacapital.net>
In-Reply-To: <cover.1402503408.git.luto@amacapital.net>
References: <cover.1402503408.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than monkeying with barely-comprehensible static pattern
rules, just use an explicit loop.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 9769df0..b1c70cc 100644
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
 
@@ -176,15 +171,14 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
 GCOV_PROFILE := n
 
 #
-# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
+# Install the unstripped copies of vdso*.so listed in $(vdso-install-y).
 #
-quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
-$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
-	@mkdir -p $(MODLIB)/vdso
-	$(call cmd,vdso_install)
+quiet_cmd_vdso_install = INSTALL $(sofile)
+      cmd_vdso_install = cp $(obj)/$(sofile).dbg $(MODLIB)/vdso/$(sofile)
 
-PHONY += vdso_install $(vdso-install-y)
-vdso_install: $(vdso-install-y)
+PHONY += vdso_install
+vdso_install: $(vdso_img_sodbg:%=$(obj)/%) FORCE
+	@mkdir -p $(MODLIB)/vdso
+	@$(foreach sofile,$(vdso_img_sodbg:%.dbg=%),$(call recipe-cmd,vdso_install);)
 
 clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
-- 
1.9.3

