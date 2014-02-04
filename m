Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaBDMmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:42:00 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45830 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDMl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:41:58 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH] kbuild: dtbs_install: new make target
Date: Tue,  4 Feb 2014 12:41:40 +0000
Message-Id: <1391517700-13103-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140110182923.GM19878@titan.lakedaemon.net>
References: <20140110182923.GM19878@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Cooper <jason@lakedaemon.net>

Unlike other build products in the Linux kernel, there is no 'make
*install' mechanism to put devicetree blobs in a standard place.

This commit adds a new 'dtbs_install' make target which copies all of
the dtbs into the INSTALL_DTBS_PATH directory. INSTALL_DTBS_PATH can be
set before calling make to change the default install directory. If not
set then it defaults to:

	$INSTALL_PATH/dtbs/$KERNELRELEASE.

This is done to keep dtbs from different kernel versions separate until
things have settled down.  Once the dtbs are stable, and not so strongly
linked to the kernel version, the devicetree files will most likely move
to their own repo.  Users will need to upgrade install scripts at that
time.

v7: (reworked by Grant Likely)
- Moved rules from arch/arm/Makefile to arch/arm/boot/dts/Makefile so
  that each dtb install could have a separate target and be reported as
  part of the make output.
- Fixed dependency problem to ensure $KERNELRELEASE is calculated before
  attempting to install
- Removed option to call external script. Copying the files should be
  sufficient and a build system can post-process the install directory.
  Despite the fact an external script is used for installing the kernel,
  I don't think that is a pattern that should be encouraged. I would
  rather see buildroot type tools post process the install directory to
  rename or move dtb files after installing to a staging directory.
  - Plus it is easy to add a hook after the fact without blocking the
    rest of this feature.
- Move the helper targets into scripts/Makefile.lib with the rest of the
  common dtb rules

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>
---
 Makefile                   |  7 +++++++
 arch/arm/Makefile          |  7 ++++---
 arch/arm/boot/dts/Makefile |  4 +++-
 scripts/Makefile.lib       | 12 ++++++++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 606ef7c4a544..90556da6959d 100644
--- a/Makefile
+++ b/Makefile
@@ -727,6 +727,13 @@ export KBUILD_IMAGE ?= vmlinux
 export	INSTALL_PATH ?= /boot
 
 #
+# INSTALL_DTBS_PATH specifies a prefix for relocations required by build roots.
+# Like INSTALL_MOD_PATH, it isn't defined in the Makefile, but can be passed as
+# an argument if needed. Otherwise it defaults to the kernel install path
+#
+export INSTALL_DTBS_PATH ?= $(INSTALL_PATH)/dtbs/$(KERNELRELEASE)
+
+#
 # INSTALL_MOD_PATH specifies a prefix to MODLIB for module directory
 # relocations required by build roots.  This is not defined in the
 # makefile but the argument can be passed to make if needed.
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 08a9ef58d9c3..fddf4beaee45 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -310,9 +310,9 @@ $(INSTALL_TARGETS):
 %.dtb: | scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
-PHONY += dtbs
-dtbs: scripts
-	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) dtbs
+PHONY += dtbs dtbs_install
+dtbs dtbs_install: prepare scripts
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
 
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
@@ -331,6 +331,7 @@ define archhelp
   echo  '  bootpImage    - Combined zImage and initial RAM disk'
   echo  '                  (supply initrd image via make variable INITRD=<path>)'
   echo  '* dtbs          - Build device tree blobs for enabled boards'
+  echo  '  dtbs_install  - Install dtbs to $(INSTALL_DTBS_PATH)'
   echo  '  install       - Install uncompressed kernel'
   echo  '  zinstall      - Install compressed kernel'
   echo  '  uinstall      - Install U-Boot wrapped compressed kernel'
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9d6a8b485e0..649c8e345ac5 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -321,7 +321,7 @@ dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
 	zynq-zc706.dtb \
 	zynq-zed.dtb
 
-targets += dtbs
+targets += dtbs dtbs_install
 targets += $(dtb-y)
 endif
 
@@ -331,3 +331,5 @@ dtbs: $(addprefix $(obj)/, $(dtb-y))
 	$(Q)rm -f $(obj)/../*.dtb
 
 clean-files := *.dtb
+
+dtbs_install: $(addsuffix _dtbinst_, $(dtb-y))
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 49392ecbef17..d0c17a55a2f5 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -273,6 +273,18 @@ $(obj)/%.dtb: $(src)/%.dts FORCE
 
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts.tmp)
 
+# Helper targets for Installing DTBs into the boot directory
+quiet_cmd_dtb_install =	INSTALL $<
+      cmd_dtb_install =	cp $< $(2)
+
+_dtbinst_pre_:
+	$(Q)if [ -d $(INSTALL_DTBS_PATH).old ]; then rm -rf $(INSTALL_DTBS_PATH).old; fi
+	$(Q)if [ -d $(INSTALL_DTBS_PATH) ]; then mv $(INSTALL_DTBS_PATH) $(INSTALL_DTBS_PATH).old; fi
+	$(Q)mkdir -p $(INSTALL_DTBS_PATH)
+
+%.dtb_dtbinst_: $(obj)/%.dtb _dtbinst_pre_
+	$(call cmd,dtb_install,$(INSTALL_DTBS_PATH))
+
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
1.8.3.2

