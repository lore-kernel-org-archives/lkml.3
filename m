Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3BLWDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:03:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34439 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3BLWDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:03:49 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] kbuild: limit dtc+cpp include path
Date: Tue, 12 Feb 2013 15:03:37 -0700
Message-Id: <1360706617-20276-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Device tree source files may now include header files. The intent is
that those header files define/name constants used as part of the DT
bindings. Currently this feature is open to abuse, since any kernel
header file at all can be included, This could allow device tree files
to become dependant on kernel headers files, and thus make them no
longer OS-independent. This would also prevent separating the device
tree source files from the kernel repository.

Solve this by limiting the cpp include path for device tree files to
separate directories.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Here, I allow header files in the .dts source directory, or in a per-arch
include directory. Perhaps rather than:

-I$(srctree)/arch/$(SRCARCH)/include/dts

The following might be better?:

-I$(srctree)/Documentation/devicetree/bindings

i.e. is there a need to separate binding-related headers per arch?

 scripts/Makefile.lib |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7910229..07125e6 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -156,6 +156,11 @@ cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
 
+dtc_cpp_flags  = -Wp,-MD,$(depfile) -nostdinc                            \
+		 -I$(srctree)/arch/$(SRCARCH)/boot/dts                   \
+		 -I$(srctree)/arch/$(SRCARCH)/include/dts                \
+		 -undef -D__DTS__
+
 # Finds the multi-part object the current object will be linked into
 modname-multi = $(sort $(foreach m,$(multi-used),\
 		$(if $(filter $(subst $(obj)/,,$*.o), $($(m:.o=-objs)) $($(m:.o=-y))),$(m:.o=))))
@@ -272,8 +277,7 @@ $(obj)/%.dtb: $(src)/%.dts FORCE
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
 
 quiet_cmd_dtc_cpp = DTC+CPP $@
-cmd_dtc_cpp = $(CPP) $(cpp_flags) -x assembler-with-cpp -undef -D__DTS__  \
-			-o $(dtc-tmp) $< ; \
+cmd_dtc_cpp = $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ; \
 	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
 
 $(obj)/%.dtb: $(src)/%.dtsp FORCE
-- 
1.7.10.4

