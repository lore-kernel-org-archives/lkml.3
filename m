Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaHIAIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:08:12 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42020 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaHIAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:08:08 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 8 Aug 2014 17:07:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Sam Ravnborg <sam@ravnborg.org>, David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] x86, platform, kconfig: move kvmconfig functionality
 to a helper
Message-ID: <20140809000754.GA9341@jtriplet-mobl1>
References: <20140807190243.GA5580@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807190243.GA5580@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new mergeconfig helper makes it easier to add other partial
configurations similar to kvmconfig.  Architecture-independent portions
of those partial configurations should go in
kernel/configs/${name}.config, and architecture-dependent portions
should go in arch/${arch}/configs/${name}.config.

Based on a patch by Luis R. Rodriguez <mcgrof@suse.com>.
Originally-Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Modified to make the helper name more general than just virtualization,
support architecture-dependent and architecture-independent partial
configurations, move the helper and kvmconfig to
scripts/kconfig/Makefile, and factor out more of the common file path.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Note that this leaves kvm_guest.config in arch/x86/configs/ .  A KVM
expert is welcome to follow up with a patch splitting the options in
kvm_guest.config between arch/x86/configs/ and kernel/configs/ .

 arch/x86/Makefile        |  7 -------
 scripts/kconfig/Makefile | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c65fd96..fcc74b7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -247,12 +247,6 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
-PHONY += kvmconfig
-kvmconfig:
-	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
-	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
-
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
@@ -266,5 +260,4 @@ define archhelp
   echo  '                  bzdisk/fdimage*/isoimage also accept:'
   echo  '                  FDARGS="..."  arguments for the booted kernel'
   echo  '                  FDINITRD=file initrd for the booted kernel'
-  echo  '  kvmconfig	- Enable additional options for guest kernel support'
 endef
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 9c4d241..8083b94 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -104,6 +104,19 @@ endif
 %_defconfig: $(obj)/conf
 	$(Q)$< --defconfig=arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
+configfiles=$(wildcard $(srctree)/kernel/configs/$(1).config $(srctree)/arch/$(SRCARCH)/configs/$(1).config)
+
+define mergeconfig
+$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
+$(if $(call configfiles,$(1)),, $(error No configuration exists for this target on this architecture))
+$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(call configfiles,$(1))
+$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
+endef
+
+PHONY += kvmconfig
+kvmconfig:
+	$(call mergeconfig,kvm_guest)
+
 # Help text used by make help
 help:
 	@echo  '  config	  - Update current config utilising a line-oriented program'
@@ -124,6 +137,7 @@ help:
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
+	@echo  '  kvmconfig	  - Enable additional options for guest kernel support'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
-- 
2.1.0.rc1

