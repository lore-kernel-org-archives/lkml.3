Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3EHLuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:50:14 -0400
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:50981 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754403Ab3EHLuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:50:11 -0400
X-Greylist: delayed 2153 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 07:50:11 EDT
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kbuild@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Stephen Warren <swarren@nvidia.com>,
        Matthijs Kooijman <matthijs@stdin.nl>
Subject: [PATCH] kbuild: Don't assume dts files live in arch/*/boot/dts
Date: Wed,  8 May 2013 12:59:04 +0200
Message-Id: <1368010744-11281-1-git-send-email-matthijs@stdin.nl>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit b40b25ff (kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp),
dts building was changed to always use the C preprocessor. This meant
that the .dts file passed to dtc is not the original, but the
preprocessed one.

When compiling with a separate build directory (i.e., with O=), this
preprocessed file will not live in the same directory as the original.
When the .dts file includes .dtsi files, dtc will look for them in the
build directory, not in the source directory and compilation will fail.

The commit referenced above tried to fix this by passing arch/*/boot/dts
as an include path to dtc. However, for mips, the .dts files are not in
this directory, so dts compilation on mips breaks for some targets.

Instead of hardcoding this particular include path, this commit just
uses the directory of the .dts file that is being compiled, which
effectively restores the previous behaviour wrt includes. For most .dts
files, this path is just the same as the previous hardcoded
arch/*/boot/dts path.

This was tested on a mips (rt3052) and an arm (bcm2835) target.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
---
 scripts/Makefile.lib | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 51bb3de..8337663 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -264,7 +264,7 @@ $(obj)/%.dtb.S: $(obj)/%.dtb
 quiet_cmd_dtc = DTC     $@
 cmd_dtc = $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ; \
 	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 \
-		-i $(srctree)/arch/$(SRCARCH)/boot/dts $(DTC_FLAGS) \
+		-i $(dir $<) $(DTC_FLAGS) \
 		-d $(depfile).dtc $(dtc-tmp) ; \
 	cat $(depfile).pre $(depfile).dtc > $(depfile)
 
-- 
1.8.0

