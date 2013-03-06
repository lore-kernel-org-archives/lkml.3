Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3CFSXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:23:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41756 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3CFSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:23:17 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: arm@kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Michal Marek <mmarek@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kbuild@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 4/7] kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp
Date: Wed,  6 Mar 2013 11:23:00 -0700
Message-Id: <1362594183-21523-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362594183-21523-1-git-send-email-swarren@wwwdotorg.org>
References: <1362594183-21523-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Replace cmd_dtc with cmd_dtc_cpp, and delete the latter.

Previously, a special file extension (.dtsp) was required to trigger
the C pre-processor to run on device tree files. This was ugly. Now that
previous changes have enhanced cmd_dtc_cpp to collect dependency
information from both gcc -E and dtc, we can transparently run the pre-
processor on all device tree files, irrespective of whether they

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 scripts/Makefile.lib |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 6104335..ee5cfc4 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -269,21 +269,15 @@ $(obj)/%.dtb.S: $(obj)/%.dtb
 	$(call cmd,dt_S_dtb)
 
 quiet_cmd_dtc = DTC     $@
-cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile) $<
+cmd_dtc = $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ; \
+	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile).dtc $(dtc-tmp) ; \
+	cat $(depfile).pre $(depfile).dtc > $(depfile)
 
 $(obj)/%.dtb: $(src)/%.dts FORCE
 	$(call if_changed_dep,dtc)
 
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
 
-quiet_cmd_dtc_cpp = DTC+CPP $@
-cmd_dtc_cpp = $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ; \
-	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile).dtc $(dtc-tmp) ; \
-	cat $(depfile).pre $(depfile).dtc > $(depfile)
-
-$(obj)/%.dtb: $(src)/%.dtsp FORCE
-	$(call if_changed_dep,dtc_cpp)
-
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
1.7.10.4

