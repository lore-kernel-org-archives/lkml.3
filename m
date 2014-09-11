Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaIKXNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:13:21 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:40102 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaIKXNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:13:20 -0400
From: =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Behan Webster <behanw@converseincode.com>,
        Zhao Gang <gamerh2o@gmail.com>, Borislav Petkov <bp@suse.de>,
        Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
Subject: [PATCH v3] kbuild: add support to generate LLVM bitcode files
Date: Thu, 11 Sep 2014 20:13:00 -0300
Message-Id: <1410477180-1328-1-git-send-email-viniciustinti@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <CALD9WKzGmCeCPdwO4hCMtAjEjFoB8=oiQjUktT4PN4ewtDY7XA@mail.gmail.com>
References: <CALD9WKzGmCeCPdwO4hCMtAjEjFoB8=oiQjUktT4PN4ewtDY7XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows kbuild to generate LLVM bitcode files using '.ll' suffix.

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
index e213b27..823b9d6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -32,6 +32,7 @@
 *.lzo
 *.patch
 *.gcno
+*.ll
 modules.builtin
 Module.symvers
 *.dwo
diff --git a/Makefile b/Makefile
index 1a60bdd..cd4a120 100644
--- a/Makefile
+++ b/Makefile
@@ -1250,6 +1250,8 @@ help:
 	@echo  '                    (default: $$(INSTALL_MOD_PATH)/lib/firmware)'
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[oisS] - Build specified target only'
+	@echo  '  dir/file.ll     - Build the LLVM bitcode file'
+	@echo  '                    (requires compiler support for LLVM bitcode generation)'
 	@echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
 	@echo  '                    (requires a recent binutils and recent build (System.map))'
 	@echo  '  dir/file.ko     - Build module including final link'
@@ -1526,6 +1528,10 @@ endif
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
2.1.0

