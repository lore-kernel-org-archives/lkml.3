Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbaGSBfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 21:35:10 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:47935 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbaGSBfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 21:35:08 -0400
From: =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] kbuild: add support to generate LLVM bitcode files
Date: Fri, 18 Jul 2014 22:34:37 -0300
Message-Id: <1405733677-16650-1-git-send-email-viniciustinti@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows kbuild to generate LLVM bitcode files with the .ll extension when
building with Clang.

  # c code
  CC=clang make kernel/pid.ll

  # asm code
  CC=clang make arch/arm/kernel/calls.ll

Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 Makefile               |  7 +++++++
 scripts/Makefile.build | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/Makefile b/Makefile
index f3c543d..4eb0d14 100644
--- a/Makefile
+++ b/Makefile
@@ -1484,6 +1484,13 @@ endif
 %.symtypes: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 
+ifeq ($(COMPILER),clang)
+%.ll: %.c prepare scripts FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
+%.ll: %.S prepare scripts FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
+endif
+
 # Modules
 /: prepare scripts FORCE
 	$(cmd_crmodverdir)
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e677..9ea19d6 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -174,6 +174,14 @@ cmd_cc_symtypes_c =                                                         \
 $(obj)/%.symtypes : $(src)/%.c FORCE
 	$(call cmd,cc_symtypes_c)
 
+ifeq ($(COMPILER),clang)
+quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
+cmd_cc_ll_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -emit-llvm -S -o $@ $<
+
+$(obj)/%.ll: $(src)/%.c FORCE
+	$(call if_changed_dep,cc_ll_c)
+endif
+
 # C (.c) files
 # The C file is compiled and updated dependency information is generated.
 # (See cmd_cc_o_c + relevant part of rule_cc_o_c)
@@ -315,6 +323,16 @@ quiet_cmd_asn1_compiler = ASN.1   $@
 $(obj)/%-asn1.c $(obj)/%-asn1.h: $(src)/%.asn1 $(objtree)/scripts/asn1_compiler
 	$(call cmd,asn1_compiler)
 
+# LLVM bitcode
+# ---------------------------------------------------------------------------
+ifeq ($(COMPILER),clang)
+quiet_cmd_as_ll_S = CPP $(quiet_modtag) $@
+cmd_as_ll_S       = $(CPP) $(a_flags)   -o $@ $<
+
+$(obj)/%.ll: $(src)/%.S FORCE
+	$(call if_changed_dep,as_ll_S)
+endif
+
 # Build the compiled-in targets
 # ---------------------------------------------------------------------------
 
-- 
2.0.1

