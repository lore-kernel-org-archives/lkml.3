Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaGWL6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:58:09 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35013 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbaGWL6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:58:05 -0400
From: =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>
Cc: Renato Golin <renato.golin@linaro.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH v2] kbuild: add support to generate LLVM bitcode files
Date: Wed, 23 Jul 2014 08:56:53 -0300
Message-Id: <1406116613-4514-1-git-send-email-viniciustinti@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <CALD9WKxTzPYeaAZRrYYuLjNK4VvF1pDxzeDPDvWLuSOpw7_1Tw@mail.gmail.com>
References: <CALD9WKxTzPYeaAZRrYYuLjNK4VvF1pDxzeDPDvWLuSOpw7_1Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows kbuild to generate LLVM bitcode files with the .ll extension.

  # from c code
  CC=clang make kernel/pid.ll

  # from asm code
  CC=clang make arch/x86/kernel/preempt.ll

Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 .gitignore             |  1 +
 Makefile               |  6 ++++++
 scripts/Makefile.build | 14 ++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/.gitignore b/.gitignore
index f4c0b09..c5a7656 100644
--- a/.gitignore
+++ b/.gitignore
@@ -32,6 +32,7 @@
 *.lzo
 *.patch
 *.gcno
+*.ll
 modules.builtin
 Module.symvers
 
diff --git a/Makefile b/Makefile
index 6b27741..7826c33 100644
--- a/Makefile
+++ b/Makefile
@@ -1213,6 +1213,8 @@ help:
 	@echo  '                    (default: $$(INSTALL_MOD_PATH)/lib/firmware)'
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[oisS] - Build specified target only'
+	@echo  '  dir/file.ll     - Build the LLVM bitcode file'
+	@echo  '                    (requires a compiler support for LLVM bitcode generation)'
 	@echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
 	@echo  '                    (requires a recent binutils and recent build (System.map))'
 	@echo  '  dir/file.ko     - Build module including final link'
@@ -1483,6 +1485,10 @@ endif
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.symtypes: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
+%.ll: %.c prepare scripts FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
+%.ll: %.S prepare scripts FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 
 # Modules
 /: prepare scripts FORCE
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e677..4d97e4f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -174,6 +174,20 @@ cmd_cc_symtypes_c =                                                         \
 $(obj)/%.symtypes : $(src)/%.c FORCE
 	$(call cmd,cc_symtypes_c)
 
+# LLVM bitcode
+# Generate .ll files from .s and .c
+quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
+      cmd_cc_ll_c = $(CC) $(c_flags) -emit-llvm -S -o $@ $<
+
+$(obj)/%.ll: $(src)/%.c FORCE
+	$(call if_changed_dep,cc_ll_c)
+
+quiet_cmd_as_ll_S = CPP $(quiet_modtag) $@
+      cmd_as_ll_S = $(CPP) $(a_flags)   -o $@ $<
+
+$(obj)/%.ll: $(src)/%.S FORCE
+	$(call if_changed_dep,as_ll_S)
+
 # C (.c) files
 # The C file is compiled and updated dependency information is generated.
 # (See cmd_cc_o_c + relevant part of rule_cc_o_c)
-- 
2.0.1

