Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3CUSYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:24:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50323 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3CUSXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:23:24 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST 3/7] kbuild: cmd_dtc_cpp: extract deps from both gcc -E and dtc
Date: Thu, 21 Mar 2013 12:23:10 -0600
Message-Id: <1363890194-31538-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org>
References: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Prior to this change, when compiling *.dts to *.dtb, the dependency
output from dtc would be used, and when compiling *.dtsp to *.dtb, the
dependency output from gcc -E alone would be used, despite dtc also
being invoked (on a temporary file that was guaranteed to have no
dependencies).

With this change, when compiling *.dtsp to *.dtb, the dependency files
from both gcc -E and dtc are used. This will allow cmd_dtc_cpp to
replace cmd_dtc in a future change. In turn, that will allow the C pre-
processor to be run transparently on *.dts, without the need to a
separate rule or file extension to trigger it.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 scripts/Makefile.lib |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index af35521..6104335 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -156,7 +156,7 @@ cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
 
-dtc_cpp_flags  = -Wp,-MD,$(depfile) -nostdinc                            \
+dtc_cpp_flags  = -Wp,-MD,$(depfile).pre -nostdinc                        \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts                   \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts/include           \
 		 -undef -D__DTS__
@@ -278,7 +278,8 @@ dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
 
 quiet_cmd_dtc_cpp = DTC+CPP $@
 cmd_dtc_cpp = $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ; \
-	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
+	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile).dtc $(dtc-tmp) ; \
+	cat $(depfile).pre $(depfile).dtc > $(depfile)
 
 $(obj)/%.dtb: $(src)/%.dtsp FORCE
 	$(call if_changed_dep,dtc_cpp)
-- 
1.7.10.4

