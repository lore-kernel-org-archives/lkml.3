Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaFMSUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:20:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaFMSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:20:02 -0400
Date: Fri, 13 Jun 2014 11:19:25 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-a934fb5bc9cd1260be89272cfb7a6c9dc71974d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, jwboyer@fedoraproject.org, sam@ravnborg.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, jwboyer@fedoraproject.org,
        sam@ravnborg.org, tglx@linutronix.de
In-Reply-To: <b10299edd8ba98d17e07dafcd895b8ecf4d99eff.1402586707.git.luto@amacapital.net>
References: <b10299edd8ba98d17e07dafcd895b8ecf4d99eff.1402586707.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso: Fix vdso_install
Git-Commit-ID: a934fb5bc9cd1260be89272cfb7a6c9dc71974d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a934fb5bc9cd1260be89272cfb7a6c9dc71974d7
Gitweb:     http://git.kernel.org/tip/a934fb5bc9cd1260be89272cfb7a6c9dc71974d7
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 12 Jun 2014 08:28:10 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 13 Jun 2014 10:31:48 -0700

x86/vdso: Fix vdso_install

"make vdso_install" installs unstripped versions of the vdso objects
for the benefit of the debugger.  This was broken by checkin:

6f121e548f83 x86, vdso: Reimplement vdso.so preparation in build-time C

The filenames are different now, so update the Makefile to cope.

This still installs the 64-bit vdso as vdso64.so.  We believe this
will be okay, as the only known user is a patched gdb which is known
to use build-ids, but if it turns out to be a problem we may have to
add a link.

Inspired by a patch from Sam Ravnborg.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Tested-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/b10299edd8ba98d17e07dafcd895b8ecf4d99eff.1402586707.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/vdso/Makefile | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index ba6fc27..3c0809a 100644
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
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
 vobjs-nox32 := vdso-fakesections.o
@@ -178,15 +173,20 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
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
+vdso_img_insttargets := $(vdso_img_sodbg:%.dbg=install_%)
+
+$(MODLIB)/vdso: FORCE
 	@mkdir -p $(MODLIB)/vdso
+
+$(vdso_img_insttargets): install_%: $(obj)/%.dbg $(MODLIB)/vdso FORCE
 	$(call cmd,vdso_install)
 
-PHONY += vdso_install $(vdso-install-y)
-vdso_install: $(vdso-install-y)
+PHONY += vdso_install $(vdso_img_insttargets)
+vdso_install: $(vdso_img_insttargets) FORCE
 
 clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
