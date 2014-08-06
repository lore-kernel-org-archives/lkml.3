Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaHFWap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:30:45 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57441 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaHFWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:30:44 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 6 Aug 2014 15:30:34 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86, platform, kconfig: move kvmconfig functionality to
 a helper
Message-ID: <20140806223032.GA3517@jtriplet-mobl1>
References: <20140806222419.GA2566@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806222419.GA2566@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new mergeconfig helper makes it easier to add other partial
configurations similar to kvmconfig.

Based on a patch by Luis R. Rodriguez <mcgrof@suse.com>.
Originally-Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Modified to make the helper name more general than just virtualization,
and factor out more of the common file path.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Hopefully the above changelog message makes the origin of this patch
clear; it didn't seem appropriate to keep a Signed-off-by when modifying
the patch, but I wanted to preserve the credit.

 arch/x86/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c65fd96..1568678 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -247,11 +247,15 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+define mergeconfig
+$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
+$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/$(1).config
+$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
+endef
+
 PHONY += kvmconfig
 kvmconfig:
-	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
-	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
+	$(call mergeconfig,kvm_guest)
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
-- 
2.1.0.rc1

