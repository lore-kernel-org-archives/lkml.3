Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaFISgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:36:36 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56574 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFISge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:36:34 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 1/3] x86, platform, xen, kconfig: move kvmconfig functionality to a helper
Date: Mon,  9 Jun 2014 11:36:22 -0700
Message-Id: <1402338984-9774-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This can then be used by other virtual configs.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/x86/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 33f71b0..c78747b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -250,11 +250,15 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+define build-virtconfig
+$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
+$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/$(1)
+$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
+endef
+
 PHONY += kvmconfig
 kvmconfig:
-	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
-	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
+	$(call build-virtconfig,kvm_guest.config)
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
-- 
2.0.0.rc3.18.g00a5b79

