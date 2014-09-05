Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaIEGui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:50:38 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46052 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaIEGsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:48:55 -0400
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 2/6] dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
Date: Fri,  5 Sep 2014 08:48:08 +0200
Message-Id: <1409899692-1455-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409899692-1455-1-git-send-email-rric@kernel.org>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

Move dtbs install rules to Makefile.dtbinst. This change is needed to
implement support for dts vendor subdirs. The change makes Makefiles
easier and smaller as no longer the dtbs_install rule needs to be
defined. Another advantage is that install goals are not encoded in
targets anymore (%.dtb_dtbinst_).

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm/Makefile            |  6 +++++-
 arch/arm/boot/dts/Makefile   |  2 --
 arch/arm64/Makefile          |  6 +++++-
 arch/arm64/boot/dts/Makefile |  2 --
 scripts/Kbuild.include       |  6 ++++++
 scripts/Makefile.dtbinst     | 38 ++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.lib         | 12 ------------
 7 files changed, 54 insertions(+), 18 deletions(-)
 create mode 100644 scripts/Makefile.dtbinst

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 0ce9d0f71f2a..1963d9a9a2c4 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -313,9 +313,13 @@ $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
 PHONY += dtbs dtbs_install
-dtbs dtbs_install: prepare scripts
+
+dtbs: prepare scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
 
+dtbs_install:
+	$(Q)$(MAKE) $(dtbinst)=$(boot)/dts MACHINE=$(MACHINE)
+
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b8c5cd3ddeb9..ab40afb87fb2 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -502,5 +502,3 @@ dtbs: $(addprefix $(obj)/, $(dtb-y))
 	$(Q)rm -f $(obj)/../*.dtb
 
 clean-files := *.dtb
-
-dtbs_install: $(addsuffix _dtbinst_, $(dtb-y))
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index e0a8292bc832..1627861e9bbd 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -72,9 +72,13 @@ zinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
 
 PHONY += dtbs dtbs_install
-dtbs dtbs_install: prepare scripts
+
+dtbs: prepare scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts $@
 
+dtbs_install:
+	$(Q)$(MAKE) $(dtbinst)=$(boot)/dts
+
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index 82e1c4cf8780..0a14c3828301 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -7,5 +7,3 @@ targets += $(dtb-y)
 dtbs: $(addprefix $(obj)/, $(dtb-y))
 
 clean-files := *.dtb
-
-dtbs_install: $(addsuffix _dtbinst_, $(dtb-y))
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 8a9a4e1c7eab..861f5b4d48a2 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -179,6 +179,12 @@ build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 # $(Q)$(MAKE) $(modbuiltin)=dir
 modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
 
+###
+# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.dtbinst obj=
+# Usage:
+# $(Q)$(MAKE) $(dtbinst)=dir
+dtbinst := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.dtbinst obj
+
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
 addtree = $(if $(patsubst -I%,%,$(1)), \
diff --git a/scripts/Makefile.dtbinst b/scripts/Makefile.dtbinst
new file mode 100644
index 000000000000..54286cccc289
--- /dev/null
+++ b/scripts/Makefile.dtbinst
@@ -0,0 +1,38 @@
+# ==========================================================================
+# Installing dtb files
+#
+# Installs all dtb files listed in $(dtb-y) either in the
+# INSTALL_DTBS_PATH directory or the default location:
+#
+#   $INSTALL_PATH/dtbs/$KERNELRELEASE
+#
+# ==========================================================================
+
+src := $(obj)
+
+PHONY := __dtbs_install
+__dtbs_install:
+
+include include/config/auto.conf
+include scripts/Kbuild.include
+include $(srctree)/$(obj)/Makefile
+
+PHONY += __dtbs_install_prep
+__dtbs_install_prep:
+	$(Q)if [ -d $(INSTALL_DTBS_PATH).old ]; then rm -rf $(INSTALL_DTBS_PATH).old; fi
+	$(Q)if [ -d $(INSTALL_DTBS_PATH) ]; then mv $(INSTALL_DTBS_PATH) $(INSTALL_DTBS_PATH).old; fi
+	$(Q)mkdir -p $(INSTALL_DTBS_PATH)
+
+dtbinst-files	:= $(dtb-y)
+
+# Helper targets for Installing DTBs into the boot directory
+quiet_cmd_dtb_install =	INSTALL $<
+      cmd_dtb_install =	cp $< $(2)
+
+$(dtbinst-files): %.dtb: $(obj)/%.dtb | __dtbs_install_prep
+	$(call cmd,dtb_install,$(INSTALL_DTBS_PATH))
+
+PHONY += $(dtbinst-files)
+__dtbs_install: $(dtbinst-files)
+
+.PHONY: $(PHONY)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 260bf8acfce9..83a453794266 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -274,18 +274,6 @@ $(obj)/%.dtb: $(src)/%.dts FORCE
 
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts.tmp)
 
-# Helper targets for Installing DTBs into the boot directory
-quiet_cmd_dtb_install =	INSTALL $<
-      cmd_dtb_install =	cp $< $(2)
-
-_dtbinst_pre_:
-	$(Q)if [ -d $(INSTALL_DTBS_PATH).old ]; then rm -rf $(INSTALL_DTBS_PATH).old; fi
-	$(Q)if [ -d $(INSTALL_DTBS_PATH) ]; then mv $(INSTALL_DTBS_PATH) $(INSTALL_DTBS_PATH).old; fi
-	$(Q)mkdir -p $(INSTALL_DTBS_PATH)
-
-%.dtb_dtbinst_: $(obj)/%.dtb _dtbinst_pre_
-	$(call cmd,dtb_install,$(INSTALL_DTBS_PATH))
-
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
2.0.1

