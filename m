Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaJEPco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 11:32:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60826 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaJEPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 11:32:40 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: [PATCH] Kbuild: Check for CONFIG_READABLE_ASM when building .s targets
Date: Sun,  5 Oct 2014 17:32:34 +0200
Message-Id: <1412523154-25602-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We do need to look at the asm output of c files for various reasons. In
order to do so, we do make <path-to-filename>.s.

However, it can happen that the Kconfig option which enables the
creation of readable asm CONFIG_READABLE_ASM is disabled. What is more,
we want this option enabled because it indirectly enables the issue of
line numbers in the asm done by gcc's switch -g.

So issue a warning that the asm output might not be optimally readable
if that option is disabled.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Makefile               | 2 +-
 scripts/Makefile.build | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e43244263306..d9b505360c2a 100644
--- a/Makefile
+++ b/Makefile
@@ -1513,7 +1513,7 @@ else
 endif
 
 %.s: %.c prepare scripts FORCE
-	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
+	$(Q)$(MAKE) $(build)=$(build-dir) asm_target=$@ $(target-dir)$(notdir $@)
 %.i: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.o: %.c prepare scripts FORCE
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e6778cd71..8aaf1c04fe18 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -147,7 +147,12 @@ $(multi-objs-y:.o=.s)   : modname = $(modname-multi)
 $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
 
 quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
-cmd_cc_s_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -S -o $@ $<
+cmd_cc_s_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -S -o $@ $< \
+		   $(if $(findstring $(asm_target),$@),\
+			$(if $(__cmd_cc_s_c_once),,\
+				$(if $(CONFIG_READABLE_ASM),,\
+					$(warning Enable CONFIG_READABLE_ASM for more helpful asm); \
+					$(eval __cmd_cc_s_c_once=1)))) \
 
 $(obj)/%.s: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_s_c)
-- 
2.0.0

