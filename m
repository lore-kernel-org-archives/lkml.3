Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbaD2OJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:09:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360AbaD2OIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:08:24 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/5] firmware: Simplify directory creation
Date: Tue, 29 Apr 2014 16:08:09 +0200
Message-Id: <1398780493-15391-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the firmware blobs, use a simple loop to create
directories in $(objtree), like in Makefile.build. This simplifies the
rules and also makes it possible to set $(objtree) to '.' later. Before
this change, a dependency on $(objtree)/<dir> would be satisfied by
<dir> in $(srctree).

When installing the firmware blobs, call mkdir like in Makefile.modinst.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 firmware/Makefile       | 30 +++++-------------------------
 scripts/Makefile.fwinst | 24 +++++++++++-------------
 2 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/firmware/Makefile b/firmware/Makefile
index cbb09ce..6af62cf 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -138,12 +138,6 @@ fw-shipped-$(CONFIG_YAM) += yam/1200.bin yam/9600.bin
 
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
-# Directories which we _might_ need to create, so we have a rule for them.
-firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
-
-quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
-      cmd_mkdir = mkdir -p $@
-
 quiet_cmd_ihex  = IHEX    $@
       cmd_ihex  = $(OBJCOPY) -Iihex -Obinary $< $@
 
@@ -184,21 +178,10 @@ wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
 		include/config/superh32.h include/config/superh64.h \
 		include/config/x86_32.h include/config/x86_64.h)
 
-# Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
-# It'll end up depending on these targets, so make them a PHONY rule which
-# depends on _all_ the directories in $(firmware-dirs), and it'll work out OK.
-PHONY += $(objtree)/$$(%) $(objtree)/$(obj)/$$(%)
-$(objtree)/$$(%) $(objtree)/$(obj)/$$(%): $(firmware-dirs)
-	@true
-
-# For the $$(dir %) trick, where we need % to be expanded first.
-.SECONDEXPANSION:
-
-$(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps) \
-		| $(objtree)/$$(dir %)
+$(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps)
 	$(call cmd,fwbin,$(patsubst %.gen.S,%,$@))
 $(patsubst %,$(obj)/%.gen.S, $(fw-external-y)): %: $(wordsize_deps) \
-		include/config/extra/firmware/dir.h | $(objtree)/$$(dir %)
+		include/config/extra/firmware/dir.h
 	$(call cmd,fwbin,$(fwabs)/$(patsubst $(obj)/%.gen.S,%,$@))
 
 # The .o files depend on the binaries directly; the .S files don't.
@@ -207,7 +190,7 @@ $(patsubst %,$(obj)/%.gen.o, $(fw-external-y)): $(obj)/%.gen.o: $(fwdir)/%
 
 # .ihex is used just as a simple way to hold binary files in a source tree
 # where binaries are frowned upon. They are directly converted with objcopy.
-$(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%: $(obj)/%.ihex
 	$(call cmd,ihex)
 
 # Don't depend on ihex2fw if we're installing and it already exists.
@@ -226,16 +209,13 @@ endif
 # is actually meaningful, because the firmware has to be loaded in a certain
 # order rather than as a single binary blob. Thus, we convert them into our
 # more compact binary representation of ihex records (<linux/ihex.h>)
-$(obj)/%.fw: $(obj)/%.HEX $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.HEX $(ihex2fw_dep)
 	$(call cmd,ihex2fw)
 
 # .H16 is our own modified form of Intel HEX, with 16-bit length for records.
-$(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep)
 	$(call cmd,h16tofw)
 
-$(firmware-dirs):
-	$(call cmd,mkdir)
-
 obj-y				 += $(patsubst %,%.gen.o, $(fw-external-y))
 obj-$(CONFIG_FIRMWARE_IN_KERNEL) += $(patsubst %,%.gen.o, $(fw-shipped-y))
 
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 4d908d1..1a5639e 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -24,25 +24,23 @@ ifndef CONFIG_FIRMWARE_IN_KERNEL
 mod-fw += $(fw-shipped-y)
 endif
 
+ifneq ($(KBUILD_SRC),)
+# Create output directory if not already present
+_dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))
+
+firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
+# Create directories for firmware in subdirectories
+_dummy := $(foreach d,$(firmware-dirs), $(shell [ -d $(d) ] || mkdir -p $(d)))
+endif
+
 installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
-
-# Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
-PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
-$(INSTALL_FW_PATH)/$$(%): install-all-dirs
-	@true
-install-all-dirs: $(installed-fw-dirs)
-	@true
 
 quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
-      cmd_install = $(INSTALL) -m0644 $< $@
-
-$(installed-fw-dirs):
-	$(call cmd,mkdir)
+      cmd_install = mkdir -p $(@D); $(INSTALL) -m0644 $< $@
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/%
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
-- 
1.9.2

